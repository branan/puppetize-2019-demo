plan update::package(
  TargetSpec $targets,
  String $package,
  String $version
) {
  $query_options = { action => status, name => $package, '_catch_errors' => true }
  $query_results = run_task(package, $targets, "Query package ${package}", $query_options)
  
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
