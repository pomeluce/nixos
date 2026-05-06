{ config, lib, ... }:
let
  mo = config.mo;
in
{
  config = lib.mkIf config.mo.desktop.enable {
    programs.noctalia-shell = {
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
          backgroundOpacity = 0.93;
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
            center = [
              {
                colorName = "primary";
                hideWhenIdle = true;
                id = "AudioVisualizer";
                width = 200;
              }
              {
                clockColor = "none";
                customFont = "Maple Mono Normal NL NF CN SemiBold";
                formatHorizontal = "MM-dd HH:mm:ss - ddd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH=mm ddd; MMM dd";
                useCustomFont = true;
              }
              {
                compactMode = true;
                hideMode = "hidden";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 145;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = false;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "linear";
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
                labelMode = "index";
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
          monitorForColors = "eDP-1";
          predefinedScheme = "Gruvbox";
          schedulingMode = "off";
          syncGsettings = true;
          useWallpaperColors = true;
        };
        controlCenter = {
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
          diskPath = "/";
          position = "close_to_bar_button";
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "WallpaperSelector";
              }
              {
                id = "NoctaliaPerformance";
              }
            ];
            right = [
              {
                id = "Notifications";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
            ];
          };
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
          dimmerOpacity = 0.05;
          enableBlurBehind = true;
          enableLockScreenCountdown = true;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          forceBlackScreenCorners = false;
          iRadiusRatio = 1;
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
          backgroundOpacity = 1;
          enabled = true;
          enabledTypes = [
            0
            1
            2
          ];
          location = "top_right";
          monitors = [ ];
          overlayLayer = true;
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
          showHeader = true;
          showKeybinds = true;
        };
        templates = {
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
          enableUserTheming = false;
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
          directory = "/home/${mo.username}/.config/wallpapers";
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
        };
      };
    };
  };
}
