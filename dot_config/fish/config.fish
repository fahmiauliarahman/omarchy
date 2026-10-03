if command -q brew
    brew shellenv fish | source
end
set -gx SHELL /usr/bin/fish
fish_add_path /usr/local/bin ~/.local/bin

if status is-interactive
    set -g fish_greeting

    # Only initialize mise if we aren't ALREADY in a Poetry shell
    if not set -q VIRTUAL_ENV
        mise activate fish | source
    end

    # --- 1. Your Personal Workflow ---
    abbr -a projects "cd ~/Developer/projects"
    abbr -a flick "cd ~/Developer/projects/screen/flick && nvim ."
    abbr -a cfg "cd ~/.config/nvim && nvim ."

    # "cameo" translated for Fish (uses activate.fish)
    abbr -a cameo "cd ~/Developer/projects/screen/screen_cms/ && source .venv/bin/activate.fish"

    # --- 2. Dangerous/Complex Commands ---
    # Note: Fish handles env vars differently in single lines (no export needed for one-off)
    abbr -a clidanger "env ANTHROPIC_BASE_URL=http://127.0.0.1:8317 ANTHROPIC_AUTH_TOKEN=sk-apikey ANTHROPIC_DEFAULT_OPUS_MODEL=gemini-claude-sonnet-4-5-thinking ANTHROPIC_DEFAULT_SONNET_MODEL=gemini-claude-sonnet-4-5-thinking claude --dangerously-skip-permissions"

    # --- 3. Architecture Switching (Mac) ---
    # Switched 'zsh' to 'fish' so you stay in your new shell
    abbr -a arm "arch -arm64 fish"
    abbr -a intel "arch -x86_64 fish"

    # --- 4. Utilities ---
    abbr -a cat bat
    abbr -a _ sudo

    # Eza (ls replacement) - mimicking your old aliases
    abbr -a l "eza -lah"
    abbr -a la "eza -lAh"
    abbr -a ll "eza -al --group-directories-first"
    abbr -a ls "eza -al --color=always --sort=size | grep -v /"
    abbr -a lt "eza -al --sort=modified"

    # --- 5. Poetry Shortcuts ---
    abbr -a pad "poetry add"
    abbr -a prun "poetry run"
    abbr -a psh "poetry shell"
    abbr -a pinst "poetry install"
    abbr -a pup "poetry update"

    # --- 6. zoxide: better cd --- 
    abbr -a cd z

    # --- 7. reload fish config --- 
    abbr -a reload 'source ~/.config/fish/config.fish'
    abbr -a activate 'source .venv/bin/activate.fish'

end

# --- Functions for complex logic ---

# Function for 'showarch'
function showarch
    echo "Now you are using "(arch)" version"
end

# Your 'git-https' converter translated to a Fish function
function git-https
    set -l url (git remote get-url origin)
    set -l new_url (string replace -r '^git@([^:]*):/*(.*)$' 'https://$1/$2' $url)
    git remote set-url origin $new_url
end

# Your 'git-ssh' converter translated to a Fish function
function git-ssh
    set -l url (git remote get-url origin)
    set -l new_url (string replace -r '^https://([^/]*)/(.*)$' 'git@$1:$2' $url)
    git remote set-url origin $new_url
