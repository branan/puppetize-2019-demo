plan demo::setup(
  Boolean $allow_none = false
) {
  $targets = get_targets(agents)
  $groups = $allow_none? {
    true => [old, new, none],
    default => [old, new],
  }
  $grouped_targets = randomly_group($targets, $groups)
  run_plan("demo::uninstall", { nodes => $targets })
  run_plan("demo::install_old", { nodes => $grouped_targets[old] })
  run_plan("demo::install_new", { nodes => $grouped_targets[new] })
}
