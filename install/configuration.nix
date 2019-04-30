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
     device = "/dev/sda2";
     preLVM = true;
    }
  ];

  networking.hostName = "xanax";
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
    awscli
    aws-vault
    coreutils-full
    curl
    docker
    docker-compose
    emacs
    file
    flatpak
    fzf
    git
    gnupg
    grim
    jq
    keybase
    kubectl
    libinput
    mosh
    lsof
    lxqt.pavucontrol-qt
    pass
    pgadmin
    qutebrowser
    shellcheck
    slurp
    spotify
    sway
    swayidle
    swaylock
    termite
    tmux
    tree
    tshark
    unzip
    wireshark
    xwayland
  ];

  # enable swaylock to unlock

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # enable openGL
  hardware.opengl.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.masse = {
    createHome = true;
    extraGroups = ["wheel" "audio" "networkmanager"];
    isNormalUser = true;
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
