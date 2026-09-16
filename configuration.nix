{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

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
