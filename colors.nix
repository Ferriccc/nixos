{ config, lib, pkgs, ... }:

{
  options = with lib; with types; {
    foregroundHex = mkOption { type = str; };
    backgroundHex = mkOption { type = str; };
    accentHex = mkOption { type = str; };
  };

  config = {
    foregroundHex = "#cdd6f4";
    backgroundHex = "#1e1e2e";
    accentHex = "#cba6f7";
  };
}
