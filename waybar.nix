{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.shrey = { pkgs, ... }: {
    programs.waybar.enable = true;
    programs.waybar.settings = {
      mainBar = {
        layer = "top";
        spacing = 20;
        height = 0;
        margin-top = 5;
        margin-right = 18;
        margin-bottom = 0;
        margin-left = 18;
        modules-left = [ "custom/appmenuicon" "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "network" "battery" "backlight" "pulseaudio" ];
        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };
        clock = {
          format = "{:%I:%M %p - %a, %d %b %Y}";
          tooltip = false;
        };
        network = {
          format-wifi = "󰤢 {bandwidthDownBits}";
          format-ethernet = "󰤢 {bandwidthDownBits}";
          format-disconnected = "󰤠 No Network";
          interval = 5;
          tooltip = false;
        };
        pulseaudio = {
          scroll-step = 5;
          max-volume = 150;
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-icons = [ "" "" " " ];
          nospacing = 1;
          format-muted = " ";
          on-click = "pavucontrol";
          tooltip = false;
        };
        battery = {
          format = "{icon}  {capacity}%";
          interval = 5;
          states = {
            warning = 20;
            critical = 10;
          };
          format-icons = [ "" "" "" "" "" ];
          tooltip = true;
        };
        "custom/appmenuicon" = {
          format = "";
          on-click = "wofi --show=drun";
          tooltip-format = "";
        };
      };
    };
    programs.waybar.style = ''
      			@define-color fg #c7ab7a;
      			@define-color bg #1d2021;
      			@define-color accent #a9b665;

      			* {
      			    border: none;
      			    border-radius: 0;
      			    min-height: 30px;
      			    font-family: JetBrainsMono Nerd Font;
      			    font-weight: bold;
      			    font-size: 14px;
      			    padding: 0;
      			    background-color: transparent;
      			    color: @fg;
      			}

      			window#waybar {
      			    background: @bg;
      			    border-radius: 10;
      			}


      			#custom-appmenuicon {
      			    color: @accent;
      			    margin-left: 15px;
      			}

      			#pulseaudio {
      			    margin-right: 15px;
      			}

      			#workspaces button {
      			    all: initial;
      			    min-width: 0;
      			    box-shadow: inset 0 -3px transparent;
      			    padding: 4px 8px;
      			}

      			#workspaces button.active {
      			    border-bottom: 4px solid @accent;
      			    color: @accent;
      			}

      			#workspaces button.urgent {
      			    background-color: #e78a4e;
      			}

      			#taskbar button {
      			    all: initial;
      			    min-width: 0;
      			    box-shadow: inset 0 -3px transparent;
      			    padding: 4px 8px;
      			}

      			#taskbar button.active {
      			    border-bottom: 4px solid @accent;
      			    color: @accent;
      			}

      			#battery.urgent {
      			    color: @bg;
      			    background-color: #ea6962;
      			    border: 2px solid #303536;
      			}

      		'';
  };
}