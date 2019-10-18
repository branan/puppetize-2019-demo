# This plan wraps our `update::package` plan providing a set of simple
# defaults for the other team to update their apache nodes
#
# Parameters:
# version - The version to update apache to
plan update::apache_on_other_cluster(
  String $version,
) {
  # Use puppetdb to find the nodes from the other team's web cluster
  $query = [from, nodes, ['=', [fact, cluster], "other_team"]]
  $selected_nodes = puppetdb_query($query).map() |$target| {
    $target[certname]
  }

  # Update the `apache2 package on the nodes discovered above
  $update_args = {targets => $selected_nodes, package => "apache2", version => $version }
  return run_plan("update::package", $update_args)
}
