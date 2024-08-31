{ pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
      ./hardware-configuration.nix
    ];

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot

    # enables A2DP support for mordern headset
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  home-manager.users.shrey = { pkgs, ... }: {
    # Media controls from bluetooth devices
    services.mpris-proxy.enable = true;
  };
}
