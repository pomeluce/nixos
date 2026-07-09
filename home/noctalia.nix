{ config, lib, ... }:
let
  mo = config.mo;
in
{
  config = lib.mkIf config.mo.desktop.enable {
    programs.noctalia = {
      enable = true;
      settings = {
        appLauncher = {
          autoPasteClipboard = false;
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWrapText = true;
          customLaunchPrefix = "";
          customLaunchPrefixEnabled = false;
          density = "comfortable";
          enableClipPreview = true;
          enableClipboardChips = true;
          enableClipboardHistory = true;
          enableClipboardSmartIcons = true;
          enableSessionSearch = true;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          iconMode = "tabler";
          ignoreMouseInput = false;
          overviewLayer = false;
          pinnedApps = [ ];
          position = "center";
          screenshotAnnotationTool = "";
          showCategories = false;
          showIconBackground = false;
          sortByMostUsed = true;
          terminalCommand = "ghostty -e";
          viewMode = "list";
        };
        audio = {
          mprisBlacklist = [ ];
          preferredPlayer = "";
          spectrumFrameRate = 60;
          spectrumMirrored = true;
          visualizerType = "linear";
          volumeFeedback = false;
          volumeFeedbackSoundFile = "";
          volumeOverdrive = false;
          volumeStep = 5;
        };
        bar = {
          autoHideDelay = 500;
          autoShowDelay = 150;
          backgroundOpacity = 0.85;
          barType = "simple";
          capsuleColorKey = "none";
          capsuleOpacity = 1;
          contentPadding = 2;
          density = "comfortable";
          displayMode = "always_visible";
          enableExclusionZoneInset = true;
          fontScale = 1;
          frameRadius = 12;
          frameThickness = 8;
          hideOnOverview = false;
          marginHorizontal = 4;
          marginVertical = 4;
          middleClickAction = "none";
          middleClickCommand = "";
          middleClickFollowMouse = false;
          monitors = [ ];
          mouseWheelAction = "none";
          mouseWheelWrap = true;
          outerCorners = true;
          position = "top";
          reverseScroll = false;
          rightClickAction = "none";
          rightClickCommand = "";
          rightClickFollowMouse = true;
          screenOverrides = [ ];
          showCapsule = false;
          showOnWorkspaceSwitch = true;
          showOutline = false;
          useSeparateOpacity = false;
          widgetSpacing = 6;
          widgets = {
            background_opacity = 0.75;
            center = [ "group:g1" ];
            contact_shadow = true;
            end = [
              "group:g3"
              "group:g4"
              "group:g5"
              "group:g7"
              "group:g6"
            ];
            font_weight = 400;
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            scale = 0.9;
            start = [ "group:g2" ];
            thickness = 40;
            capsule_group = [
              {
                border = "";
                fill = "outline";
                id = "g1";
                members = [
                  "audio_visualizer"
                  "clock"
                  "media"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g2";
                members = [
                  "launcher"
                  "workspaces"
                  "taskbar"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g3";
                members = [ "tray" ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g4";
                members = [
                  "notifications"
                  "clipboard"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g5";
                members = [
                  "network"
                  "bluetooth"
                  "volume"
                  "brightness"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g6";
                members = [
                  "control-center"
                  "session"
                ];
                opacity = 0.6;
                padding = 14.0;
              }
              {
                fill = "outline";
                id = "g7";
                members = [ "battery" ];
                opacity = 0.6;
                padding = 14.0;
              }
            ];
            left = [
              {
                colorizeSystemIcon = "none";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "rocket";
                iconColor = "none";
                id = "Launcher";
                useDistroLogo = false;
              }
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                fontWeight = "bold";
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "none";
                occupiedColor = "secondary";
                pillSize = 0.6;
                showApplications = false;
                showApplicationsHover = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = true;
                unfocusedIconsOpacity = 1;
              }
              {
                colorizeIcons = true;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                showText = false;
                textColor = "none";
                useFixedWidth = false;
              }
            ];
            right = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [ ];
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                deviceNativePath = "__default__";
                displayMode = "icon-always";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = false;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                applyToAllMonitors = false;
                displayMode = "onhover";
                iconColor = "none";
                id = "Brightness";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Bluetooth";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Network";
                textColor = "none";
              }
              {
                colorizeDistroLogo = false;
                colorizeSystemIcon = "none";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "noctalia";
                id = "ControlCenter";
                useDistroLogo = false;
              }
            ];
          };
        };
        brightness = {
          backlightDeviceMappings = [ ];
          brightnessStep = 1;
          enableDdcSupport = false;
          enforceMinimum = true;
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
          ];
        };
        colorSchemes = {
          darkMode = true;
          generationMethod = "tonal-spot";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          predefinedScheme = "Gruvbox";
          schedulingMode = "off";
          syncGsettings = true;
          useWallpaperColors = true;
        };
        controlCenter = {
          diskPath = "/";
          position = "close_to_bar_button";
          shortcuts = {
            left = [
              { id = "Network"; }
              { id = "Bluetooth"; }
              { id = "WallpaperSelector"; }
              { id = "NoctaliaPerformance"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "PowerProfile"; }
              { id = "KeepAwake"; }
              { id = "NightLight"; }
            ];
          };
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        control_center = {
          sidebar = "full";
          sidebar_section = "full";
        };
        desktop_widgets = {
          enabled = false;
          schema_version = 2;
          widget_order = [ ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = { };
        };
        dock = {
          enabled = false;
        };
        general = {
          allowPanelsOnScreenWithoutBar = true;
          allowPasswordWithFprintd = false;
          animationDisabled = false;
          animationSpeed = 1;
          autoStartAuth = false;
          avatarImage = "/var/lib/AccountsService/icons/${mo.username}";
          boxRadiusRatio = 1;
          clockFormat = "hh\\nmm";
          clockStyle = "custom";
          compactLockScreen = false;
          dimmerOpacity = 0.050000000000000003;
          enableBlurBehind = true;
          enableLockScreenCountdown = true;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          forceBlackScreenCorners = false;
          iRadiusRatio = 1;
          lockOnSuspend = true;
          lockScreenAnimations = false;
          lockScreenBlur = 0;
          lockScreenCountdownDuration = 10000;
          lockScreenMonitors = [ ];
          lockScreenTint = 0;
          passwordChars = false;
          radiusRatio = 1;
          reverseScroll = false;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          showChangelogOnStartup = false;
          showHibernateOnLockScreen = false;
          showScreenCorners = false;
          showSessionButtonsOnLockScreen = true;
          smoothScrollEnabled = true;
          telemetryEnabled = false;
          keybinds = {
            keyDown = [
              "Down"
              "Ctrl+J"
            ];
            keyEnter = [
              "Return"
              "Enter"
            ];
            keyEscape = [ "Esc" ];
            keyLeft = [
              "Left"
              "Ctrl+H"
            ];
            keyRemove = [ "Del" ];
            keyRight = [
              "Right"
              "Ctrl+L"
            ];
            keyUp = [
              "Up"
              "Ctrl+K"
            ];
          };
        };
        hooks = {
          enabled = false;
        };
        idle = {
          enabled = false;
        };
        location = {
          analogClockInCalendar = false;
          autoLocate = false;
          auto_locate = true;
          firstDayOfWeek = 0;
          hideWeatherCityName = false;
          hideWeatherTimezone = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = false;
        };
        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
        };
        network = {
          bluetoothAutoConnect = true;
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = true;
          bluetoothRssiPollIntervalMs = 60000;
          bluetoothRssiPollingEnabled = false;
          disableDiscoverability = false;
          networkPanelView = "wifi";
          wifiDetailsViewMode = "grid";
        };
        nightLight = {
          enabled = false;
        };
        noctaliaPerformance = {
          disableDesktopWidgets = true;
          disableWallpaper = true;
        };
        notifications = {
          backgroundOpacity = 1;
          clearDismissed = true;
          criticalUrgencyDuration = 15;
          density = "default";
          enableBatteryToast = true;
          enableKeyboardLayoutToast = true;
          enableMarkdown = false;
          enableMediaToast = false;
          enabled = true;
          location = "top_right";
          lowUrgencyDuration = 3;
          monitors = [ ];
          normalUrgencyDuration = 8;
          overlayLayer = true;
          respectExpireTimeout = false;
          saveToHistory = {
            critical = true;
            low = true;
            normal = true;
          };
          sounds = {
            criticalSoundFile = "";
            enabled = true;
            excludedApps = "discord,firefox,chrome,chromium,edge";
            lowSoundFile = "";
            normalSoundFile = "";
            separateSounds = false;
            volume = 0.5;
          };
        };
        osd = {
          autoHideMs = 2000;
          background_opacity = 0.80;
          enabled = true;
          enabledTypes = [
            0
            1
            2
          ];
          monitors = [ ];
          overlayLayer = true;
          position = "top_right";
        };
        plugins = {
          autoUpdate = false;
          notifyUpdates = false;
        };
        sessionMenu = {
          countdownDuration = 10000;
          enableCountdown = true;
          largeButtonsLayout = "single-row";
          largeButtonsStyle = true;
          position = "center";
          showHeader = true;
          showKeybinds = true;
          powerOptions = [
            {
              action = "lock";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "1";
            }
            {
              action = "suspend";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "2";
            }
            {
              action = "hibernate";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "3";
            }
            {
              action = "reboot";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "4";
            }
            {
              action = "logout";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "5";
            }
            {
              action = "shutdown";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "6";
            }
            {
              action = "rebootToUefi";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "7";
            }
            {
              action = "userspaceReboot";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
          ];
        };
        shell = {
          avatarImage = "/var/lib/AccountsService/icons/${mo.username}";
          font_family = "PingFang SC";
          settings_show_advanced = true;
          polkit_agent = true;
          launcher = {
            categories = false;
          };
          panel = {
            control_center_placement = "floating";
            control_center_position = "center";
            launcher_categories = false;
            open_near_click_control_center = true;
            session_placement = "floating";
            session_position = "center";
            transparency_mode = "soft";
            wallpaper_placement = "floating";
            wallpaper_position = "center";
          };
          screen_corners = {
            enabled = true;
            size = 1;
          };
          screenshot = {
            save_to_file = false;
          };
        };
        templates = {
          enableUserTheming = false;
          activeTemplates = [
            {
              enabled = true;
              id = "gtk";
            }
            {
              enabled = true;
              id = "qt";
            }
            {
              enabled = true;
              id = "ghostty";
            }
            {
              enabled = true;
              id = "telegram";
            }
            {
              enabled = true;
              id = "niri";
            }
            {
              enabled = true;
              id = "btop";
            }
            {
              enabled = true;
              id = "pywalfox";
            }
          ];
        };
        theme = {
          source = "wallpaper";
          templates = {
            builtin_ids = [
              "btop"
              "gtk3"
              "gtk4"
              "ghostty"
              "niri"
              "qt"
            ];
            community_ids = [
              "pywalfox"
              "steam"
              "telegram"
            ];
          };
        };
        ui = {
          boxBorderEnabled = false;
          fontDefault = "苹方-简";
          fontDefaultScale = 1;
          fontFixed = "CaskaydiaMono Nerd Font Mono";
          fontFixedScale = 1;
          panelBackgroundOpacity = 0.85;
          panelsAttachedToBar = true;
          scrollbarAlwaysVisible = true;
          settingsPanelMode = "window";
          settingsPanelSideBarCardStyle = false;
          tooltipsEnabled = true;
          translucentWidgets = false;
        };
        wallpaper = {
          automationEnabled = true;
          directory = "${mo.desktop.wallpaper.dir}";
          edge_smoothness = 0.05;
          enableMultiMonitorDirectories = false;
          enabled = true;
          favorites = [ ];
          fillColor = "#000000";
          fillMode = "crop";
          hideWallpaperFilenames = false;
          linkLightAndDarkWallpapers = true;
          monitorDirectories = [ ];
          overviewBlur = 0.4;
          overviewEnabled = true;
          overviewTint = 0.6;
          panelPosition = "follow_bar";
          randomIntervalSec = 300;
          setWallpaperOnAllMonitors = true;
          showHiddenFiles = false;
          skipStartupTransition = false;
          solidColor = "#1a1a2e";
          sortOrder = "name";
          transitionDuration = 1500;
          transitionEdgeSmoothness = 0.05;
          transitionType = [
            "fade"
            "disc"
            "stripes"
            "wipe"
            "pixelate"
            "honeycomb"
          ];
          useOriginalImages = true;
          useSolidColor = false;
          useWallhaven = false;
          viewMode = "single";
          wallhavenApiKey = "";
          wallhavenCategories = "111";
          wallhavenOrder = "desc";
          wallhavenPurity = "100";
          wallhavenQuery = "";
          wallhavenRatios = "";
          wallhavenResolutionHeight = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenSorting = "relevance";
          wallpaperChangeMode = "alphabetical";
          automation = {
            enabled = true;
            interval_seconds = 300;
            order = "alphabetical";
          };
        };
        weather = {
          enabled = false;
        };
        widget = {
          brightness = {
            scroll_step = 1;
            show_label = false;
          };
          clock = {
            format = "{:%m-%d %H:%M:%S - %A}";
          };
          launcher = {
            anchor = true;
            glyph = "rocket";
          };
          network = {
            show_label = false;
          };
          taskbar = {
            anchor = true;
            show_active_indicator = false;
          };
          volume = {
            scroll_step = 1;
            show_label = false;
          };
          workspaces = {
            display = "none";
          };
          media = {
            hide_when_no_media = true;
          };
        };
        keybinds = {
          down = [ "Ctrl+j" ];
          up = [ "Ctrl+k" ];
          left = [ "Shift+ISO_Left_Tab" ];
          right = [ "Tab" ];
        };
        lockscreen = {
          blurred_desktop = true;
        };
        backdrop = {
          enabled = true;
        };
      };
    };
  };
}
