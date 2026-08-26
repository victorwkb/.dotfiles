{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/ghostty.nix
  ];

  home.username = "vicwkb";
  home.homeDirectory = "/home/vicwkb";
  home.stateVersion = "25.05";

  home.sessionPath = [ "/run/wrappers/bin" ];

  programs.nushell.extraEnv = ''
    $env.PATH = ($env.PATH | prepend "/run/wrappers/bin")
  '';

  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.zsh.shellAliases.wsl = "wsl.exe";
  programs.zsh.initContent = ''
    export PATH="/run/wrappers/bin:$PATH"
    _wcode="$(wslpath "$(powershell.exe -c '$env:USERPROFILE' | tr -d '\r\n')")/AppData/Local/Programs/Microsoft VS Code/bin/code"
    [[ -f "$_wcode" ]] && code() { "$_wcode" "$@"; }
  '';

  programs.nushell.extraConfig = ''
    def --wrapped code [...args] {
      let p = $"(wslpath (powershell.exe -c '$env:USERPROFILE' | str trim))/AppData/Local/Programs/Microsoft VS Code/bin/code"
      ^$p ...$args
    }
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "clip.exe"
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "clip.exe"
  '';

  programs.git.settings.user = {
    name = "victorignite";
    email = "victor.goh@ignitedata.com.au";
  };
}
