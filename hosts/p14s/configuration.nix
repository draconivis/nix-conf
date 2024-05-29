# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # import home-manager module
    inputs.home-manager.nixosModules.home-manager
    # inputs.nix-ld.nixosModules.nix-ld
    ../common
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
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  powerManagement.powertop.enable = true;

  xdg.portal.enable = true;
  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    gvfs.enable = true; # Mount, trash, and other functionalities
    flatpak.enable = true;
    interception-tools = { # https://discourse.nixos.org/t/troubleshooting-help-services-interception-tools/20389/5
      enable = true;
      plugins = with pkgs; [
        interception-tools-plugins.caps2esc
      ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
        '';
    };
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      # videoDrivers = [ "nvidia" ];
      windowManager.awesome = {
        enable = true;
      };
    };
    displayManager.sddm = {
      enable = true;
# autoSuspend = false;
    };
  };

  # hardware = {
    # nvidia = {
    #   modesetting.enable = true;
    #   powerManagement = {
    #     enable = false;
    #     finegrained = true;
    #   };
    #   prime = {
    #     offload = {
    #       enable = true;
    #       enableOffloadCmd = true;
    #     };
    #     # sync.enable = true;
    #     nvidiaBusId = "PCI:3:0:0";
    #     intelBusId = "PCI:0:2:0";
    #   };
    # };
  #   opengl = {
  #     enable = true;
  #     driSupport = true;
  #     driSupport32Bit = true;
  #   };
  # };

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
    
  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  networking = {
    hostName = "p14s";
    networkmanager.enable = true;
  };

  users.users = {
    patrick = {
      isNormalUser = true;
      description = "patrick";
      shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };

  virtualisation.docker.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
    nix-ld.enable = true;
    zsh.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
