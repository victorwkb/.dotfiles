{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.awscli
            pkgs.bat
            pkgs.eza
            pkgs.fastfetch
            pkgs.fd
            pkgs.fzf
            pkgs.git
            pkgs.kitty
            pkgs.lazygit
            pkgs.neovim
            pkgs.nil
            pkgs.nixfmt-rfc-style
            pkgs.ripgrep
            pkgs.starship
            pkgs.vim
            pkgs.tmux
            pkgs.zoxide
          ];
          services.nix-daemon.enable = true;
          nix.settings.experimental-features = "nix-command flakes";
          programs.zsh.enable = true; # default shell on catalina
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 5;
          nixpkgs.hostPlatform = "aarch64-darwin";
          security.pam.enableSudoTouchIdAuth = true;

          users.users.victorwkb.home = "/Users/victorwkb";
          home-manager.backupFileExtension = "backup";
          nix.configureBuildUsers = true;
          nix.useDaemon = true;

          system.defaults = {
            dock.autohide = true;
            dock.autohide-delay = 0.0;
            dock.mru-spaces = false;
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv";
            screencapture.location = "~/Pictures/screenshots";
            screensaver.askForPasswordDelay = 10;
          };

          homebrew = {
            enable = true;
            brews = [ ];
            casks = [
              "nikitabobko/tap/aerospace"
            ];
            taps = [
              "nikitabobko/tap"
            ];
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };
        };
    in
    {
      # $ darwin-rebuild build --flake .#Victors-MacBook-Pro
      darwinConfigurations."Victors-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.victorwkb = import ./home.nix;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              user = "victorwkb";
              enable = true;
              enableRosetta = true;
              autoMigrate = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Victors-MacBook-Pro".pkgs;
    };
}
