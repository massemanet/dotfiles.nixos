store_path() {
    dirname "$(dirname "$(readlink -f "$(command -v "$1")")")"
}
# shellcheck disable=SC1090
for cf in "$(store_path git)/share/git/contrib/completion/git-completion.bash" \
              "$(store_path git)/share/git/contrib/completion/git-prompt.sh" \
              "$(store_path bazel)/share/bash-completion/completions/bazel" \
              "$HOME/git/hecs/hecs_completions.sh" \
              "/etc/profile.d/bash_completion.sh"
do
    [ -f "$cf" ] && . "$cf"
done
