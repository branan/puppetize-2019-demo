# Updates a package to the selected version, providing some reporting
# on the process
# * Which nodes were out of date, and how out of date they were
# * Which nodes were already up to date
# * Which nodes did not actually have the requested package installed
# * Any errors that occured, and on which nodes they occured
#
# Parameters:
# targets - the set of nodes to update the package on
# package - the package to update
# version - the version to update the selected package to
plan update::package(
  TargetSpec $targets,
  String $package,
  String $version,
) {
  # Query the status of the requested package on each target  
  $query_options = { action => status, name => $package, '_catch_errors' => true }
  $query_results = run_task(package, $targets, "Query package ${package}", $query_options)

  # Filter out any nodes that failed for later reporting, and group
  # targets into buckets based on whether they need the update to be
  # applied
  $failed_queries = aggregate::nodes($query_results.error_set())
  $sorted_targets = $query_results.ok_set().to_data.reduce( { correct => [], outdated => [], uninstalled => [] } ) |$sorted, $result| {
    $sorted + ( $result[result][status]? {
      uninstalled => { uninstalled => $sorted[uninstalled] << $result[target] },
      default => $result[result][version]? {
        $version => { correct => $sorted[correct] << $result[target] },
        default => { outdated => $sorted[outdated] << $result[target] },
      }
    })
  }

  # Perform the update
  $upgrade_options = { action => upgrade, version => $version, name => $package, '_catch_errors' => true }
  $upgrade_result = run_task(package, $sorted_targets[outdated], "Update package ${package}", $upgrade_options)
  $failed_upgrades = aggregate::nodes($upgrade_result.error_set())
  $successful_upgrades = aggregate::nodes($upgrade_result.ok_set())

  return ({
    package => $package,
    version => $version,
    correct => $sorted_targets[correct],
    uninstalled => $sorted_targets[uninstalled],
    query_failures => $failed_queries,
    couldnt_fix => $failed_upgrades,
    succeeded => { from => $successful_upgrades[old_version] },
  })
}
