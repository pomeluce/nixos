# NVIDIA GPU 直通（热切换 + Looking Glass）

本文档记录在一台 **Intel 核显 + NVIDIA 独显** 笔记本（MUXless，显示输出走核显）上做 GPU 直通的完整方案：**热切换**（VM 运行时 nvidia 给 VM，VM 关闭后还给宿主机）+ **Looking Glass**（低延迟画面回传）。

基础 KVM 使用见 [kvm.md](./kvm.md)。

## 方案对比

|             | 冷切换                         | 热切换（本仓库）                            |
| ----------- | ------------------------------ | ------------------------------------------- |
| 原理        | 启动时 `vfio-pci.ids` 抢占 GPU | nvidia 正常加载，VM 启动前 hook 切换给 vfio |
| 平时 nvidia | 不可用（被 vfio 占着）         | **宿主机可用**                              |
| VM 启动     | 直接用                         | hook 自动切换                               |
| 复杂度      | 简单                           | 中等（需 hook + niri 配置）                 |
| 适用        | nvidia 专门给 VM               | 平时用核显，nvidia VM/CUDA 共享             |

本仓库采用**热切换**。

## 前提

1. **双显卡**：Intel 核显（iGPU）+ NVIDIA 独显（dGPU）
2. **IOMMU 支持**：BIOS 开启 `Intel VT-d` / `AMD-Vi`
3. **MUXless 或混合模式**：显示输出走核显（笔记本常见）
4. **内核参数 `intel_iommu=on`**（`virt.nix` 已配）

确认 IOMMU 已开启：

```bash
sudo dmesg | grep -e DMAR -e IOMMU
# 有 "DMAR: IOMMU enabled" 即开启
```

确认 nvidia 的 IOMMU 分组（显卡 + 音频应在同一组或各自独立组）：

```bash
for d in /sys/kernel/iommu_groups/*/devices/*; do
    n=${d#*/iommu_groups/*}; n=${n%%/*}
    printf 'IOMMU Group %s ' "$n"
    lspci -nns "${d##*/}"
done | grep -i nvidia
```

## 核心原理

热切换的关键在于 **nvidia 驱动必须先正常加载并初始化 GPU 的 BAR**（特别是 8GB 的大 VRAM BAR）。如果用 `vfio-pci.ids` 在启动时抢占，vfio-pci 不会初始化 BAR，后续 VM 启动时 DMA 映射会失败。

所以流程是：

```
宿主机启动 → nvidia 驱动加载、初始化 BAR（BAR enabled）
         ↓
VM 启动 → libvirt hook（prepare）：nvidia → vfio-pci 切换（BAR 保持 enabled）
         ↓
VM 运行（GPU 直通）→ Looking Glass 回传画面
         ↓
VM 关闭 → libvirt hook（release）：vfio-pci → nvidia 切回
         ↓
宿主机恢复使用 nvidia
```

## 配置

### 1. `system/modules/virt.nix`（已配置）

- 内核参数：`intel_iommu=on`、`video=efifb:off`
- 嵌套虚拟化：`kvm nested=1`
- libvirt hook 脚本（见下方）
- Looking Glass client + `/dev/shm/looking-glass` tmpfiles

### 2. niri：忽略 nvidia DRM 设备（关键！）

niri（smithay）启动时会枚举所有 GPU 并打开设备 fd，导致 nvidia 被占用、无法 unbind。必须在 niri 配置里让它**忽略 nvidia 的 DRM 设备**。

先确认 nvidia 的 PCI 路径：

```bash
ls -l /dev/dri/by-path/
# 找到 nvidia 的 card 和 render，例如：
# pci-0000:01:00.0-card -> ../card0
# pci-0000:01:00.0-render -> ../renderD129
```

在 host 配置（如 `hosts/LTB16P/default.nix`）设 `niri.debug`：

```nix
programs.niri.debug = ''
  debug {
    ignore-drm-device "/dev/dri/by-path/pci-0000:01:00.0-card"
    ignore-drm-device "/dev/dri/by-path/pci-0000:01:00.0-render"
  }
'';
```

> ⚠️ 用 `ignore-drm-device`（忽略 nvidia），**不是** `render-drm-device`（指定渲染设备）——后者只控制渲染目标，niri 仍会枚举并打开 nvidia 的 EGL 设备，无法释放。

rebuild + 重新登录 niri，确认 niri 不再碰 nvidia：

```bash
sudo lsof /dev/nvidia* 2>/dev/null   # 应无输出
```

### 3. VM XML 配置

关键几项（`virsh edit <vm>`）：

