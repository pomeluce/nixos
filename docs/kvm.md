# KVM 虚拟机

本仓库的虚拟化配置在 [`system/modules/virt.nix`](../system/modules/virt.nix)，通过 `mo.system.virt.enable` 开启。本文档介绍 KVM 虚拟化的基础使用。GPU 直通相关内容见 [passthrough.md](./passthrough.md)。

## 概念

| 组件             | 作用                                                                |
| ---------------- | ------------------------------------------------------------------- |
| **KVM**          | Linux 内核虚拟化模块，提供 CPU/内存的硬件辅助虚拟化（VT-x / AMD-V） |
| **QEMU**         | 用户态模拟器，配合 KVM 实现完整虚拟机（设备模拟）                   |
| **libvirt**      | 虚拟化管理 API 与守护进程（`libvirtd`），统一管理 QEMU/KVM 等       |
| **virt-manager** | libvirt 的图形前端，方便创建/管理虚拟机                             |
| **OVMF (edk2)**  | 开源 UEFI 固件，VM 的 UEFI 启动需要它                               |
| **swtpm**        | 软件 TPM 2.0 模拟器，Windows 11 需要                                |
| **virtio**       | 一套半虚拟化驱动（磁盘/网卡/显卡等），比全模拟性能好得多            |

## 启用

在 host 配置（如 `hosts/LTB16P/default.nix`）开启：

```nix
mo.system.virt.enable = true;
```

`virt.nix` 会自动：

- 安装 `qemu_kvm`、`virt-manager`、`swtpm`、`looking-glass-client`
- 启用 `libvirtd` 服务、SPICE USB 重定向、`spice-vdagentd`
- 设置内核参数 `intel_iommu=on`、`video=efifb:off`
- 开启嵌套虚拟化（`kvm_<intel|amd> nested=1`）

rebuild 生效：

```bash
sudo nixos-rebuild switch --flake .#LTB16P
```

## 网络

libvirt 默认提供 **NAT 网络**（名为 `default`），VM 通过它上网，IP 段通常是 `192.168.122.0/24`，网关 `192.168.122.1`。

首次使用需启动并设为自启：

```bash
sudo virsh net-start default
sudo virsh net-autostart default
```

查看网络状态：

```bash
sudo virsh net-list --all
```

### 桥接网络（可选）

NAT 够用就不需要桥接。桥接让 VM 直接接入物理网络（获得与宿主机同网段的独立 IP）。**无线网卡无法桥接**，需要有线网卡。

用 `nm-connection-editor` 添加网桥（bridge0）→ 把有线连接作为桥接端口。VM 网卡接到 bridge0。

## 权限

`virt.nix` 里 `runAsRoot = true`，QEMU 以 root 运行（GPU 直通 + Looking Glass 需要）。如需普通用户管理 VM，加入 `libvirt` 组：

```bash
sudo usermod -a -G libvirt $(whoami)
# 重新登录生效
```

> 注意：virt-manager 默认连接是**系统会话**（`qemu:///system`）。如果要用户会话，左上角新增一个 `qemu:///session` 连接。本仓库配置走系统会话。

## 创建 Windows 虚拟机

### 1. 准备镜像

