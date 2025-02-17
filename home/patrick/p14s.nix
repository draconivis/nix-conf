# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "patrick";
    homeDirectory = "/home/patrick";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    antidote
    android-tools
    arc-icon-theme
    awscli2
    bat
    bruno
    capitaine-cursors
    cargo
    ckb-next
    dash
    devbox
    direnv
    docker
    docker-compose
    du-dust
    firefox-devedition-bin
    ffmpeg
    fwupd
    fzf
    git
    gum
    home-manager
    jetbrains.phpstorm
    lazygit
    librewolf
    mariadb
    neovim
    networkmanagerapplet
    oh-my-posh
    pinentry-rofi
    pure-prompt
    silicon
    slack
    slides
    strawberry-qt6
    tmux
    tmuxPlugins.tmux-fzf
    xfce.tumbler
    ungoogled-chromium
    unzip
    vscodium
    wezterm
    xplr
    yazi
    # zed-editor
    zip
    zoxide
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
