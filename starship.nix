{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.shrey = { pkgs, ... }: {
    programs.starship.enable = true;
  };
}
