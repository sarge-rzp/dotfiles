{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    # Machine-local env (PATHs, tokens, work tooling) stays outside the repo
    # so secrets never reach the nix store or git.
    envExtra = ''
      [ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"
    '';
    initContent = ''
      bindkey '^f' autosuggest-accept
      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      co = "codex --full-auto";
      cc = "claude";
      ccw = "claude --settings ~/.claude/razorpay-settings.json";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      # Rendering budget. scan_timeout caps the filesystem walk that decides
      # which language modules apply; command_timeout caps each `git`/version
      # subprocess. Both are per-prompt, so a slow repo degrades to a smaller
      # prompt instead of a laggy shell.
      scan_timeout = 30;
      command_timeout = 1000;
      add_newline = true;

      # Line 1: context (who/where/git) ... pushed apart by $fill ... toolchain + timing.
      # Line 2: just the prompt character, so typed commands always start at
      # the same column no matter how long the context line got.
      format = "$os$username$hostname$directory$git_branch$git_state$git_status$git_metrics$fill$nix_shell$package$nodejs$python$golang$rust$java$lua$docker_context$cmd_duration$status$jobs$time$line_break$character";

      palette = "catppuccin_mocha";
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
      };

      # Blank filler: the right-hand group floats to the terminal edge without
      # drawing a rule across the line.
      fill = {
        symbol = " ";
        style = "overlay0";
      };

      os = {
        disabled = false;
        style = "bold lavender";
        format = "[$symbol]($style) ";
        symbols.Macos = "󰀵";
      };

      # Only surfaced when it is not me on this machine - i.e. over SSH or as root.
      username = {
        show_always = false;
        style_user = "bold peach";
        style_root = "bold red";
        format = "[$user]($style)[@](overlay1)";
      };
      hostname = {
        ssh_only = true;
        ssh_symbol = "󰣀 ";
        style = "bold peach";
        format = "[$ssh_symbol$hostname]($style) ";
      };

      directory = {
        style = "bold sapphire";
        # Inside a repo, show the path from the repo root and highlight the
        # root itself, so "which project" reads before "how deep am I".
        truncate_to_repo = true;
        truncation_length = 3;
        truncation_symbol = "…/";
        repo_root_style = "bold blue";
        before_repo_root_style = "overlay1";
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        read_only = " 󰌾";
        read_only_style = "red";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        symbol = " ";
        style = "bold mauve";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        truncation_length = 24;
        truncation_symbol = "…";
        ignore_branches = [ ];
      };

      # Rebase/merge/bisect state - the thing you most want to be reminded of.
      git_state = {
        style = "bold peach";
        format = "[($state( $progress_current/$progress_total))]($style) ";
      };

      git_status = {
        style = "red";
        format = "([$all_status$ahead_behind]($style))";
        conflicted = "[~$count](maroon) ";
        ahead = "[⇡$count](teal) ";
        behind = "[⇣$count](teal) ";
        diverged = "[⇡$ahead_count⇣$behind_count](maroon) ";
        up_to_date = "";
        untracked = "[?$count](subtext0) ";
        stashed = "[≡$count](sapphire) ";
        modified = "[!$count](yellow) ";
        staged = "[+$count](green) ";
        renamed = "[»$count](yellow) ";
        deleted = "[✘$count](red) ";
      };

      # Line-level churn, so the size of the diff is visible before `git diff`.
      git_metrics = {
        disabled = false;
        added_style = "green";
        deleted_style = "red";
        format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
      };

      nix_shell = {
        symbol = " ";
        style = "bold sky";
        impure_msg = "[impure](yellow)";
        pure_msg = "[pure](green)";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      package = {
        symbol = "󰏗 ";
        style = "peach";
        format = "[$symbol$version]($style) ";
      };
      nodejs = {
        symbol = " ";
        style = "green";
        format = "[$symbol($version)]($style) ";
      };
      python = {
        symbol = " ";
        style = "yellow";
        format = "[$symbol($version)( \\($virtualenv\\))]($style) ";
      };
      golang = {
        symbol = " ";
        style = "sky";
        format = "[$symbol($version)]($style) ";
      };
      rust = {
        symbol = " ";
        style = "peach";
        format = "[$symbol($version)]($style) ";
      };
      java = {
        symbol = " ";
        style = "maroon";
        format = "[$symbol($version)]($style) ";
      };
      lua = {
        symbol = " ";
        style = "blue";
        format = "[$symbol($version)]($style) ";
      };
      docker_context = {
        symbol = " ";
        style = "sapphire";
        format = "[$symbol$context]($style) ";
      };

      cmd_duration = {
        min_time = 2000;
        style = "bold yellow";
        format = "[󰔛 $duration]($style) ";
        show_notifications = false;
      };

      # Last exit code, only when non-zero.
      status = {
        disabled = false;
        style = "bold red";
        symbol = "✘ ";
        format = "[$symbol$status]($style) ";
        # map_symbol/pipestatus off on purpose: both swap the plain exit code
        # for emoji or a bracketed pipeline dump, which is wider and harder
        # to read than the number I actually want.
        map_symbol = false;
        pipestatus = false;
      };

      jobs = {
        symbol = " ";
        style = "bold teal";
        number_threshold = 1;
        format = "[$symbol$number]($style) ";
      };

      time = {
        disabled = false;
        style = "overlay1";
        time_format = "%H:%M";
        format = "[ $time]($style)";
      };

      character = {
        success_symbol = "[❯](bold mauve)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";

  # The entries below stay DISABLED until their sources exist under
  # ${dotfiles}/home/. mkOutOfStoreSymlink does not check its target at build
  # time, so enabling one with no source replaces the live config
  # (~/.config/nvim, ~/.claude/settings.json, ~/.pi/agent/extensions, ...)
  # with a dangling symlink. Move the real files into home/ first, then
  # uncomment only the entries whose sources exist.
  home.file.".config/nvim".source =
   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # Claude-only instructions. CLAUDE.md pulls in RTK.md and AGENTS.md with
  # `@name` imports, which resolve next to CLAUDE.md — so all three have to be
  # reachable from ~/.claude/, not just this one.
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/CLAUDE.md";
  home.file.".claude/RTK.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/RTK.md";
  #
  # # Keep Pi's credential and runtime state local by linking only authored files and directories.
  # home.file.".pi/agent/themes".source =
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  # home.file.".pi/agent/extensions".source =
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  # home.file.".pi/agent/models.json".source =
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  # home.file.".pi/agent/settings.json".source =
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";
  #
  # One AGENTS.md, three readers. ~/.claude/CLAUDE.md stays a real local file
  # and pulls this in with `@AGENTS.md`, which resolves next to CLAUDE.md —
  # hence the .claude/AGENTS.md link below, without which that import dangles.
  home.file.".claude/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