**CPU 限制物理地址宽度**（解决 DMA 映射冲突，见下方常见问题）：

```xml
<cpu mode="host-passthrough" check="none" migratable="off">
  <topology sockets="1" dies="1" clusters="1" cores="6" threads="2"/>
  <maxphysaddr mode="passthrough" limit="39"/>
</cpu>
```

`limit` 值取宿主机 IOMMU 的地址宽度（`dmesg | grep "Host address width"`，本机为 39）。`migratable="off"` 关闭迁移（本地单机用不到，关闭后 guest 能看到完整 CPU 特性）。

**直通 GPU**（VGA + Audio，同一 IOMMU 组）：

```xml
<hostdev mode="subsystem" type="pci" managed="yes">
  <source><address domain="0x0000" bus="0x01" slot="0x00" function="0x0"/></source>
  <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
</hostdev>
<hostdev mode="subsystem" type="pci" managed="yes">
  <source><address domain="0x0000" bus="0x01" slot="0x00" function="0x1"/></source>
  <address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
</hostdev>
```

**移除虚拟显卡**（让 NVIDIA 成为主显示）：

```xml
<video><model type="none"/></video>
```

> 保留 `<graphics type="spice">` 和 `<channel type="spicevmc">`——Looking Glass 通过 SPICE 通道传鼠标键盘。

**Looking Glass 共享内存**：

```xml
<shmem name="looking-glass">
  <model type="ivshmem-plain"/>
  <size unit="M">128</size>
</shmem>
```

大小按分辨率定（1080p=32M，4K=128M）。

**关闭内存气球**（避免内存被宿主机回收影响性能）：

```xml
<memballoon model="none"/>
```

## libvirt hook（热切换脚本）

`virt.nix` 已部署 `/etc/libvirt/hooks/qemu`。脚本逻辑：

- **prepare**（VM 启动前）：杀 nvidia 进程 → 卸载 nvidia 模块 → `driver_override=vfio-pci` + `drivers_probe` 让 vfio 接管
- **release**（VM 关闭后）：解绑 vfio → 清除 `driver_override` → `drivers_probe` 让默认驱动（nvidia）重新绑定

脚本动态查找所有 nvidia PCI 设备（`lspci | grep NVIDIA`），无需硬编码 PCI 地址，通用。

查看 hook 日志：

```bash
journalctl -t kvm-gpu-hook
```

## Looking Glass（画面回传）

GPU 直通后 VM 渲染的画面需要回传到宿主机显示。Looking Glass 通过 IVSHMEM 共享内存，延迟极低。

### 1. 宿主机（已配）

`virt.nix` 已装 `looking-glass-client`，tmpfiles 创建 `/dev/shm/looking-glass`。

### 2. VM 内安装 Host

