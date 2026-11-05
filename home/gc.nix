{
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "daily";
    timestamp = "-7 days";
    store.cleanup = true;
  };
}
