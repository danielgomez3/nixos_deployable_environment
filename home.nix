{pkgs, ... }:{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  home.packages = [
    pkgs.zathura
    pkgs.pavucontrol
    pkgs.neofetch
    pkgs.picom
    pkgs.rofi
    pkgs.xclip
    pkgs.flameshot
    pkgs.brightnessctl
    pkgs.xbanish
    pkgs.kitty
    pkgs.flashfocus
    pkgs.feh
    # Helix editor deps.
    pkgs.ltex-ls
    # Dwm deps.
    pkgs.xmenu
    pkgs.gnumake
    pkgs.qutebrowser
    pkgs.polybar
  ];
  
  
  # Here's what's happening: I'm combining themes in a hacky way. Sourcing
  # One, declaring another. This will break. Looks great rn tho.
  programs.zsh = {
    enable = true;
    #initExtra = "neofetch --ascii_distro NixOS_small";
    # source /home/daniel/.config/home-manager/cdimascio-lambda.zsh-theme
    initExtra = 
      "
      neofetch --config /home/daniel/.config/home-manager/neofetch.conf --kitty --image_size 200px --source /home/daniel/.config/home-manager/nix-logo.png --memory_percent on --memory_unit gib --os_arch off --packages tiny --shell_version off --color_blocks off
      ";
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git"];
      # Really Good, Minimal, Time, Git.
      theme = "dst"; 
    };

  };
  
  
  

  
      
        
  # Rofi:
  programs.rofi = {
        enable = true;
        theme = "sidebar";
      };  
  
  # Helix editor:
  programs.helix.enable = true;
  programs.helix = {
    languages = [
      {
        name = "rust";
        auto-format = false;
      }
      {
        name = "markdown";
        language-server = {command = "ltex-ls";};
        file-types = ["md"];
        scope = "source.markdown";
        roots = [""];
      }
    ];
    settings = {
        theme = "catppuccin_frappe";
        editor = {
          line-number = "relative";
          rulers = [80];
        };
    };
  };
  
  
  # Kitty Terminal:
  programs.kitty = {
    enable = true;
    #theme = "DarkOneNuanced";
    font.size = 9.0;
    font.name = "DejaVu Sans";
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
    # This has to happen because kitty-theme derivation is broken:
    extraConfig = "
      # Dark One Nuanced by ariasuni, https://store.kde.org/p/1225908
      # Imported from KDE .colorscheme format by thematdev, https://thematdev.org
      # For migrating your schemes from Konsole format see 
      # https://git.thematdev.org/thematdev/konsole-scheme-migration


      # importing Background
      background #282c34
      # importing BackgroundFaint
      # importing BackgroundIntense
      # importing Color0
      color0 #3f4451
      # importing Color0Faint
      color16 #282c34
      # importing Color0Intense
      color8 #4f5666
      # importing Color1
      color1 #e06c75
      # importing Color1Faint
      color17 #c25d66
      # importing Color1Intense
      color9 #ff7b86
      # importing Color2
      color2 #98c379
      # importing Color2Faint
      color18 #82a566
      # importing Color2Intense
      color10 #b1e18b
      # importing Color3
      color3 #d19a66
      # importing Color3Faint
      color19 #b38257
      # importing Color3Intense
      color11 #efb074
      # importing Color4
      color4 #61afef
      # importing Color4Faint
      color20 #5499d1
      # importing Color4Intense
      color12 #67cdff
      # importing Color5
      color5 #c678dd
      # importing Color5Faint
      color21 #a966bd
      # importing Color5Intense
      color13 #e48bff
      # importing Color6
      color6 #56b6c2
      # importing Color6Faint
      color22 #44919a
      # importing Color6Intense
      color14 #63d4e0
      # importing Color7
      color7 #e6e6e6
      # importing Color7Faint
      color23 #c8c8c8
      # importing Color7Intense
      color15 #ffffff
      # importing Foreground
      foreground #abb2bf
      # importing ForegroundFaint
      # importing ForegroundIntense
      # importing General";
  };
  

  # Unclutter
  services.unclutter = {
    enable = true;
  };
    
  

  # Qutebrowser
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://google.com/search?hl=en&q={}";
    };
    extraConfig = 
    ''
    c.url.start_pages = ['google.com']

    import os
    from urllib.request import urlopen

    # load your autoconfig, use this, if the rest of your config is empty!
    config.load_autoconfig()

    if not os.path.exists(config.configdir / "theme.py"):
        theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
        with urlopen(theme) as themehtml:
            with open(config.configdir / "theme.py", "a") as file:
                file.writelines(themehtml.read().decode("utf-8"))

    if os.path.exists(config.configdir / "theme.py"):
        import theme
        theme.setup(c, 'frappe', True)
    
    '';
    
  };

  
  
  # Picom Overlay:
  nixpkgs.overlays = [ (self: super: {
      picom = super.picom.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            repo = "picom";
            owner = "jonaburg";
            rev = "HEAD";
            sha256 = "4voCAYd0fzJHQjJo4x3RoWz5l3JJbRvgIXn1Kg6nz6Y=";
            };
      });
  }) ];




  # Picom
  #services.picom = {
  #      enable = true;
  #      activeOpacity = 1;
  #      inactiveOpacity	= 1;
  #      backend = "glx";        
  #      menuOpacity = 1;
  #      fade = true;
  #      fadeDelta = 5;
  #      vSync = true;
  services.picom = {
    extraArgs = 
    ["--config /home/danie/.config/home-manager/picom.conf"
    "--experimental-backends"];
  };



  # Polybar
  #services.polybar = {
  #  enable = true;
  #  #config = {
  #  #  "bar/top" = {
  #  #    monitor = "\${env:MONITOR:eDP1}";
  #  #    width = "100%";
  #  #    height = "3%";
  #  #    radius = 0;
  #  #    modules-center = "date";
  #  #  };

  #  #  "module/date" = {
  #  #    type = "internal/date";
  #  #    internal = 5;
  #  #    date = "%d.%m.%y";
  #  #    time = "%H:%M";
  #  #    label = "%time%  %date%";
  #  #  };
  #  #};
  #};
  
  
 
  
  
  
  
  

}