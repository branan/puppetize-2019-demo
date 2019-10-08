plan update::apache_on_mktg_web(
  String $version
) {
  $query = [from, nodes, ['=', [fact, cluster], "mktg_web"]]
  $selected_nodes = puppetdb_query($query).map() |$target| {
    $target[certname]
  }

  $update_args = {targets => $selected_nodes, package => "apache2", version => $version }
  return run_plan("update::package", $update_args)
}
