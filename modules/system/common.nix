{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;

  environment.systemPackages = [
    pkgs.bat
    pkgs.eza
    pkgs.fastfetch
    pkgs.nerdfetch
    pkgs.cbonsai
    pkgs.cmatrix
    pkgs.htop
    pkgs.pipes
    pkgs.fd
    pkgs.fzf
    pkgs.git
    pkgs.lazygit
    pkgs.neovim
    pkgs.nodejs_22
    pkgs.pnpm
    pkgs.carapace
    pkgs.nushell
    pkgs.nu_scripts
    pkgs.ripgrep
    pkgs.vim
    pkgs.wget
    pkgs.nil
    pkgs.nixfmt
    pkgs.claude-code
    pkgs.gh
    pkgs.obsidian
  ];
}
