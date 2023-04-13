# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config,pkgs,lib, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/daniel";
    description = "the one and only";
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget curl iwd dhcpcd helix vim
    git cachix 
    st chromium rofi dmenu

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  ## DANIEL'S ADDED OPTIONS:



  # Networking:
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
	

  # Shell (needs to be done here and home.nix):
  programs.zsh.enable = true;
  users.users.daniel.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ]; # For errors.

  
  # Dwm:
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  hardware.opengl.enable = true;
  services.xserver.enable = true;
  nixpkgs.overlays = [ (self: super: {
    dwm = super.dwm.overrideAttrs (old: {
      pname = "dwm";
      version = "6.2";
      src = super.fetchurl {
        url = "https://dl.suckless.org/dwm/dwm-6.2.tar.gz";
        sha256 = "l5AuLgB6rqo8bjvtH4F4W4F7dBOUfx2x07YrjaTNEQ4=";
      };
      patches = [
        (super.fetchpatch {
          url = "https://raw.githubusercontent.com/danielgomez3/dwmpatch/main/dwmpatch_danielgomez3.diff";
          sha256 = "1li595dgxpklw6x67hdx810v5n65q7b5bwh9g8nd2jh7gn4ymplh";
        })
      ];
    });
}) ];




  
  # Helix:
  # Set default editor (for sudoedit, etc.):
  environment.variables.EDITOR = "vim";
  
  # Git
  programs.ssh.askPassword = "";


  # Don't ask users of group 'wheel' for a password:
  security.sudo.wheelNeedsPassword = false; 
  

  # Enable flakes and experimental features
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    
  };
  


}


