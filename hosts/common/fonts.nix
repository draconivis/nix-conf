{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "JetBrainsMono NF" ];
        sansSerif = [ "JetBrainsMono NF" ];
        monospace = [ "JetBrainsMono NF" ];
      };
    };
  };
}
