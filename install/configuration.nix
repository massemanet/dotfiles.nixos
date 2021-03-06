{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use systemd boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = [
    {name = "root";
     device = "/dev/disk/by-uuid/8aab5aee-9a1a-4811-b3e6-528bef191ab8";
     preLVM = true;
    }
  ];

  networking.hostName = "dysmorph";
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
    i18n = {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
    };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.sv
    blueman
    brave
    coreutils-full
    curl
    dnsutils
    docker
    emacs
    file
    firefox-wayland
    fzf
    gcc
    git
    gnupg
    gnumake
    grim
    jq
    libinput
    lksctp-tools
    lsof
    lttng-tools
    lttng-ust
    lxqt.pavucontrol-qt
    keybase
    mosh
    ncurses
    nload
    openssl
    pass
    patch
    pavucontrol
    pstree
    qt5.qtbase
    qutebrowser
    shellcheck
    slurp
    spotify
    sway
    swayidle
    swaylock
    telnet
    termite
    tree
    unzip
    wl-clipboard
    xwayland
  ];

  # enable swaylock to unlock
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # bash_completion
  programs.bash.enableCompletion = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  # size of /run/user/<uid>
  services.logind.extraConfig = "
RuntimeDirectorySize=60%
  ";

  # List services that you want to enable:
  services.flatpak.enable = true;
  services.keybase.enable = true;
  services.openssh.enable = true;

  # enable acpid
  services.acpid.enable = true;
  services.acpid.logEvents = true;
  services.acpid.lidEventCommands =
    "echo user - $(whoami) - 1:$1 2:$2 3:$3 >> /tmp/liduevent.log";

  # fonts
  fonts.fonts = with pkgs; [
      proggyfonts
  ];

  # enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # enable openGL
  hardware.opengl.enable = true;

  # flatpak wants you to enable XDG Desktop Portals
  xdg.portal.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.masse = {
    createHome = true;
    extraGroups = ["wheel" "audio" "video" "networkmanager" "docker"];
    isNormalUser = true;
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
