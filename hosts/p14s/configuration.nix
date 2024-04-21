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

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      windowManager.awesome = {
        enable = true;
      };
      displayManager.sddm = {
        enable = true;
        # autoSuspend = false;
      };
    };
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:3:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  networking = {
    hostName = "p14s";
    networkmanager.enable = true;
  };

  users.users = {
    patrick = {
      isNormalUser = true;
      description = "patrick";
      # shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };

  virtualisation.docker.enable = true;

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs outputs; };
  #   users = {
  #     # Import your home-manager configuration
  #     patrick = import ../home/patrick/p14s.nix;
  #   };
  # };

  programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
