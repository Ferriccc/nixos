# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # NUR repo for spotify-adblock
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Disable Nvidia dGPU (device dependent)
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

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
  services.blueman.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shrey = {
    isNormalUser = true;
    description = "shrey";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };


  # Setup for libre-office
  environment.sessionVariables = {
    PYTHONPATH = "pkgs.libreoffice-fresh-unwrapped/lib/libreoffice/program";
    URE_BOOTSTRAP = "vnd.sun.star.pathname:pkgs.libreoffice-fresh-unwrapped/lib/libreoffice/program/fundamentalrc";
  };

  # Setup for bash completions
  environment.pathsToLink = [ "/share/bash-completion" ];

  # Hyprland
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Home-manager
  home-manager.backupFileExtension = "backup";
  home-manager.users.shrey = { pkgs, ... }: {
    # Hyprland config
		wayland.windowManager.hyprland = {
			enable = true;
			settings = {
				monitor = ", 1920x1080@120, auto, 1.25";
				exec-once = [
					"swww-daemon"
					"waybar"
					"wl-paste --watch cliphist store"
				];
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
					border_size = 0;
					resize_on_border = true;
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
							"move 100%-433 53, class:^(wofi)$, title:^(clippick)$"
						];
						windowrule = [
							"float,^(blueman-manager)$"
							"float,^(org.gnome.Calculator)$"
							"float,title:^(Picture-in-Picture)$"
							"float,^(eog)$"
							"size 40% 40%,^(blueman-manager)$"
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

		# Waybar config
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
					format= "{icon} {percent}%";
					format-icons = [ "" "" "" "" "" "" "" "" "" ];
				};
				clock = {
					format = "{:%I:%M %p - %a, %d %b %Y}";
					tooltip= false;
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
					tooltip = false;
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

		''; # Waybar config ends

		# Wofi config
		programs.wofi.enable = true;
		programs.wofi.settings = {
			mode = "drun";
			allow_images = true;
			image_size = 30;
			prompt = "search";
			columns = 1;
			width = 420;
			height = 330;
			no_actions = true;
			monitor = "DP-1";
			location = "center";
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
			@define-color black #111111;
			@define-color red #E17373;
			@define-color green #94B978;
			@define-color blue #96BDDB;
			@define-color cyan #00988E;
			@define-color yellow #FFB97B;

			* {
					border: none;
					box-shadow: none;
					outline: none;
			}

			window {
					font-size: 16px;
					font-family: "monospace";
					background-color: @black;
					border-radius: 8px;
			}

			#outer-box {
					margin: 10px 10px 20px 10px;
					background-color: @black;
			}

			#inner-box {
					margin: 10px;
					background-color: @black;
			}

			#entry {
					padding: 5px 10px;
					border-radius: 20px;
			}

			#entry #text {
					padding: 0px 0px 0px 10px;
					font-weight: normal;
					color: @color7;
			}

			#entry:selected {
					background-color: @yellow;
			}

			#entry:selected #text {
					padding: 0px 0px 0px 10px;
					font-weight: normal;
					color: @black;
			}

			#input {
					background: transparent;
					margin: 0px 5px 0px 20px;
					color: @color7;
					padding: 5px;
			}

			#image {
					margin-left: 20px;
					margin-right: 20px;
			}

			#scroll {
					margin: 0px;
			}
		''; # Wofi config ends

		# Kitty config
		programs.kitty.enable = true;
		programs.kitty.font.name = "monospace";
		programs.kitty.font.size = 12;
		programs.kitty.theme = "Gruvbox Dark Hard";
		programs.kitty.settings = {
			window_padding_width = 10;
			confirm_os_window_close = 0;
		}; # Kitty config ends

		# Starship config
		programs.starship.enable = true;

		# Bash config
		programs.bash.enable = true;
		programs.bash.bashrcExtra = ''
			# If not running interactively, don't do anything
			[[ $- != *i* ]] && return

			# Initialize Starship prompt
			eval "$(starship init bash)"

			# Initialize Zoxide
			eval "$(zoxide init bash)"

			# functions
			function rm() {
			    echo "Use trash instead!"
			}
			function cmp() {
			    local target="$1"
			    qt cmp -c ./cor.cpp -g ./gen.cpp -t "$target" --break-bad --save-bad
			}
			function chk() {
			    local target="$1"
			    qt check -c ./check.cpp -g ./gen.cpp -t "$target" --break_bad --save-bad
			}

			# aliases
			alias cat="bat"
			alias ls="exa -l --git --color=always --icons --sort=extension --no-user --no-permissions"
			alias lt="exa --tree -l --git --color=always --icons --sort=extension --no-permissions --no-user"
			alias cd="z"

			# enable case-insensitive auto-completion
			shopt -s nocaseglob
			bind 'set completion-ignore-case on'

			# enable history search with up and down arrows
			bind '"\e[A": history-search-backward'
			bind '"\e[B": history-search-forward'

			PS1='[\u@\h \W]\$ '
		'';

		# Media controls from bluetooth devices
		services.mpris-proxy.enable = true;

		home.pointerCursor = {
			gtk.enable = true;
# x11.enable = true;
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
				package = pkgs.gnome-themes-extra;
				name = "Adwaita-dark";
			};

			iconTheme = {
				package = pkgs.colloid-icon-theme;
				name = "Colloid";
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
		systemd.user.sessionVariables = config.home-manager.users.shrey.home.sessionVariables;

# Git creds
		programs.git = {
			enable = true;
			userName = "ferriccc";
			userEmail = "shrey.s4@ahduni.edu.in";
			extraConfig = {
				credential.helper = "oauth";
			};
		};

		home.stateVersion = "24.11";
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "shrey";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    neovim
    adwaita-icon-theme
    fastfetch
    pciutils
    pulseaudio
    playerctl
    pavucontrol
    swww
    dunst
    trash-cli
    ntfs3g
    hyprshot
    nodejs_22
    (python3.withPackages (python-pkgs: [
      python-pkgs.pynvim
      python-pkgs.pygobject3
    ]))
    clang-tools
    gcc13
    unzip
    nur.repos.nltch.spotify-adblock    
    dconf
    brightnessctl
    eza
    wl-clipboard
    clip
    cliphist
    waybar
    wofi
    discord
    kitty
    git
    gh
    vscode
    starship
    zoxide
    google-chrome
    # libreoffice-packs starts
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
    # libreoffice-packs ends
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
