{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.shrey = { pkgs, ... }: {
    programs.git = {
      enable = true;
      userName = "ferriccc";
      userEmail = "shrey.s4@ahduni.edu.in";
      extraConfig = {
        credential.helper = "oauth";
      };
    };
  };
}
