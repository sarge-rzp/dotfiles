{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  # NOTE: Determinate is not actually installed on this machine (no
  # determinate-nixd, no /etc/nix/nix.custom.conf, and /etc/nix/nix.conf is the
  # plain upstream one). So nothing owns the Nix daemon, which is why
  # org.nixos.nix-daemon.plist had to be restored by hand. Revisit: flipping
  # this to true hands nix-darwin /etc/nix/nix.conf, which currently carries
  # `ssl-cert-file = /etc/nix/ca-bundle.pem` for Zscaler TLS interception. That
  # line must be preserved via nix.settings or every download breaks.
  nix.enable = false;

  # Mounts the encrypted Nix Store volume at /nix on boot. Without it the
  # system mounts the volume at /Volumes/Nix Store instead, /nix stays empty,
  # and every symlink into the store dangles -- including /etc/static/zshrc,
  # which leaves the login shell with a bare PATH and no working `nix`.
  #
  # The script text is inlined rather than referenced as a store path on
  # purpose: this daemon is what makes /nix available, so a ${./script}
  # reference would not exist at the moment it needs to run. See the header of
  # scripts/nix-mount-store.sh for the full mechanism.
  launchd.daemons.darwin-store = {
    serviceConfig = {
      Label = "org.nixos.darwin-store";
      RunAtLoad = true;
      ProgramArguments = [
        "/bin/bash"
        "-c"
        (builtins.readFile ./scripts/nix-mount-store.sh)
      ];
    };
  };

  # The Nix daemon itself. The upstream installer drops this plist into
  # /Library/LaunchDaemons, but nothing puts it back if it is removed -- which
  # is how this machine ended up with a mounted store and no working `nix`.
  # Declaring it here means a rebuild restores it.
  #
  # Mirrors the plist shipped in the nix package at
  # /nix/var/nix/profiles/default/Library/LaunchDaemons. wait4path is what lets
  # this be declared independently of the mount: launchd blocks until
  # darwin-store has brought /nix up, rather than failing on a missing binary.
  #
  # This block is a TRIGGER as much as a definition, and the file it installs
  # is not the one that ends up on disk. nix-darwin's "Restore unmanaged Nix
  # daemon" step (see `activate`, near the end of the launchd section) copies
  # the profile's own plist over whatever is at
  # /Library/LaunchDaemons/org.nixos.nix-daemon.plist -- but only when
  # /run/current-system already declares that daemon. With nix.enable = false
  # and no block here, that condition is never met and the restore never runs,
  # which is why a deleted nix-daemon plist previously stayed deleted. The two
  # plists are behaviourally identical (verified by comparing parsed plists),
  # so the overwrite is harmless; removing this block would silently switch the
  # restore back off.
  #
  # Conflicts with `nix.enable = true` -- nix-darwin defines this daemon itself
  # in that mode, so remove this block if that flag is ever flipped.
  launchd.daemons.nix-daemon = {
    serviceConfig = {
      Label = "org.nixos.nix-daemon";
      RunAtLoad = true;
      KeepAlive = true;
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path /nix/var/nix/profiles/default/bin/nix-daemon && exec /nix/var/nix/profiles/default/bin/nix-daemon"
      ];
      StandardErrorPath = "/var/log/nix-daemon.log";
      StandardOutPath = "/dev/null";
      SoftResourceLimits.NumberOfFiles = 1048576;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = "sarthak.j";
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  # Off on purpose. nix-homebrew wants to own /opt/homebrew, but this machine
  # already has a manual Homebrew install there (git repo, 62 formulae). Its
  # setup-homebrew step refuses to clobber that and exits non-zero, and
  # `activate` runs under `set -e` -- so activation died before the
  # home-manager step and no config ever reached $HOME. Declarative Brewfile
  # management comes from the `homebrew` block below, which does not need this.
  # Flipping this back on requires autoMigrate = true, which deletes the
  # existing Homebrew installation.
  nix-homebrew = {
    enable = false;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "check";  # abort activation if anything installed is not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    taps = [
      { name = "coralogix/tap"; trusted = true; }
      {
        name = "razorpay/swe-agent";
        clone_target = "https://github.com/razorpay/swe-agent.git";
        trusted = true;
      }
    ];
    brews = [
      "colima"
      "coreutils"
      "coralogix/tap/cx"
      "docker"
      "docker-compose"
      "fd"
      "fzf"
      "gh"
      "go"
      "helm"
      "herdr"
      "kubernetes-cli"
      "lazygit"
      { name = "mysql"; restart_service = "changed"; }
      "neovim"
      "node"
      "python@3.11"
      "ripgrep"
      "tmux"
      "uv"
    ];
    casks = [
      "docker-desktop"
      "wezterm"
      "claude-code"
    ];
  };
}
