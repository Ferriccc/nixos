{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.shrey = { pkgs, ... }: {
    programs.wofi.enable = true;
    programs.wofi.settings = {
      mode = "drun";
      allow_images = true;
      image_size = 30;
      prompt = "search, drun";
      columns = 1;
      width = 420;
      lines = 4;
      no_actions = true;
      monitor = "DP-1";
      location = "top";
      yoffset = 30;
      colors = "colors";
      filter_rate = 100;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      matching = "contains";
      insensitive = true;
      term = "kitty";
      parse_search = true;
      allow_markup = true;
      single_click = false;
      line_wrap = "char";
      key_down = "Tab";
      key_expand = "Right";
      key_forward = "Down";
    };
    programs.wofi.style = ''
      			* {
      					border: none;
      					box-shadow: none;
      					outline: none;
      			}

      			window {
      					font-size: 16px;
      					font-family: "monospace";
      					background-color: ${config.backgroundHex};
      					border-radius: 8px;
                border: 2px solid ${config.accentHex};
      			}

      			#outer-box {
      					margin: 10px 10px 20px 10px;
      					background-color: ${config.backgroundHex};
      			}

      			#inner-box {
      					margin: 10px;
      					background-color: ${config.backgroundHex};
      			}

      			#entry {
      					padding: 5px 10px;
      					border-radius: 20px;
      			}

      			#entry #text {
      					padding: 0px 0px 0px 10px;
      					font-weight: normal;
      					color: ${config.foregroundHex};
      			}

      			#entry:selected {
      					background-color: ${config.accentHex};
      			}

      			#entry:selected #text {
      					padding: 0px 0px 0px 10px;
      					font-weight: normal;
      					color: ${config.backgroundHex};
      			}

      			#input {
      					background: transparent;
      					margin: 0px 5px 0px 20px;
      					color: ${config.foregroundHex};
      					padding: 5px;
      			}

      			#image {
      					margin-left: 20px;
      					margin-right: 20px;
      			}

      			#scroll {
      					margin: 0px;
      			}
      		'';
  };
}
