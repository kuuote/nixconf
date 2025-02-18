#!/usr/bin/env bash
set -u

die() {
    echo "$@"
    exit 1
}

check() {
    [[ -x "$switcher" ]] || die "switcher is not executable"
    grep -q "switch-to-configuration-wrapped" "$switcher" || die "switcher is corrupt"
}

result="$(realpath "$1")"
action="$2"
switcher="$result/bin/switch-to-configuration"

case "$action" in
    boot|switch)
        set_profile=true
        ;;
    test)
        set_profile=false
        ;;
    *)
        die "unknown action: $action"
esac

check "$result"

if [[ "$set_profile" = "true" ]]; then
    nix-env -p /nix/var/nix/profiles/system --set "$result"
fi

"$switcher" "$action"
