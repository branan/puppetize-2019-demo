plan demo::uninstall(
  TargetSpec $nodes
) {
  run_command("apt -y purge apache2", $nodes, "Purge any installed apaches")
  run_command("apt -y autoremove", $nodes, "Purge any installed apache dependencies")
}