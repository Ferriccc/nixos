{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.shrey = { pkgs, ... }: {
    programs.kitty.enable = true;
    programs.kitty.font.name = "monospace";
    programs.kitty.font.size = 12;
    programs.kitty.theme = "Catppuccin-Mocha";
    programs.kitty.settings = {
      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
  };
}
