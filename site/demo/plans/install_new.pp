plan demo::install_new(
  TargetSpec $nodes
) {
  run_script("demo/install_new_apache.sh", $nodes)
}