1. **IVSHMEM 驱动**：设备管理器 → 系统设备 → "PCI standard RAM Controller" → 更新驱动 → 指向 virtio-win ISO（含 IVSHMEM 驱动）
2. **Looking Glass Host**（B7，必须和 client 版本一致）：https://looking-glass.io/downloads
   - 以管理员身份运行 `looking-glass-host.exe install`（注册服务）
   - 装 [VC++ Redistributable](https://learn.microsoft.com/visualstudio/releases/)
3. **NVIDIA 驱动**：从官网装完整驱动（GeForce 40 Series Notebooks）

### 3. 启动客户端

```bash
looking-glass-client -F -S    # -F 全屏，-S 抑制屏保
```

按键捕获切换在 `~/.config/looking-glass/client.ini` 配 `escapeKey`（ keycode：F9=67 等）。

### 4. 无物理显示器的处理（dummy plug）

笔记本 dGPU 通常没有可访问的物理视频输出口。NVIDIA 没连显示器时，Windows 不会在它上面渲染桌面，host 捕获到空画面，且 console 会话会 `Console disconnected`。

**解决**：插一个 **HDMI dummy plug**（显示器欺骗器，十几块钱）到笔记本的 HDMI 口（前提：该 HDMI 口直连 dGPU，不是走核显——用 `ls /sys/class/drm/` 确认插上后 nvidia 的某个输出变 connected）。

插上 dummy 后，Windows 检测到"显示器"，桌面渲染到 nvidia，host 能正常捕获。

## 反作弊与伪装

部分游戏/软件（尤其带反作弊的联机游戏，如 EAC、BattlEye、Vanguard）会检测 VM 环境，检测到就拒绝运行或封号。需要隐藏 VM 特征。通用隐藏见 [kvm.md 的 KVM 隐藏](./kvm.md#kvm-隐藏防-vm-检测)，这里补充直通场景的伪装。

### 1. 隐藏 KVM + 关闭 vmport

```xml
<features>
  <kvm><hidden state="on"/></kvm>
  <vmport state="off"/>
</features>
```

### 2. Hyper-V vendor_id 伪装

让 guest 的 Hyper-V 接口报告一个自定义 vendor（而非默认暴露 KVM）：

```xml
<hyperv>
  <vendor_id state="on" value="任意12字符"/>   <!-- 如 "Generic12345" -->
</hyperv>
```

### 3. SMBIOS / OEM 字符串伪装

伪造 SMBIOS，让 guest 看起来像真实物理机：

```xml
<os>
  <smbios mode="host"/>   <!-- 复制宿主机真实 SMBIOS -->
</os>
```

或 `mode="sysinfo"` 配 `<sysinfo type="smbios">` 自定义制造商/产品名。

### 4. 假电池（Optimus 笔记本 Code 43）

NVIDIA 移动 GPU 驱动会检测电池，VM 里没有电池 → Code 43（驱动加载失败）。加 ACPI 假电池表：

```xml
<domain type="kvm" xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0">
  ...
  <qemu:commandline>
    <qemu:arg value="-acpitable"/>
    <qemu:arg value="file=/path/to/SSDT1.dat"/>
  </qemu:commandline>
</domain>
```

`SSDT1.dat` 是预生成的 ACPI 表（base64 内容见 [ArchWiki 对应章节](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#"Error_43:_Driver_failed_to_load"_with_mobile_(Optimus/max-q)_nvidia_GPUs)）。

### 5. 反作弊兼容性现状

| 反作弊 | VM 兼容性 |
|--------|-----------|
| **EAC** (Easy Anti-Cheat) | 一般不因 VM 封号 |
| **BattlEye** | 部分游戏可能限制 |
| **Vanguard** (Valorant) | 通常拒绝 VM |
| **nProtect** 等 | 视游戏而定 |

> 没有绝对方案——即使隐藏了 VM 特征，高级反作弊仍可能通过时序、设备指纹等渠道检测。联机竞技游戏建议谨慎。

## 性能优化（GPU 直通场景）

GPU 直通对延迟极敏感（游戏/实时渲染），以下优化提升体验：

### CPU 绑定 + 核隔离

把 vCPU 绑到物理核，并隔离这些核避免宿主机抢占。宿主机内核参数（隔离核 2-7、10-15 给 VM）：

```
isolcpus=2-7,10-15 nohz_full=2-7,10-15 rcu_nocbs=2-7,10-15
```

VM XML 绑定（超线程配对）：

```xml
<vcpu placement="static">12</vcpu>
<cputune>
  <vcpupin vcpu="0" cpuset="2"/>
  <vcpupin vcpu="1" cpuset="10"/>
  <!-- 每个 vCPU 绑到一个逻辑核，超线程配对给同一物理核 -->
  <emulatorpin cpuset="0,1"/>   <!-- emulator/iothread 用保留核 -->
</cputune>
```

用 `lscpu -e` 查看物理核与超线程的对应关系（CORE 列），把同一物理核的两个逻辑线程配对。

### 巨页 + 内存锁定

```xml
<memoryBacking>
  <hugepages/>
  <locked/>          <!-- 锁定内存，禁止 swap -->
</memoryBacking>
```

### memballoon 必须禁用

直通场景气球回收内存会导致 VM 内存不足/碎片化，GPU 性能骤降，必须禁用：

```xml
<memballoon model="none"/>
```

> 关闭 memballoon 后，VM 的内存在运行期间被完全占满，但 VM 关闭后立即全部释放回宿主机。

更多通用优化（Hyper-V enlightenments、磁盘/网卡调优、时钟）见 [kvm.md 性能优化](./kvm.md#性能优化)。

## 常见问题（踩坑记录）

### `vfio: DMA mapping failed, unable to continue`

**根因**：`ivshmem`（Looking Glass 共享内存）+ GPU 大 BAR 的组合，让 QEMU 的 DMA 映射超出 IOMMU 地址宽度。

**解决**：VM XML 的 `<cpu>` 加 `<maxphysaddr mode="passthrough" limit="39"/>`（39 改为你机器的 IOMMU 地址宽度）。这是真正的解药——不要去折腾 `iommu=pt`、`pcie_aspm=off`、`pci=nocrs` 等内核参数，那些都是弯路。

> 如何判断：报错地址 `0x3820000000`（40 位）超出 39 位 IOMMU 上限。`maxphysaddr` 把 guest 物理地址宽度限制到 IOMMU 范围内即可。

### shmem 导致 VM 启动失败

加 Looking Glass 的 `<shmem>` 后 VM 启动报 DMA mapping failed，去掉 shmem 就能启动 → 就是上面的 `maxphysaddr` 问题。

### `IOMMU_IOAS_MAP failed: Bad address`（iommufd 后端）

iommufd 后端**不支持映射 PCI BAR 区域**，这是设计限制。直通大 BAR GPU 不要用 iommufd，用默认的 vfio type1 后端（不要在 XML 加 `<iommufd enabled="yes"/>`）。

### NVIDIA 驱动 Code 43

guest 里 NVIDIA 显卡有黄色感叹号。原因：

- 驱动检测到 VM（旧驱动）→ XML 加 `<kvm><hidden state="on"/></kvm>` 隐藏 KVM
- 没装假电池 → Optimus 笔记本驱动要检测电池，加 SSDT ACPI 表
- vBIOS 不兼容 UEFI → 用 romfile 加载 vBIOS

### IVSHMEM too small

`IVSHMEM too small Please increase the size to 128MiB` → VM XML 里 `<shmem>` 的 size 调大（1080p=32M，1440p=64M，4K=128M，4K HDR=256M）。

### IVSHMEM Permission denied

`/dev/shm/looking-glass` 权限不对（QEMU 以 root 创建成 root:root，client 无权读）。

**正确做法**：用 `truncate -s 128M` 扩展（保留 tmpfiles 设的权限），**不要 `rm`**（rm 后 QEMU 重新创建成 root）。

本仓库 `virt.nix` 的 tmpfiles 规则创建 `marcus:libvirtd 0660` 权限的文件，正常重启流程无此问题。

### `Console disconnected, shutting down`（host 反复退出）

host 日志显示 console 会话断开、host 退出。原因：**NVIDIA 没连显示器**（或被 RDP 抢占会话）。

- 插 HDMI dummy plug（见上文）
- **不要用普通 RDP** 连进 VM（会断开 console 会话，害死 host）。如必须用 RDP，加 `/admin` 连 console 会话。

### niri 占用 nvidia，unbind 卡住

`echo 0000:01:00.0 > /sys/bus/pci/drivers/nvidia/unbind` 卡住不返回。

**根因**：niri（smithay）启动时枚举所有 GPU，打开了 nvidia 的设备 fd。

**解决**：niri 配置加 `ignore-drm-device`（见上文配置第 2 步）。这是热切换能工作的**前提**。

### BAR disabled

`lspci -vvv` 看到 GPU BAR 显示 `[disabled]`。

- **vfio-pci.ids 抢占模式**下 BAR disabled 是正常的（vfio 没初始化），但配合 `maxphysaddr` VM 仍能启动
- **热切换模式**下，nvidia 驱动加载后 BAR 应该是 enabled 的；如果 disabled，说明 nvidia 没正常初始化

### hook 触发时机

libvirt hook 的 action：

- `prepare`：VM 启动前（设备分配前）
- `start`：VM 启动后
- `started`：guest 已启动
- `stopped`：guest 已停止
- `release`：VM 完全关闭后（设备释放）

热切换用 `prepare`（切到 vfio）和 `release`（切回 nvidia）。

## 调试命令速查

```bash
# 查看 GPU 当前绑定驱动
lspci -nnk -d 10de:28e0 | grep "in use"

# 查看 BAR 状态（enabled / disabled）
lspci -vvvs 01:00.0 | grep "Region 1"

# 查看 nvidia 模块引用计数
lsmod | grep "^nvidia"

# 查看谁占用了 nvidia 设备
sudo lsof /dev/nvidia*

# 手动切换到 vfio（调试用）
sudo fuser -k -9 /dev/nvidia*
sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia
echo "vfio-pci" | sudo tee /sys/bus/pci/devices/0000:01:00.0/driver_override
echo "0000:01:00.0" | sudo tee /sys/bus/pci/drivers_probe

# 查看 hook 日志
journalctl -t kvm-gpu-hook

# 查看 VM 启动日志
sudo tail /var/log/libvirt/qemu/<vm>.log
```

## 参考

- [PCI passthrough via OVMF — ArchWiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- [热切换显卡直通 — Shorin-ArchLinux-Guide](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide/blob/main/wiki/archlinux/热切换显卡直通.md)
- [Looking Glass 官方文档](https://looking-glass.io/docs)
- [NVIDIA GPU Passthrough on Optimus MUXless Laptop — Lantian](https://lantian.pub/en/article/modify-computer/laptop-intel-nvidia-optimus-passthrough.lantian/)
