{
  services = {
    xserver = {
     enable = true;
      windowManager.awesome = {
        enable = true;
      };
      displayManager.sddm = {
        enable = true;
        # autoSuspend = false;
      };
    };
  };
}
