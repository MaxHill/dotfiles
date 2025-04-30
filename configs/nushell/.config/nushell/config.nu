# config.nu
#
# Installed by:
# version = "0.102.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Imports
# ------------------
$env.config.show_banner = false

# Prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
starship preset pure-preset -o ~/.config/starship.toml

# Aliases
source ~/.config/nushell/aliases.nu


# fnm (fast node manager)
# ------------------
# eval "$(fnm env --use-on-cd --version-file-strategy "recursive" --log-level "quiet")"  # Init fnm (fast node manager)


# Tmux
# ------------------
# Start tmux if installed
if not ($env.TMUX | is-not-empty) {
    tmux attach or tmux new
}

# Install tmux plugins
~/.config/tmux/plugins/tpm/bin/install_plugins | ignore


# Set vim mode
# ------------------
$env.config.edit_mode = 'vi'


# PATH Management
# ------------------
# Set environment variables in Nushell

# Ensure PATH is set correctly
# Modify PATH to include custom directories
$env.PATH = ($env.PATH | append $"($env.HOME)/dotfiles/scripts")
$env.PATH = ($env.PATH | prepend "/usr/local/opt/curl/bin")
$env.PATH = ($env.PATH | append "/Applications")

# Set GOPATH
$env.GOPATH = $"($env.HOME)/go"

# Add Go binaries to PATH
$env.PATH = ($env.PATH | append "/usr/local/go/bin" | append $"($env.GOPATH)/bin")

# ------------------------------------------------------------------------
# Plugins                                                                     
# ------------------------------------------------------------------------ 
[ nu_plugin_inc
  nu_plugin_polars
  nu_plugin_gstat
  nu_plugin_formats
  nu_plugin_query
] | each { cargo install $in --locked } | ignore

# Keybindings for Nushell
let keybindings = [
    {
        name: "accept-suggestion"
        modifier: control
        keycode: char_y
        mode: ["emacs", "vi_normal", "vi_insert"]
        event: { send: HistoryHintComplete }
    }
    {
        name: "edit-command"
        modifier: control
        keycode: char_e
        mode: ["emacs", "vi_normal", "vi_insert"]
        event: {send: OpenEditor}
    }
]

$env.config.keybindings = $keybindings
