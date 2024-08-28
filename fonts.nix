{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
