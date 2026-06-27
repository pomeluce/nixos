{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ---- Shells ----
    zsh # Z shell — 强大的交互式 Unix shell
    nushell # 现代化 shell, 以结构化数据处理为核心

    # ---- Editors ----
    neovim # 现代化 Vim 编辑器替代

    # ---- Network & Download ----
    wget # 非交互式文件下载工具
    curl # URL 数据传输工具, 支持多协议
    git # 分布式版本控制系统

    # ---- NixOS Management ----
    home-manager # NixOS 用户环境管理器
    nix-update # Nix 包版本自动更新工具

    # ---- Basic System Utilities ----
    which # 查找命令的完整路径
    file # 检测文件类型
    lsof # 列出当前系统打开的文件
    psmisc # 进程管理工具集(killall、pstree、fuser 等)
    pciutils # PCI 总线设备查看工具(lspci)
    usbutils # USB 设备查看工具(lsusb)
    dconf # GNOME 底层配置存储系统
    glib # GLib 底层 C 库(GNOME 基础)
    shared-mime-info # 共享 MIME 类型数据库
    xdg-utils # XDG 桌面集成工具(xdg-open、xdg-mime 等)
    iptables # Linux 内核防火墙管理工具
    btop-cuda # 资源监控面板(含 CUDA 支持)
    cliphist # Wayland 剪贴板历史管理器
    microcode-intel # Intel CPU 微码固件

    # ---- Archive & Compression ----
    zip # ZIP 格式压缩工具
    unzip # ZIP 格式解压工具
    xz # XZ/LZMA 高压缩比工具
    p7zip # 7-Zip 格式压缩解压工具
    zstd # Zstandard 快速压缩算法

    # ---- Text Processing & Search ----
    gawk # GNU awk 文本处理语言
    bat # 带语法高亮的 cat 替代品
    fd # 简洁快速的 find 替代品
    ripgrep # 超快递归文本搜索(rg)
    jq # 命令行 JSON 处理器

    # ---- Security & Secrets ----
    sops # 加密文件编辑器(Secrets OPerationS)

    # ---- Build Systems & Meta-build ----
    flex # 词法分析器生成器
    bison # 语法分析器生成器(Yacc 替代)
    gnumake # GNU Make 构建自动化工具
    cmake # 跨平台 C/C++ 构建系统生成器
    meson # 现代化高性能构建系统
    ninja # 专注于速度的小型构建系统

    # ---- Compilers & Debuggers ----
    gcc # GNU C/C++ 编译器集合
    gdb # GNU 调试器

    # ---- Programming Languages & Runtimes ----
    rustc # Rust 语言编译器
    cargo # Rust 包管理器及构建工具
    python3 # Python 3 解释器
    nodejs_26 # Node.js 26 JavaScript 运行时
    pnpm # 高效的 Node.js 包管理器
    yarn # 快速可靠的 Node.js 包管理器
    typescript # TypeScript 语言(JS 超集, 含编译器)
    go # Go 语言工具链
    lua # Lua 轻量脚本语言
    maven # JVM 项目构建与依赖管理工具
    gradle # 灵活可扩展的 JVM 构建系统

    # ---- Device / Platform Support ----
    usbmuxd # USB 多路复用守护进程(iOS 设备通信)
    libimobiledevice # Apple iOS 设备通信协议库
    android-tools # Android 调试桥(adb、fastboot 等)

    # ---- Media & Misc ----
    translate-shell # 命令行翻译工具(Google Translate 前端)
    imagemagick # 图像处理与格式转换套件
  ];

  programs.java = {
    enable = true;
    package = pkgs.zulu21;
  };

  environment.etc."jdk/zulu25".source = "${pkgs.zulu25}";
  environment.etc."jdk/zulu21".source = "${pkgs.zulu21}";
  environment.etc."jdk/zulu8".source = "${pkgs.zulu8}";
}
