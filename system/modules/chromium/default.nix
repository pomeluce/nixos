{
  config,
  lib,
  pkgs,
  ...
}:
let
  # The launcher initializes preferences before Chromium's first-run UI can reset them.
  browser = pkgs.chromium.override { commandLineArgs = "--enable-wayland-ime --no-first-run"; };
  preferences = builtins.removeAttrs config.programs.chromium.initialPrefs [ "distribution" ];
  defaults = pkgs.writeText "chromium-profile-defaults.json" (builtins.toJSON preferences);
in
{
  config = lib.mkIf config.mo.desktop.enable {
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "chromium-managed-${browser.version}";
        paths = [ browser ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/chromium" \
            --run ${lib.escapeShellArg "${pkgs.python3}/bin/python3 ${./profile.py} ${defaults} \"$@\""}
        '';
      })
    ];

    programs.chromium = {
      enable = true;
      extraOpts = {
        # Runs after all browser windows close, provided Chromium exits cleanly.
        ClearBrowsingDataOnExitList = [
          "browsing_history"
          "download_history"
          "cookies_and_other_site_data"
          "cached_images_and_files"
          "autofill"
          "site_settings"
          "hosted_app_data"
        ];
        AllowDeletingBrowserHistory = true;
        BackgroundModeEnabled = false;
        RestoreOnStartup = 5; # Open a new tab instead of restoring the last session.
        DefaultBrowserSettingEnabled = false;
        PromotionsEnabled = false;
        BrowserSignin = 0;
        SyncDisabled = true;
        SearchSuggestEnabled = false;
        UrlKeyedAnonymizedDataCollectionEnabled = false;
        MetricsReportingEnabled = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        PasswordManagerEnabled = false;
        # Disabling password saving alone still permits filling saved passwords.
        PasswordManagerBlocklist = [ "*" ];

        # GenAiDefaultSettings is cloud-only; local policies must disable each feature.
        AIModeSettings = 1;
        ThirdPartyAiChatSettings = 1;
        ChromeSuggestionsSettings = 1;
        SearchContentSharingSettings = 1;
        SmartTabSharingSettings = 1;
        GeminiActOnWebSettings = 1;
        GeminiSparkSettings = 1;
        GenAILocalFoundationalModelSettings = 1;
        AutofillGenAiSettings = 2;
        AutomatedPasswordChangeSettings = 2;
        CreateThemesSettings = 2;
        DevToolsGenAiSettings = 2;
        HelpMeWriteSettings = 2;
        HistorySearchSettings = 2;
        TabCompareSettings = 2;
        TryOnYouSettings = 2;
        VoiceTypingSettings = 2;
      };
      # The launcher also merges these preferences into existing, closed profiles.
      initialPrefs = {
        browser = {
          custom_chrome_frame = false;
          show_home_button = true;
        };
        bookmark_bar.show_tab_groups = false;
        tab_search.pinned_to_tabstrip = false;
        in_product_help.ntp_promos.disabled = true;
        toolbar.pinned_actions = [
          "kActionShowDownloads"
          "kActionClearBrowsingData"
        ];
        vertical_tabs = {
          enabled = true;
          collapsed_state = true;
        };
        profile = {
          name = config.mo.username;
          using_default_name = false;
        };
        credentials_enable_autosignin = false;
        distribution = {
          skip_first_run_ui = true;
          import_history = false;
          import_search_engine = false;
          import_bookmarks = false;
          import_saved_passwords = false;
        };
      };
    };
  };
}
