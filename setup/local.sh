#!/bin/bash
#
# Ask for this machine's private settings and write the untracked *.local files the dotfiles
# read (see "Local customizations" in the README). Every question can be left empty: that
# setting is skipped. Files that already exist are left as they are, so re-runs are safe;
# delete one to be asked again. Secrets go to the macOS Keychain, never into a file.
#
# ---

set -euo pipefail

cd "$(dirname "$0")/.."

BLUE=$(tput setaf 4)
DIM=$(tput dim)
RESET=$(tput sgr0)

info() {
  echo
  echo "  [ ${BLUE}..${RESET} ] $1"
}

# ask VAR "Question" ["hint"]: read one line into VAR; empty is fine
ask() {
  local hint=${3:+ ${DIM}($3)${RESET}}
  IFS= read -r -p "    $2$hint: " "$1" || true # ^D counts as empty
}

# Quote a value for a git config file
git_quote() {
  local value=${1//\\/\\\\}
  printf '"%s"' "${value//\"/\\\"}"
}

# Write a file readable only by you (these hold emails, hostnames and secret names)
write_private() {
  (umask 077 && cat > "$1")
  echo "    wrote $1"
}

# exists FILE: true (and says so) when FILE is already there
exists() {
  if [[ -e $1 ]]; then
    echo "    $1 exists, left unchanged (delete it to be asked again)"
    return 0
  fi
  return 1
}

if [[ ! -t 0 ]]; then
  echo "No terminal to ask in: skipping the *.local files (run setup/local.sh later)"
  exit 0
fi

echo "  Leave any answer empty to skip that setting."

# ----- ~/.gitconfig.local -----
info 'Git (~/.gitconfig.local)'
file="$HOME/.gitconfig.local"
if ! exists "$file"; then
  ask git_name 'Commit name' "empty keeps \"$(git config -f tilde/.gitconfig user.name)\""
  ask git_email 'Commit email' "empty keeps $(git config -f tilde/.gitconfig user.email)"
  ask github_user 'GitHub username'
  ask github_ssh 'Clone https://github.com/ URLs over SSH? [y/N]'
  ask work_host 'Work Git host, for a separate identity in its repositories' 'e.g. git.example.com'
  if [[ -n $work_host ]]; then
    ask work_email "Commit email for $work_host repositories"
    ask work_name "Commit name for $work_host repositories" 'empty keeps the one above'
  fi

  {
    if [[ -n $git_name || -n $git_email ]]; then
      echo '[user]'
      [[ -n $git_name ]] && echo "  name = $(git_quote "$git_name")"
      [[ -n $git_email ]] && echo "  email = $(git_quote "$git_email")"
    fi
    if [[ -n $github_user ]]; then
      echo '[github]'
      echo "  user = $(git_quote "$github_user")"
    fi
    if [[ $github_ssh == [yY]* ]]; then
      echo '[url "git@github.com:"]'
      echo '  insteadOf = https://github.com/'
    fi
    if [[ -n $work_host ]]; then
      # https, ssh:// (any port) and scp-style remotes of the work host
      for remote in "https://$work_host/**" "ssh://git@$work_host*/**" "git@$work_host:*/**"; do
        echo "[includeIf \"hasconfig:remote.*.url:$remote\"]"
        echo '  path = ~/.gitconfig.work'
      done
    fi
    true
  } | write_private "$file"

  if [[ -n $work_host ]] && [[ -n $work_email || -n $work_name ]] && ! exists "$HOME/.gitconfig.work"; then
    {
      echo '[user]'
      [[ -n $work_name ]] && echo "  name = $(git_quote "$work_name")"
      [[ -n $work_email ]] && echo "  email = $(git_quote "$work_email")"
      true
    } | write_private "$HOME/.gitconfig.work"
  fi
fi

# ----- ~/.zsh.local -----
info 'Shell secrets (~/.zsh.local)'
file="$HOME/.zsh.local"
if ! exists "$file"; then
  ask secrets 'Keychain secrets to export in every shell, space-separated' 'e.g. GITHUB_TOKEN OPENAI_API_KEY'
  read -r -a names <<< "$secrets"

  for name in ${names[@]+"${names[@]}"}; do
    if ! [[ $name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
      echo "    $name isn't a valid variable name, skipped"
      continue
    fi
    if bin/keychain get "$name" &> /dev/null; then
      echo "    $name is already in the Keychain"
    else
      echo "    Value for $name (hidden; empty to set it later with \`keychain set $name\`)"
      bin/keychain set "$name" || true
    fi
    valid+=("$name")
  done

  {
    echo '# Machine-specific shell settings, sourced by ~/.zshrc (not checked in)'
    if [[ -n ${valid[*]:-} ]]; then
      echo
      echo '# Secrets from the macOS Keychain (add one with `keychain set NAME`)'
      echo "eval \"\$(keychain export ${valid[*]})\""
    fi
  } | write_private "$file"
fi

# ----- ~/.macos.local -----
info 'macOS settings for setup/macos.sh (~/.macos.local)'
file="$HOME/.macos.local"
if ! exists "$file"; then
  current_languages=$(defaults read -g AppleLanguages 2> /dev/null | tr -d ' ",()' | tr '\n' ' ' | xargs || true)
  ask computer_name 'Computer name' "now: $(scutil --get ComputerName 2> /dev/null || echo unset)"
  ask local_hostname 'Local hostname (letters, digits, -)' "now: $(scutil --get LocalHostName 2> /dev/null || echo unset)"
  ask languages 'Languages, space-separated' "now: $current_languages"
  ask locale 'Locale' "now: $(defaults read -g AppleLocale 2> /dev/null || echo unset)"
  ask timezone 'Time zone' "now: $(readlink /etc/localtime | sed 's|.*/zoneinfo/||')"

  {
    echo '# Personal settings for setup/macos.sh (not checked in); unset ones are skipped'
    [[ -n $computer_name ]] && printf 'COMPUTERNAME=%q\n' "$computer_name"
    [[ -n $local_hostname ]] && printf 'LOCALHOSTNAME=%q\n' "$local_hostname"
    if [[ -n $languages ]]; then
      read -r -a langs <<< "$languages"
      printf 'LANGUAGES=('
      printf '%q ' "${langs[@]}" | sed 's/ $//'
      printf ')\n'
    fi
    [[ -n $locale ]] && printf 'LOCALE=%q\n' "$locale"
    [[ -n $timezone ]] && printf 'TIMEZONE=%q\n' "$timezone"
    true
  } | write_private "$file"
fi

# ----- ~/.config/mise/config.local.toml -----
info 'Extra runtimes for this machine (~/.config/mise/config.local.toml)'
file="tilde/.config/mise/config.local.toml" # ~/.config/mise links here; git-ignored
if ! exists "$file"; then
  ask tools 'mise tools, space-separated' 'e.g. terraform kubectl@1.31'
  read -r -a specs <<< "$tools"
  if [[ ${#specs[@]} -gt 0 ]]; then
    {
      echo '[tools]'
      for spec in "${specs[@]}"; do
        version=latest
        [[ $spec == *@* ]] && version=${spec#*@}
        printf '"%s" = "%s"\n' "${spec%%@*}" "$version"
      done
    } | write_private "$file"
  else
    echo '    nothing to add'
  fi
fi
