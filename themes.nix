{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
  ];

  home-manager.users.shrey = { pkgs, ... }: {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.google-cursor;
      name = "GoogleDot-Black";
      size = 21;
    };

    gtk = {
      enable = true;

      cursorTheme = {
        package = pkgs.google-cursor;
        name = "GoogleDot-Black";
        size = 21;
      };

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        package = pkgs.colloid-icon-theme;
        name = "Colloid-dark";
      };

      font = {
        name = "Sans";
        size = 11;
      };

      gtk3.extraConfig = {
        Settings = ''
          					gtk-application-prefer-dark-theme=1
          					'';
      };

      gtk4.extraConfig = {
        Settings = ''
          					gtk-application-prefer-dark-theme=1
          					'';
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    home.sessionVariables.GTK_THEME = "Adwaita-dark";
  };
}