end
zoxide init fish | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# PHP version switcher for Fish. Homebrew is used on macOS and mise on Linux.
if command -q brew; or command -q mise
    function __cleanup_php_paths --description "Remove versioned Homebrew PHP paths from fish_user_paths and PATH"
        if test (uname) != Darwin
            return
        end

        set -l php_path_regex '.*/opt/php@[0-9]+\.[0-9]+/(bin|sbin)$'

        if set -q fish_user_paths
            set -l cleaned_user_paths
            for path_entry in $fish_user_paths
                if not string match -qr -- $php_path_regex $path_entry
                    set cleaned_user_paths $cleaned_user_paths $path_entry
                end
            end
            if test (count $cleaned_user_paths) -ne (count $fish_user_paths)
                set -U fish_user_paths $cleaned_user_paths
            end
        end

        set -l cleaned_path
        for path_entry in $PATH
            if not string match -qr -- $php_path_regex $path_entry
                set cleaned_path $cleaned_path $path_entry
            end
        end
        set -gx PATH $cleaned_path
    end

    function __installed_php_versions --description "List installed PHP major.minor versions"
        if test (uname) = Darwin
            brew list --formula 2>/dev/null | string match -r '^php@[0-9]+\.[0-9]+$' | string replace 'php@' '' | sort -V
        else
            mise ls --installed php --json 2>/dev/null \
                | string match -arg '"version": "([0-9]+\.[0-9]+)[^"]*"' \
                | sort -Vu
        end
    end

    function switchphp --description "Switch PHP version (example: switchphp 8.1)"
        set -l requested_version $argv[1]
        if test -z "$requested_version"
            echo "Usage: switchphp <major.minor>"
            set -l versions (__installed_php_versions)
            if test (count $versions) -gt 0
                echo "Installed: "(string join ", " $versions)
            end
            return 1
        end

        if test (uname) != Darwin
            if not contains -- $requested_version (__installed_php_versions)
                echo "PHP $requested_version is not installed."
                echo "Use 'installphp $requested_version' to install it."
                return 1
            end

            if not mise use --global "php@$requested_version"
                echo "Failed to switch to PHP $requested_version."
                return 1
            end

            command php -v | head -n 1
            return
        end

        set -l target_formula "php@$requested_version"
        if not contains -- $target_formula (brew list --formula 2>/dev/null)
            echo "Homebrew formula '$target_formula' is not installed."
            echo "Use 'installphp $requested_version' to install it."
            return 1
        end

        for installed_version in (__installed_php_versions)
            set -l installed_formula "php@$installed_version"
            if test "$installed_formula" != "$target_formula"
                brew unlink $installed_formula >/dev/null 2>&1
            end
        end

        if not brew link --overwrite --force $target_formula >/dev/null
            echo "Failed to link $target_formula."
            return 1
        end

        __cleanup_php_paths
        command php -v | head -n 1
    end

    function installphp --description "Install a new PHP version (example: installphp 8.4)"
        set -l requested_version $argv[1]
        if test -z "$requested_version"
            echo "Usage: installphp <major.minor>"
            set -l versions (__installed_php_versions)
            if test (count $versions) -gt 0
                echo "Installed: "(string join ", " $versions)
            end
            if test (uname) = Darwin
                echo -e "\nTo see all available versions: brew search php"
            else
                echo -e "\nTo see all available versions: mise ls-remote php"
            end
            return 1
        end

        if test (uname) != Darwin
            if contains -- $requested_version (__installed_php_versions)
                echo "PHP $requested_version is already installed."
                switchphp $requested_version
                return $status
            end

            if command -q omarchy
                set -l php_build_dependencies base-devel autoconf bison re2c pkgconf libxml2 openssl icu libzip oniguruma curl libpng libjpeg-turbo freetype2 libwebp gmp libsodium readline bzip2
                set -l missing_dependencies
                for dependency in $php_build_dependencies
                    if not pacman -Q $dependency >/dev/null 2>&1
                        set -a missing_dependencies $dependency
                    end
                end

                if test (count $missing_dependencies) -gt 0
                    echo "Installing PHP build dependencies: "(string join ", " $missing_dependencies)
                    if not omarchy pkg add $missing_dependencies
                        echo "Failed to install PHP build dependencies."
                        return 1
                    end
                end
            end

            echo "Installing PHP $requested_version via mise..."
            if not mise use --global "php@$requested_version"
                echo "Failed to install PHP $requested_version."
                return 1
            end

            echo "Successfully installed PHP $requested_version!"
            command php -v | head -n 1
            return
        end

        set -l target_formula "php@$requested_version"

        if contains -- $target_formula (brew list --formula 2>/dev/null)
            echo "PHP $requested_version is already installed."
            echo "Use 'switchphp $requested_version' to switch to it."
            return 0
        end

        echo "Installing $target_formula via Homebrew..."
        if not brew install $target_formula
            echo "Failed to install $target_formula."
            echo "The version may not be available. Check with: brew search php"
            return 1
        end

        echo "Successfully installed $target_formula!"
        echo "You can now use: $requested_version"
        switchphp $requested_version
    end

    __cleanup_php_paths

    # Create version functions for all installed versions
    for installed_version in (__installed_php_versions)
        function $installed_version -V installed_version
            switchphp $installed_version
        end
    end
end
eval "$(mise activate fish)"
set -gx GLAB_SKIP_TLS_VERIFY true

# Pi
fish_add_path "/Users/fahmaauliarahman/.local/share/mise/installs/node/24.9.0/bin"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
