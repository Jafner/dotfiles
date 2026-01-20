{
  pkgs,
  username,
  ...
}: {
  imports =
    [
      ./ai
      ./bitwarden
      ./desktop-environment
      ./filesync
    ]
    ++ [
      ./default-applications.nix
      ./discord.nix
      ./extrautils.nix
      ./filesystems.nix
      ./git.nix
      ./goxlr.nix
      ./hardware
      ./home-manager.nix
      ./mangohud.nix
      ./minecraft.nix
      ./networking.nix
      ./nix.nix
      ./obs-studio.nix
      ./scripts.nix
      ./spotify.nix
      ./stylix.nix
      ./terminal.nix
      ./zed.nix
      ./zsh.nix
    ];
  programs.steam.enable = true;
  # Command for Overwatch:
  # PROTON_ENABLE_WAYLAND=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 LD_PRELOAD="" mangohud obs-gamecapture %command%
  home-manager.users."${username}" = {
    home.file.".ssh/config" = {
      enable = true;
      text = ''
        Host *
            ForwardAgent yes
            IdentityFile ~/.ssh/joey.desktop@jafner.net
      '';
      target = ".ssh/config";
    };
    home.file.".ssh/profiles" = {
      enable = true;
      text = ''
        vyos@wizard
        admin@paladin
        admin@fighter
        admin@artificer
        admin@champion
      '';
      target = ".ssh/profiles";
    };

    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
      nvd
      libreoffice-qt6
      obsidian
      losslesscut-bin
      ffmpeg-full
      protonup-qt
    ];
    programs.home-manager.enable = true;
    programs.nnn.enable = true;
    programs.mpv = {
      enable = true;
      config = {
        autofit-larger = "100%x100%";
        hwdec = "yes";
        audio-device = "alsa/pipewire";
        volume = "50";
      };
    };
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${username}";
      homeDirectory = "/home/${username}";
    };
    xdg.systemDirs.data = ["/usr/share"];
    home.stateVersion = "24.11";
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };
  services.pulseaudio.enable = false;

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    powerline-symbols
    nerd-fonts.symbols-only
  ];

  sops = {
    age.sshKeyPaths = ["/home/${username}/.ssh/joey.desktop@jafner.net"];
    age.generateKey = false;
  };
  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
  };

  #boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages;
  # Read more: https://wiki.nixos.org/wiki/Linux_kernel
  # Other options:
  # - https://mynixos.com/nixpkgs/packages/linuxKernel.packages
  # - https://mynixos.com/nixpkgs/packages/linuxPackages

  environment.etc."current-nixos".source = ../../.;
  environment.systemPackages = with pkgs; [
    coreutils
    git
    tree
    htop
    file
    fastfetch
    dig
    btop
    vim
    tree
    comma
  ];

  programs.nix-ld.enable = true;
  systemd.enableEmergencyMode = false;

  # Enable SSH server with exclusively key-based auth
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
    description = "${username}";
    openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile ../../keys.txt); # Equivalent to `curl https://github.com/Jafner.keys > /home/$USER/.ssh/authorized_keys`
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };

  time.timeZone = "America/Los_Angeles";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.stateVersion = "24.11";
}
