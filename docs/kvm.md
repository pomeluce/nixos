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

两种典型场景：

- **方式 A：全新安装**——从 Windows ISO 装到虚拟镜像（或物理磁盘）
- **方式 B：导入现有系统**——物理硬盘上已经装好的 Windows，直接启动它（双系统共用一块盘，不用重装）

### 准备

- **Windows ISO**（仅方式 A 需要）：[微软官网](https://www.microsoft.com/zh-cn/software-download/windows11) 或 [HelloWindows](https://hellowindows.cn/)
- **virtio-win 驱动 ISO**（两种方式都要，用来装 virtio 驱动）：https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/ 下最新版

### 关键配置（两种方式通用）

创建 VM 时勾选 **"安装前自定义配置"**，在配置界面设好：

| 项目                | 推荐值                                              | 说明                                                    |
| ------------------- | --------------------------------------------------- | ------------------------------------------------------- |
| **固件 (Firmware)** | `UEFI x86_64: .../edk2-x86_64-code.fd`（非 secure） | Win11 必须 UEFI；导入现有系统要和原系统一致（GPT→UEFI） |
| **Chipset**         | Q35                                                 | 现代芯片组                                              |
| **CPU Model**       | `host-passthrough`                                  | 暴露完整 CPU 特性                                       |
| **磁盘总线**        | VirtIO（首选）/ SATA                                | VirtIO 性能最好但需先装驱动；没装前用 SATA              |
| **网卡型号**        | virtio                                              | 性能最好                                                |
| **内存/CPU**        | 按需                                                | Windows 11 建议 ≥ 8GB / 4 核                            |

### 方式 A：全新安装（从 ISO）

全新安装可以**直接用 VirtIO 磁盘**——安装过程中一次性把 virtio 驱动装上，装完就是 VirtIO 模式，无需事后从 SATA 切换。

#### 1. 准备镜像

- **Windows 11 ISO**：[微软官网](https://www.microsoft.com/zh-cn/software-download/windows11) 或 [HelloWindows](https://hellowindows.cn/)
- **virtio-win 驱动 ISO**：https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/ 下最新稳定版

#### 2. virt-manager 新建向导

1. virt-manager → **文件 → 新建虚拟机**
2. 选 **"本地安装介质（ISO 镜像或 CDROM）"** → 前进
3. **浏览**选 Windows ISO（或手动输入路径）→ 确认自动检测出操作系统类型 → 前进
4. 内存 / CPU：
   - 内存 **≥ 4096 MB**（建议 8192+）
   - CPU **≥ 2**（建议 4+）→ 前进
5. 存储：**创建磁盘镜像**，大小 **≥ 60 GB** → 前进
6. 命名（如 `Windows11`）
7. **勾选 "安装前自定义配置"** → 完成 → 进入硬件配置界面（VM 还没启动）

#### 3. 自定义硬件配置

逐项检查/修改（左侧是设备列表，右侧是配置）：

**Overview（总览）**

- **Firmware**：下拉选 `UEFI x86_64: /run/libvirt/nix-ovmf/edk2-x86_64-code.fd`（**不要选带 secure-boot 的**，否则装系统会很折腾）
- **Chipset**：Q35（默认）

**CPU**

- **Model**：手输 `host-passthrough`（下拉列表里没有就自己打）
- 展开 **Topology** → 勾选 "Manually set CPU topology" → 按物理核填（如 `sockets=1 cores=6 threads=2`）

**Memory**：确认大小无误

**Disk x（磁盘）**

- **Disk bus**：改为 **VirtIO**
- 展开 Advanced：`cache=none`、`io=native`（块设备直通才需要；qcow2 镜像保持默认即可）

**CDROM 1（SATA 光驱）**：确认挂的是 Windows ISO

**添加 CDROM 2（装 virtio 驱动用）**：点左下 **"添加硬件"** → Storage → 选 **virtio-win ISO** → 设备类型选 **CDROM** → 完成

**NIC（网卡）**

- **网络源**：default（NAT）
- **设备型号**：改为 **virtio**

**Input（输入设备）**：确认有 **Tablet**（USB，鼠标绝对定位，SPICE 用）。如果没有，添加：添加硬件 → Input → USB Tablet。Keyboard 默认有。

**Video（显卡）**

- **Model**：`QXL`（安装阶段靠 SPICE 控制台看画面）。后续做 GPU 直通时改 `none`（见 [passthrough.md](./passthrough.md)）

**TPM（Windows 11 必须，否则安装时报错）**

- 添加硬件 → **TPM**
- **Type**：Emulated
- **Model**：TIS（或 CRB）
- **Version**：**2.0**
- （需要宿主机 `swtpm` 服务，`virt.nix` 已启用）

**USB 控制器**：默认有 qemu-xhci，不动。

**引导顺序**：Overview → 展开引导选项，确保 **SATA CDROM 1（Windows ISO）排在第一位**（首次从 ISO 引导）。

#### 4. 开始安装

点 **Begin Installation**，virt-manager 自动打开 SPICE 图形控制台，Windows 安装器启动。

**4.1 绕过 TPM / Secure Boot 检查（如果提示"这台电脑无法运行 Windows 11"）**

Windows 11 官方要求 TPM 2.0 + Secure Boot + 4GB+ 内存。即使配了 swtpm（TPM 已满足），如果 OVMF 固件是非 secure 版（不支持 Secure Boot），安装器仍会拒绝。**不需要换 secure 固件、也不需要直通物理 TPM**，注册表绕过即可：

1. 安装界面（选语言的界面就行）按 **`Shift+F10`** 打开 CMD
2. 输 `regedit` 回车
3. 导航到 `HKEY_LOCAL_MACHINE\SYSTEM\Setup`
4. 新建**项** `LabConfig`
5. 在 `LabConfig` 下新建三个 **DWORD (32-bit)** 值，都设为 `1`：
   - `BypassSecureBootCheck`（绕过安全启动检查）
   - `BypassTPMCheck`（双保险，虽然 swtpm 已满足）
   - `BypassRAMCheck`（绕过内存检查）
6. 关闭 regedit 和 CMD 窗口 → 点安装界面的下一步，不再报错，正常继续

> 为什么不直接用 secure 版固件？secure 版 OVMF 需要额外配置 enrolled keys（Secure Boot 密钥），配错会无法引导；注册表绕过更省事，装完系统后这些检查就不再影响使用了。swtpm 模拟的 TPM 对 Windows 11 完全够用，**不要直通物理 TPM**（物理 TPM 同一时刻只能被一个使用者，且 swtpm 没有任何功能缺失）。

**4.2 跳过联网（避免被强制微软账号）**

Windows 11 安装要求联网 + 微软账号。想建本地账户：

- 选语言 / 时区 → 下一步 → "现在安装"
- 输入（或跳过）产品密钥 → 选版本 → 接受许可
- **到了"是否连接到 Internet"界面**：按 **`Shift+F10`** 弹出 CMD → 输入 `oobe\bypassnro` 回车 → 系统自动重启
- 重新走流程到联网界面，此时会出现 **"我没有 Internet"** 选项 → 点它 → "继续使用有限设置" → 建本地账户

**4.3 加载 virtio 驱动（选磁盘步骤）**

到"你想将 Windows 安装在哪里"，**列表是空的**（磁盘是 VirtIO，Windows 安装器没内置驱动）：

1. 点 **"加载驱动程序"**
2. 浏览 → 选 **CDROM 2（virtio-win ISO）** → `viostro\amd64\w11` 目录 → 确定
3. 列出 Red Hat VirtIO SCSI 驱动 → 选中 → 下一步
4. 如果提示"驱动不兼容 Windows 11"，勾掉左下"**显示兼容硬件**"，从列表里选 `viostor`（w11 amd64）

加载后 VirtIO 磁盘出现在列表。

**4.4 分区**

选中磁盘 → 点"新建" → "应用"（直接给整盘，Windows 自动建 EFI / MSR / Windows / 恢复分区）→ 下一步。

**4.5 安装与重启**

Windows 复制文件、装功能，期间 VM 自动重启几次。

> ⚠️ 如果重启后又从 ISO 启动安装器（而不是从硬盘继续），说明引导还在光驱：关掉 VM → Overview 改引导顺序把硬盘调到第一，或直接移除 Windows ISO 光驱 → 再启动。

**4.6 OOBE（首次设置）**

区域 / 键盘布局 → 联网（建议走 4.2 跳过）→ 账户名密码 → 隐私设置（建议全关）→ 进桌面。

**直接启用内置 Administrator 账户（可选，省去建新用户）**

OOBE 阶段（在联网界面或账户界面，`Shift+F10` 已开的 CMD 窗口里）执行：

```cmd
net user Administrator /active:yes
net user Administrator 你的密码
```

- 第一条启用内置 Administrator
- 第二条设密码（**Win11 不允许空密码登录**，必须设）

关掉 CMD，继续 OOBE。系统检测到 Administrator 已激活，会**跳过"创建账户"步骤**，直接用 Administrator 进桌面。

> Administrator 是 Windows 内置的最高权限账户，默认禁用。VM 里图省事用它没问题（UAC 弹窗也最少）；但出于安全考虑，物理机/服务器日常不建议用 Administrator（所有程序默认继承最高权限，恶意软件影响面更大）。

#### 5. 装 virtio-win guest tools（一次性装齐所有驱动）

1. VM 里打开"此电脑"，应能看到 virtio-win 光驱
2. 运行 **`virtio-win-guest-tools.exe`** → 一路下一步
3. 它会装齐：virtio 磁盘 / 网卡驱动（确认生效）、QXL 显示驱动、spice-vdagent（鼠标/剪贴板/自适应分辨率）、Balloon 等
4. **重启 VM**

#### 6. 验证

进设备管理器（`Win+X` → 设备管理器），**所有设备无黄色感叹号**：

- 网络适配器 → Red Hat VirtIO Ethernet
- 存储控制器 → Red Hat VirtIO SCSI controller
- 显示适配器 → Red Hat QXL Controller（或后续直通的 GPU）

鼠标流畅、分辨率随窗口自适应（spice-vdagent 生效），网络能上（NAT，IP `192.168.122.x`）。

#### 7. 后续优化

- 磁盘 / 网卡都已是 virtio，性能基础已就位
- 想要 GPU 性能 → 见 [passthrough.md](./passthrough.md) 做 GPU 直通（需移除 QXL、加 GPU hostdev）
- Hyper-V enlightenments / 巨页 / CPU 绑定等 → 见下方 [性能优化](#性能优化) 章节

### 方式 B：导入物理硬盘上已有的 Windows

适合双系统：硬盘上已装好 Windows，想在 VM 里直接启动它，不重装。

1. 确认目标磁盘的稳定路径（**必须用 by-id**，不要用 /dev/sda）：

   ```bash
   ls -l /dev/disk/by-id/ | grep nvme
   # 记下 Windows 所在磁盘，如 /dev/disk/by-id/nvme-XXX
   ```

2. virt-manager → **新建虚拟机** → **"导入现有磁盘镜像"**

3. "提供现有存储路径"：**不要点 Browse**（那只显示 libvirt 存储池目录，看不到块设备），**直接在输入框手动输入**磁盘路径：

   ```
   /dev/disk/by-id/nvme-XXX
   ```

   操作系统类型选 Windows。

4. **勾选"安装前自定义配置"** → 按上面"关键配置"设好

5. 固件必须选 **UEFI**（物理硬盘上的 Windows 是 GPT 分区，必须 UEFI 启动；选错会找不到引导）

6. 点 **Begin Installation** → VM 直接从物理硬盘启动 Windows。

**注意事项**：

- **磁盘总线先用 SATA**：物理 Windows 里没装 virtio 存储驱动，第一次用 VirtIO 会蓝屏（`INACCESSIBLE_BOOT_DEVICE`）。先用 SATA 启动进系统 → 装好 virtio 驱动 → 关机后切 VirtIO。
- **Windows 可能要重新激活**：CPU、主板 UUID 等硬件变化后，Windows 会认为换了机器，可能需要重新激活。
- 切 VirtIO 后若蓝屏，切回 SATA 可正常启动（说明驱动没装好，重装）。

### 安装/启动后：装 virtio 驱动

进入 Windows 后，挂载 virtio-win ISO，运行 `virtio-win-guest-tools.exe`，一次装齐所有 virtio 驱动（磁盘、网卡、QXL 显示、spice-vdagent、VirtIO-FS 等）。

装好后可以把磁盘总线从 SATA 切 VirtIO、网卡/显示都用 virtio，性能更好。

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
  <binary path="/run/current-system/sw/bin/virtiofsd"/>   <!-- NixOS 必需，见下方说明 -->
  <source dir="/home/$USER/shared"/>    <!-- 宿主机共享目录（绝对路径） -->
  <target dir="myshare"/>                <!-- tag 名，guest 据此识别 -->
</filesystem>
```

| 属性          | 说明                                                                            |
| ------------- | ------------------------------------------------------------------------------- |
| `source dir`  | 宿主机要共享的目录                                                              |
| `target dir`  | **tag**（标识名，不是挂载路径）                                                 |
| `accessmode`  | `passthrough`（性能最好，UID/GID 直接透传）/ `mapped`（映射）/ `squash`（匿名） |
| `binary path` | virtiofsd 二进制路径（**NixOS 必需显式指定**）                                  |

> VirtIO-FS 不支持 `<filesystem bus>` 这种老式 9p 语法，必须 `<driver type="virtiofs"/>`。

> ⚠️ **NixOS 必需两步**（缺一会报 `Unable to find a satisfying virtiofsd`）：
>
> 1. **装 virtiofsd 包**——在 `virt.nix` 加 `environment.systemPackages = [ pkgs.virtiofsd ]`（libvirt 默认不装）
> 2. **VM XML 显式指定路径**——加 `<binary path="/run/current-system/sw/bin/virtiofsd"/>`。libvirt **不查 PATH**，默认找 `/usr/libexec/virtiofsd`（NixOS 没这个路径），必须显式告诉它。`/run/current-system/sw/bin/virtiofsd` 是稳定 symlink（指向当前 generation），rebuild 后自动更新

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

挂载后，宿主机 `/home/$USER/shared` 的内容就出现在 Windows 的对应盘符。

#### 4. Linux guest 挂载（参考）

```bash
mount -t virtiofs myshare /mnt/share
```

`/etc/fstab` 持久化：

```
myshare  /mnt/share  virtiofs  defaults  0  0
```

#### ⚠️ 权限注意（Windows guest + runAsRoot）

VirtIO-FS 的文件操作用 **virtiofsd 的身份**。`virt.nix` 里 `runAsRoot=true`，virtiofsd 以 **root** 运行，加上 **Windows 没有 UID/GID 概念**，导致：

- VM **创建/修改**的文件 → 宿主机看是 **root:root**（644）
- 普通用户对这些文件**能读不能写**

VM 读宿主机文件没问题（root 能读任何文件），但**双向写**会有权限问题。

**解决**（按推荐度）：

1. **default ACL**（推荐；已在 [`home/shared.nix`](../home/shared.nix) 自动配置）：

   ```bash
   setfacl -m u:$USER:rwx /home/$USER/shared      # $USER 当前可读写
   setfacl -d -m u:$USER:rwx /home/$USER/shared   # default ACL：VM(root) 新建文件继承 $USER 的 rwx
   ```

   优势：`setfacl` 改**自己拥有**的目录不需要 root，整个方案能在 Home Manager（用户态）完成；不用建组、不用 `usermod -aG`、不用重新登录；不改变文件属组。

   > 只对目录本身设 default ACL，新建文件自动继承，无需 `-R`。若目录里已有 VM 早期写入的 root 属主文件，补救一次：`setfacl -R -m u:$USER:rwx /home/$USER/shared`。

2. **setgid 目录 + 共享组**（备选，需 root）：

   ```bash
   sudo groupadd -f share
   sudo usermod -aG share $USER        # 需重新登录生效
   sudo chown -R $USER:share /home/$USER/shared
   sudo chmod 2775 /home/$USER/shared  # setgid 让 root 新建文件继承 share 组
   ```

   配合 virtiofsd 的 umask（让组可写），$USER 就能读写 VM 创建的文件。相对 ACL 的劣势：需 root、建组、重登录，且会改变所有新文件的属组。

3. **接受 root**：VM 文件 $USER 只读，要改用 `sudo`。简单但麻烦。

4. **改用 SMB**：SMB 用 `smbpasswd` 设的用户身份，文件归属 samba 用户，权限更可控，但性能不如 VirtIO-FS。

> ⚠️ ACL 和 setgid 最终都受 **VM 创建文件时的 mode** 影响：若 virtiofsd/viofs 把新文件写成组只读（如 644），ACL 的 mask 和 setgid 的组位都会让 $USER 拿不到写权限，需从 virtiofsd 的 umask/fattr 侧放开。配好后用 `getfacl /home/$USER/shared` 核对，并让 VM 实际写一个文件验证 $USER 能改。

> 如果主要是 **VM 读宿主机文件**（单向，如宿主机下载 → VM 用），权限不是问题（root 能读）。只有**双向写**才需要处理上面的权限。

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
