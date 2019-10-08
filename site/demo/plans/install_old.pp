plan demo::install_old(
  TargetSpec $nodes
) {
  run_script("demo/install_old_apache.sh", $nodes)
}