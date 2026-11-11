{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mo.desktop.enable {
    environment.systemPackages = [
      (pkgs.chromium.override {
        commandLineArgs = "--enable-wayland-ime";
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
      # Chromium only copies these defaults when creating a new profile.
      initialPrefs = {
        browser = {
          custom_chrome_frame = false;
          show_home_button = true;
        };
        bookmark_bar.show_tab_groups = false;
        tab_search.pinned_to_tabstrip = false;
        toolbar.pinned_actions = [
          "kActionShowDownloads"
          "kActionClearBrowsingData"
        ];
        vertical_tabs.enabled = true;
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