- **Windows ISO**：从 [微软官网](https://www.microsoft.com/zh-cn/software-download/windows11) 或 [HelloWindows](https://hellowindows.cn/) 下载
- **virtio-win 驱动 ISO**：从 https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/ 下载最新版

### 2. 在 virt-manager 创建

新建虚拟机 → 导入 ISO → 勾选 **"安装前自定义配置"**。关键设置：

| 项目                | 推荐值                                              | 说明                                 |
| ------------------- | --------------------------------------------------- | ------------------------------------ |
| **固件 (Firmware)** | `UEFI x86_64: .../edk2-x86_64-code.fd`（非 secure） | Windows 11 必须 UEFI                 |
| **Chipset**         | Q35                                                 | 现代芯片组                           |
| **CPU Model**       | `host-passthrough`                                  | 暴露完整 CPU 特性                    |
| **磁盘总线**        | VirtIO                                              | 性能最好（安装时需加载 virtio 驱动） |
| **网卡型号**        | virtio                                              | 性能最好                             |
| **内存/CPU**        | 按需                                                | Windows 11 建议 ≥ 8GB / 4 核         |

### 3. 安装时加载 virtio 驱动

Windows 安装器选磁盘时，**看不到 VirtIO 磁盘**是正常的——点"加载驱动程序" → 浏览 virtio-win ISO → 选 `viostro\w11\amd64` 目录 → 加载后磁盘出现。

### 4. 装好系统后

进入 Windows 后，运行 virtio-win ISO 里的 `virtio-win-guest-tools.exe`，一次装齐所有 virtio 驱动（磁盘、网卡、QXL 显示、spice-vdagent 等）。

## 磁盘直通（整盘 / 分区）

把物理硬盘/分区直接给 VM，绕过镜像文件，性能更好。也可以直接启动物理硬盘上已安装的系统：

```xml
<disk type='block' device='disk'>
  <driver name='qemu' type='raw' cache='none' io='native' discard='unmap'/>
  <source dev='/dev/disk/by-id/nvme-XXX'/>
  <target dev='vda' bus='virtio'/>
</disk>
```

> **必须用 `/dev/disk/by-id/`**，不要用 `/dev/sda`——盘序可能变化，by-id 按硬件序列号定位，稳定。

切换引导磁盘总线（SATA → VirtIO）时，先在 Windows 里装好 virtio 存储驱动，否则切完启动蓝屏。

## 文件共享

### SMB（简单）

宿主机装 samba 并配置共享，VM 通过 `\\192.168.122.1` 访问。

### VirtIO-FS（性能更好）

VirtIO-FS 通过 virtiofsd 守护进程 + 共享内存，在宿主机和 VM 间高效共享目录，比 SMB 快得多（本机内存传输，接近原生 IO）。

#### 1. VM 配置共享内存（必需）

virtiofsd 需要访问 VM 内存，VM 必须配置共享内存后端：

```xml
<memoryBacking>
  <source type="memfd"/>      <!-- memfd 共享内存（推荐，无需磁盘文件） -->
  <access mode="shared"/>     <!-- 共享访问 -->
</memoryBacking>
```

> 用 memfd 时建议同时 `<memballoon model="none"/>`——气球回收和共享内存不兼容，可能报错。

#### 2. 添加 filesystem 设备（`virsh edit <vm>`）

```xml
<filesystem type="mount" accessmode="passthrough">
  <driver type="virtiofs"/>
  <source dir="/home/marcus/shared"/>    <!-- 宿主机共享目录（绝对路径） -->
  <target dir="myshare"/>                <!-- tag 名，guest 据此识别 -->
</filesystem>
```

| 属性         | 说明                                                                            |
| ------------ | ------------------------------------------------------------------------------- |
| `source dir` | 宿主机要共享的目录                                                              |
| `target dir` | **tag**（标识名，不是挂载路径）                                                 |
| `accessmode` | `passthrough`（性能最好，UID/GID 直接透传）/ `mapped`（映射）/ `squash`（匿名） |

> VirtIO-FS 不支持 `<filesystem bus>` 这种老式 9p 语法，必须 `<driver type="virtiofs"/>`。

#### 3. Windows guest 配置

1. 装 **virtio-win guest tools**（含 VirtIO-FS 驱动 `viofs`）
2. 装 **[WinFSP](https://winfsp.dev/rel/)**——VirtIO-FS 在 Windows 上依赖它提供 FUSE 能力
3. 启用 VirtIO-FS Service：
   - `services.msc`（或 `Win+R` → `services.msc`）→ 找 **"VirtIO-FS Service"**
   - 启动类型改为 **自动**
   - 手动启动一次该服务
4. 默认会把所有 VirtIO-FS tag 自动挂载为下一个可用盘符（如 `Z:`）。如需指定盘符，改注册表：
   ```
   HKLM\SOFTWARE\VirtioFS\VirtioFS
   ```

挂载后，宿主机 `/home/marcus/shared` 的内容就出现在 Windows 的对应盘符。

#### 4. Linux guest 挂载（参考）

```bash
mount -t virtiofs myshare /mnt/share
```

`/etc/fstab` 持久化：

```
myshare  /mnt/share  virtiofs  defaults  0  0
```

## 远程桌面 / 画面访问

| 方式                             | 适用场景                                                                          |
| -------------------------------- | --------------------------------------------------------------------------------- |
| **SPICE**（virt-manager 控制台） | 管理、装系统、轻量操作                                                            |
| **RDP**（Windows 远程桌面）      | 日常操作，网络串流                                                                |
| **Parsec**                       | 低延迟游戏串流（闭源）                                                            |
| **Sunshine + Moonlight**         | 开源低延迟串流                                                                    |
| **Looking Glass**                | GPU 直通场景，通过共享内存回传帧，延迟极低。见 [passthrough.md](./passthrough.md) |

## 性能优化

### Hyper-V enlightenments（Windows guest 关键）

Windows guest 启用 Hyper-V 半虚拟化扩展，显著降低虚拟化开销。在 `<features>` 配置：

```xml
<features>
  <acpi/>
  <apic/>
  <hyperv mode="custom">
    <relaxed state="on"/>            <!-- 放宽定时器检查，减少 guest 退出 -->
    <vapic state="on"/>              <!-- 虚拟 APIC，加速中断 -->
    <spinlocks state="on" retries="8191"/>
    <vpindex state="on"/>
    <runtime state="on"/>
    <synic state="on"/>
    <stimer state="on"/>
    <frequencies state="on"/>
    <tlbflush state="on"/>           <!-- 虚拟 TLB flush -->
    <ipi state="on"/>
    <evmcs state="on"/>              <!-- Enlightened VMCS -->
  </hyperv>
  <vmport state="off"/>              <!-- 关闭 VMware 端口模拟 -->
</features>
```

配合使用 `hypervclock` 时钟源（见下方时钟优化）。需要隐藏 VM 时用 `mode="custom"` 手动选，不要用 `passthrough`（会暴露全部）。

### KVM 隐藏（防 VM 检测）

隐藏 CPUID 的 hypervisor present bit，让 guest 不易检测到运行在 VM 中（部分软件/游戏要求）：

```xml
<features>
  <kvm>
    <hidden state="on"/>
  </kvm>
</features>
```

> 新版 libvirt 不再支持 `<hyperv><hidden state="on"/></hyperv>`，改用上面的 `<kvm><hidden state="on"/></kvm>`。

### CPU 优化

- **模式**：`host-passthrough`，完整暴露宿主机 CPU 特性（性能/兼容性最好）
- **拓扑**：匹配物理结构，避免 guest 调度器误判：

```xml
<cpu mode="host-passthrough" check="none">
  <topology sockets="1" dies="1" clusters="1" cores="6" threads="2"/>
</cpu>
```

- **vCPU 绑定（pinning）**：固定 vCPU 到物理核，减少调度迁移、提升缓存命中：

```xml
<vcpu placement="static">12</vcpu>
<cputune>
  <vcpupin vcpu="0" cpuset="2"/>
  <vcpupin vcpu="1" cpuset="10"/>
  <!-- 每对超线程绑到同一物理核的两个逻辑线程 -->
  <emulatorpin cpuset="0,1"/>   <!-- emulator/iothread 用保留核 -->
</cputune>
```

配合宿主机内核参数 `isolcpus=<核号>` 隔离这些核，避免宿主机进程抢占。

### 内存优化

- **禁用 memballoon**：气球驱动会让宿主机动态回收 VM 内存，引起性能波动和内存碎片。固定内存最稳：

```xml
<memballoon model="none"/>
```

- **巨页（hugepages）**：用 2M/1G 大页减少 TLB miss，对大内存 VM 提升明显。

#### 原理

默认内存页 4KB，16GB 内存 = 约 400 万页，CPU 的 TLB（地址翻译缓存）装不下这么多映射，频繁 miss 导致内存访问延迟增大。巨页把页大小放大（2M = 512 倍，1G = 26 万倍），同样内存对应的页数大幅减少，TLB 命中率显著提升，对大内存 VM 收益明显。

#### 页大小选择

- **2M 巨页**：所有 x86_64 支持，兼容性好，推荐入门
- **1G 巨页**：减少更多 TLB miss，但需要 CPU 支持 `pdpe1gb` 特性

确认 CPU 是否支持 1G 巨页：

```bash
grep pdpe1gb /proc/cpuinfo
# 有输出则支持 1G 巨页
```

#### 宿主机预留巨页

巨页必须**启动时预先预留**（运行时分配常因内存碎片失败）。

预留数量计算：

| 页大小 | 预留页数（16GB VM） | 公式            |
| ------ | ------------------- | --------------- |
| 2M     | 8192 页             | VM 内存(MB) / 2 |
| 1G     | 16 页               | VM 内存(GB)     |

在 host 配置（或 `virt.nix` 的 `boot.kernelParams`）加：

```nix
# 2M 巨页示例（16GB VM = 8192 页）
boot.kernelParams = [ "hugepagesz=2M" "hugepages=8192" ];

# 或 1G 巨页示例（16GB VM = 16 页）
boot.kernelParams = [ "default_hugepagesz=1G" "hugepagesz=1G" "hugepages=16" ];
```

预留前清理内存碎片可提升成功率（运行时分配时有用，内核参数预留不需要）：

```bash
sudo sync
echo 3 | sudo tee /proc/sys/vm/drop_caches
echo 1 | sudo tee /proc/sys/vm/compact_memory
```

确认预留成功：

```bash
cat /proc/meminfo | grep HugePages
# HugePages_Total 应等于预留数量
```

> ⚠️ **巨页内存独占**：即使 VM 没运行，预留的这部分内存也不可用于其他进程。16GB VM 预留 16×1G，宿主机就少 16GB 可用。预留大小**宁少勿多**——预留不足 VM 启动失败，预留多了浪费宿主机内存。精确匹配 VM 内存最稳。

#### VM XML 配置

```xml
<memoryBacking>
  <hugepages>
    <page size="1" unit="G"/>   <!-- 明确页大小：1G 或 2M，须与宿主机预留一致 -->
  </hugepages>
  <locked/>          <!-- 锁定内存，禁止 swap（巨页 + GPU 直通常配） -->
</memoryBacking>
```

> ⚠️ **必须用 `<page>` 明确页大小**。只写 `<hugepages/>` 会用宿主机默认巨页（`default_hugepagesz`，通常 2M）——如果你在宿主机预留了 1G 巨页，VM 却用了 2M，1G 预留用不上，VM 反而可能因 2M 巨页不足启动失败。`size` 必须和宿主机 `hugepagesz` 严格一致。NUMA 场景可加 `nodeset="0"` 指定节点。

#### 验证

VM 启动后，宿主机看巨页占用：

```bash
cat /proc/meminfo | grep HugePages
# HugePages_Free 应减少（被 VM 占用了）
```

Linux guest 内确认：

```bash
cat /proc/meminfo | grep Huge
```

### 磁盘 IO 优化

```xml
<iothreads>1</iothreads>
<disk type='block' device='disk'>
  <driver name='qemu' type='raw' cache='none' io='native' discard='unmap' iothread='1'/>
  <source dev='/dev/disk/by-id/...'/>
  <target dev='vda' bus='virtio'/>
</disk>
```

- `cache='none' io='native'`：绕过宿主机 page cache，用 Linux AIO，性能最好（块设备直通必选）
- `iothread='1'`：独立 IO 线程处理，不阻塞 vCPU
- `discard='unmap'`：支持 TRIM，SSD 友好
- 多 vCPU 时 virtio 盘可加 `queues='4'` 多队列加速

### 网卡优化

```xml
<interface type='network'>
  <model type='virtio'/>
  <driver name='vhost' queues='4'/>   <!-- vhost-net 内核加速 + multiqueue -->
</interface>
```

### 时钟与定时器

```xml
<clock offset="localtime">
  <timer name="rtc" tickpolicy="catchup"/>
  <timer name="pit" tickpolicy="delay"/>
  <timer name="hpet" present="no"/>        <!-- HPET 性能差，禁用 -->
  <timer name="hypervclock" present="yes"/> <!-- 配合 Hyper-V enlightenments -->
</clock>
```

## 嵌套虚拟化

`virt.nix` 已配置 `kvm nested=1`，VM 内可以再跑 KVM（如 Android 模拟器、WSL2 等）。

## 常用 virsh 命令

```bash
virsh list --all              # 列出所有 VM（含已关机）
virsh start <vm>              # 启动
virsh shutdown <vm>           # 正常关机（ guest 响应 ACPI）
virsh destroy <vm>            # 强制关机（相当于拔电源）
virsh reboot <vm>             # 重启
virsh console <vm>            # 串口控制台
virsh dumpxml <vm>            # 查看 XML 配置
virsh edit <vm>               # 编辑持久化配置（推荐用这个，而非 virt-manager GUI）
virsh net-list --all          # 列出网络
virsh net-start default       # 启动 default 网络
```

查看 VM 运行日志（排错必备）：

```bash
sudo tail -f /var/log/libvirt/qemu/<vm>.log
```

## 排错

### VM 启动失败

看 `/var/log/libvirt/qemu/<vm>.log`，关键看 `error` / `failed` / `hardware error` 行。

### OVMF 固件相关报错

新版 NixOS 的 `virtualisation.libvirtd.qemu.ovmf` 子模块已移除，OVMF 固件随 QEMU 自带，不需要再配 `ovmf.enable` / `ovmf.packages`。

### 鼠标在 Windows 里点击无反应

装 virtio-win guest tools 里的 spice-vdagent。或检查 VM XML 输入设备（保留 USB tablet）。
