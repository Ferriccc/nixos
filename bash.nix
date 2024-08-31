{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  # Setup for bash completions
  environment.pathsToLink = [ "/share/bash-completion" ];

  home-manager.users.shrey = { pkgs, ... }: {
    programs.bash.enable = true;
    programs.bash.bashrcExtra = ''
      			# If not running interactively, don't do anything
      			[[ $- != *i* ]] && return

      			# Initialize Starship prompt
      			eval "$(starship init bash)"

      			# Initialize Zoxide
      			eval "$(zoxide init bash)"
            
            # Add scripts directory to path
            export PATH=$PATH:~/scripts/

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
      			alias ls="exa -l --git --color=always --icons --sort=extension --no-user --no-permissions"
      			alias lt="exa --tree -l --git --color=always --icons --sort=extension --no-permissions --no-user"
      			alias cd="z"
            alias gon="bash ~/scripts/GmodeON.sh"
            alias goff="bash ~/scripts/GmodeOFF.sh"

      			# enable case-insensitive auto-completion
      			shopt -s nocaseglob
      			bind 'set completion-ignore-case on'

      			# enable history search with up and down arrows
      			bind '"\e[A": history-search-backward'
      			bind '"\e[B": history-search-forward'

      			PS1='[\u@\h \W]\$ '
      		'';
  };
}
