{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  # Enable polkit auth agent
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # xdg-desktop-portals
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  home-manager.users.shrey = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = ", 1920x1080@120, auto, 1.25";
        exec-once = [ "swww-daemon" "waybar" "wl-paste --watch cliphist store" "nm-applet" "blueman-applet" ];
        "$term" = "kitty";
        "$screenshot" = "hyprshot -m region";
        "$colorpicker" = "hyprpicker -a";
        "$launcher_drun" = "wofi --show=drun";
        "$clipboard_history" = "cliphist list | wofi --show=dmenu | cliphist decode | wl-copy";
        xwayland = {
          force_zero_scaling = true;
        };
        general = {
          gaps_in = 5;
          gaps_out = 5;
          resize_on_border = true;
          border_size = 0;
          # "col.active_border" = "RBG(${builtins.substring 1 6 config.backgroundHex + "ff"})";
        };
        decoration = {
          rounding = 10;
        };
        animations = {
          enabled = true;
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92 "
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "fluent_decel, 0.1, 1, 0, 1"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
          ];
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 2.5, md3_decel"
            "workspaces, 1, 3.5, easeOutExpo, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };
        gestures = {
          workspace_swipe = false;
        };
        input = {
          kb_layout = "us";
          sensitivity = "0.1";
          follow_mouse = "1";
          scroll_method = "2fg";
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap-to-click = true;
          };
        };
        misc = {
          disable_hyprland_logo = true;
          focus_on_activate = true;
          vrr = "1";
          enable_swallow = true;
          swallow_regex = "^(kitty)$";
        };
        custom = {
          rules = {
            windowrulev2 = [
              "animation slide, class:^(wofi)$"
              "animation slide, class:^(wofi)$, title:^(clippick)$"
            ];
            windowrule = [
              "float,^(org.gnome.Calculator)$"
              "float,title:^(Picture-in-Picture)$"
              "float,^(eog)$"
              "size 60% 80%,^(org.gnome.Calculator)$"
              "size 60% 80%,^(eog)$"
            ];
            workspace = [
              "1, persistent:true"
              "2, persistent:true"
              "3, persistent:true"
              "4, persistent:true"
              "5, persistent:true"
            ];
          };

          binds = {
            bindm = [
              "SUPER, mouse:272, movewindow"
              "SUPER, mouse:273, resizewindow"
            ];
            bind = [
              "SUPER_SHIFT, l, resizeactive, 50 0"
              "SUPER_SHIFT, h, resizeactive, -50 0"
              "SUPER_SHIFT, j, resizeactive, 0 50"
              "SUPER_SHIFT, k, resizeactive, 0 -50"
              "SUPER, RETURN, exec, kitty --single-instance"
              "SUPER, Q, killactive,"
              "SUPER, S, exec, $screenshot"
              "SUPER, Y, togglesplit"
              "SUPER, v, exec, pkill wofi || $clipboard_history"
              "SUPER, space, exec, pkill wofi || $launcher_drun"
              "SUPER, M, fullscreen"
              "SUPER_SHIFT, M, exec, hyprctl dispatch exit"
              "SUPER, F, togglefloating,"
              "SUPER, 1, workspace, 1"
              "SUPER, 2, workspace, 2"
              "SUPER, 3, workspace, 3"
              "SUPER, 4, workspace, 4"
              "SUPER, 5, workspace, 5"
              "SUPER_SHIFT, 1, movetoworkspace, 1"
              "SUPER_SHIFT, 2, movetoworkspace, 2"
              "SUPER_SHIFT, 3, movetoworkspace, 3"
              "SUPER_SHIFT, 4, movetoworkspace, 4"
              "SUPER_SHIFT, 5, movetoworkspace, 5"
              ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +1%"
              ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -1%"
              ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
              ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
              ", XF86AudioMedia, exec, playerctl play-pause"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioStop, exec, playerctl stop"
              ", XF86AudioPrev, exec, playerctl previous"
              ", XF86AudioNext, exec, playerctl next"
              ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
              ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
              ", switch:off:Lid Switch, exec, systemctl suspend"
            ];
          };
        };
      };
    }; # Hyprland config ends
  };
}
