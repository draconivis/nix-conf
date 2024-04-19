{
  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "eu";
    };
    autoRepeatDelay = 175;
    autoRepeatInterval = 10;
  };
}
