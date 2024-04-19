{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "p14s"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };


  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "eu";
    };
    autoRepeatDelay = 175;
    autoRepeatInterval = 10;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patrick = {
    isNormalUser = true;
    description = "patrick";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "patrick" = import ./home.nix;
    };
    # The state version is required and should stay at the version you originally installed.
    #home.stateVersion = "23.11";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # basic
    acpi
    alacritty
    arandr
    awesome
    brightnessctl
    btop
    #deezer
    gcc
    devbox
    pavucontrol
    dex
    discord
    easyeffects
    evdevremapkeys
    fastfetch
    git
    firefox
    firefox-devedition-bin
    flameshot
    frei0r
    gimp
    delta
    gnome.gnome-calculator
    gnome.gnome-keyring
    gvfs
    i3lock-fancy
    #interception-caps2esc
    #lain
    libreoffice-fresh
    lsd
    lsp-plugins
    lxappearance
    matcha-gtk-theme
    moar
    mpv
    neovim
    #network-manager-applet
    #npm
    papirus-icon-theme
    picom
    qtile
    redshift
    ripgrep
    xfce.ristretto
    rofi
    slack
    sxhkd
    home-manager
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    tmux
    transmission-gtk
    webp-pixbuf-loader
    wget
    xclip
    xorg.xrdb
    xss-lock
    zoxide
    zsh
    antidote
    ## work
    awscli2
    direnv
    docker
    docker-compose
    du-dust
#insomnium-bin
#jre-openjdk
    lazygit
    mariadb
#nvm
    jetbrains.phpstorm
    pinentry-rofi
#pipenv
#pyenv
#python-pip
#redisinsight

    ## laptop
    autorandr
    blueman
    #optimus-manager

  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # services.xserver = {
  #   enable = true;
  #
  #   windowManager.awesome = {
  #     enable = true;
  #     luaModules = with pkgs.luaPackages; [
  #       luarocks
  #       luadbi-mysql
  #     ];
  #   };
  # };
  #
  # services.displayManager = {
  #   sddm.enable = true;
  #   defaultSession = "none+awesome";
  # };


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

#  services.flatpak.enable = true;
#  xdg = {
#	  portal = {
#		  enable = true;
#		  extraPortals = with pkgs; [
#			  xdg-desktop-portal-gtk
#		  ];
#	  };
#  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
