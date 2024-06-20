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
    arc-icon-theme
    awscli2
    bat
    bruno
    capitaine-cursors
    cargo
    devbox
    direnv
    networkmanagerapplet
    docker
    docker-compose
    du-dust
    firefox-devedition-bin
    fzf
    jetbrains.phpstorm
    lazygit
    dash
    mariadb
    pinentry-rofi
    unzip
    pure-prompt
    silicon
    slack
    xplr
    slides
    vscodium
    tmux
    tmuxPlugins.tmux-fzf
    #insomnium-bin
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        live_config_reload = true;
        import = ["~/.config/alacritty/catppuccin-macchiato.toml"];
        font = {
          # size = 10.0;
          normal = {
            family = "JetBrainsMonoNF";
            style = "Regular";
          };
        };
        window = {
          dynamic_padding = true;
          # startup_mode = "Maximized";
          decorations = "None";
        };
        shell = {
          args = ["new-session" "-A" "-s" "main"];
          program = "tmux";
        };
      };
    };
    # autorandr = {
    #   enable = true;
    # }
    neovim.enable = true;
    home-manager.enable = true;
    git.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    zsh = {
      enable = true;
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        share = true;
      };
      enableCompletion = true;
      # autosuggestions.enable = true;
      # syntaxHighlighting.enable = true;
      # historySubstringSearch.enable = true;
      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
          source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
        fi
      '';
      initExtra = ''
        #vagrant
        function vup () {
          cd ~/work/start/homestead
            vagrant up
            cd -
        }
        function vdown () {
          cd ~/work/start/homestead
            vagrant suspend
            cd -
        }
        function vssh () {
          cd ~/work/start/homestead
            vagrant ssh
            cd -
        }
        function vhalt () {
          cd ~/work/start/homestead
            vagrant halt
            cd -
        }

        ## load p10k
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      shellAliases = {
        "ls"="lsd";
        "ll"="ls -lh";
        "la"="ls -lAh";
        ".."="cd ..";
        "..."="cd ../..";
        "...."="cd ../../..";
        "lg"="lazygit";
        "bc"="bin/console";
        "dbx"="devbox";
      };
      antidote = {
        enable = true;
        useFriendlyNames = true;
        plugins = [
          # completions
          # "mattmc3/zephyr path:plugins/completion"
          "zsh-users/zsh-completions"
          #g-plane/pnpm-shell-completion
          # regular plugins
          "ael-code/zsh-colored-man-pages"
          "davidde/git"

          ## work
          #mattberther/zsh-pyenv
          #sptndc/phpenv.plugin.zsh
          #lukechilds/zsh-nvm

          # prompt
          "romkatv/powerlevel10k"
          # syntax highlighting
          "zdharma-continuum/fast-syntax-highlighting"
          # these plugins need to be loaded last
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-history-substring-search"
        ];
      };
    };
    # oh-my-posh = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   useTheme = "catppuccin_macchiato";
    # };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
