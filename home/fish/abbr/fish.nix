{
  # fast way to reload fish
  ef = "exec fish";
  eff = "exec env -i (systemctl --user show-environment) TERM=$TERM (type -P fish)";
}
