{ pkgs
, inputs
, username
, system
, ...
}: {
  imports = [
    ../desktop/ai
    ../desktop/audio.nix
    ../desktop/bitwarden
    ../desktop/discord.nix
    ../desktop/direnv.nix
    ../desktop/docker.nix
    ../desktop/extrautils.nix
    ../desktop/filesystems.nix
    ../desktop/filesync
    ../desktop/git.nix
    ../desktop/goxlr.nix
    ../desktop/graphics.nix
    ../desktop/hardware.nix
    ../desktop/home-manager.nix
    ./hyprland
    ../desktop/iscsi-shares.nix
    ../desktop/keybase.nix
    ../desktop/mangohud.nix
    ../desktop/networking.nix
    ../desktop/obs-studio.nix
    ../desktop/ollama.nix
    ../desktop/scripts.nix
    ../desktop/secrets
    ../desktop/spotify.nix
    ./stylix.nix
    ../desktop/terminal
    #../desktop/wireguard.nix
    ../desktop/zed.nix
    ../desktop/zsh.nix
  ];

  # User Programs
  programs.nh = {
    enable = true;
    flake = "/home/joey/Git/dotfiles";
  };
  programs.chromium.enable = false;
  programs.steam.enable = true;
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

    home.packages = with pkgs;
      [
        sops
        age
        ssh-to-age
        nvd
        libreoffice-qt6
        obsidian
        protonmail-desktop
        protonmail-bridge-gui
        losslesscut-bin
        aichat
        yek
        ffmpeg-full
      ]
      ++ [
        # Purely gaming
        prismlauncher
        protonup-qt
      ];
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.home-manager.enable = true;
    programs.mpv = {
      enable = true;
      config = {
        autofit-larger = "100%x100%";
        hwdec = "yes";
        audio-device = "alsa/pipewire";
        volume = "50";
      };
    };
    programs.tmux = {
      enable = true;
      newSession = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      mouse = true;
      prefix = "C-b";
      resizeAmount = 2;
      plugins = with pkgs; [
        { plugin = tmuxPlugins.resurrect; }
        { plugin = tmuxPlugins.tmux-fzf; }
      ];
      shell = "${pkgs.zsh.shellPath}";
    };
    programs.nnn.enable = true;
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${username}";
      homeDirectory = "/home/${username}";
    };
    xdg.systemDirs.data = [ "/usr/share" ];
    home.stateVersion = "24.11";
  };

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };
  nix.settings.download-buffer-size = 1073741824;
  nixpkgs = {
    hostPlatform = system;
    overlays = [
      inputs.nixgl.overlay
      inputs.chaotic.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Hardware, input devices
  services.printing.enable = false;
  hardware.wooting.enable = true;

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    powerline-symbols
    nerd-fonts.symbols-only
  ];

  sops = {
    age.sshKeyPaths = [ "/home/${username}/.ssh/joey.desktop@jafner.net" ];
    age.generateKey = false;
  };
  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # Read more: https://wiki.nixos.org/wiki/Linux_kernel
  # Other options:
  # - https://mynixos.com/nixpkgs/packages/linuxKernel.packages
  # - https://mynixos.com/nixpkgs/packages/linuxPackages

  environment.etc."current-nixos".source = ../.;
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
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings.auto-optimise-store = true;
  nix.extraOptions = ''
    accept-flake-config = true
    warn-dirty = false
  '';

  networking.hostName = "desktop";
  networking.hosts = {
    "192.168.1.1" = [ "wizard" ];
    "192.168.1.12" = [ "paladin" ];
    "192.168.1.23" = [ "fighter" ];
    "192.168.1.135" = [ "desktop" ];
    "143.198.68.202" = [ "artificer" ];
    "172.245.108.219" = [ "champion" ];
  };

  system.stateVersion = "24.11";
}
