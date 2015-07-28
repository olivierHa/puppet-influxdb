# == Class: influxdb
#
# Install and manage Influxdb 0.9.x
#
# === Parameters
#
# [*package_version*] - Specify influxdb version
#                      Defaults to "0.9.2"
# ['max-wal-size']   - Maximum size the WAL can reach before a flush.
#                      Defaults to "100MB"
# ['wal-flush-interval']  - Maximum time data can sit in WAL before a flush.
#                      Defaults to "10m"
# ['wal-partition-flush-delay'] - The delay time between each WAL partition being flushed.
#                      Defaults to "2s"
# ['cluster_shard_writer_timeout'] - The time within which a shard must respond to write.
#                      Defaults to "5s"
# ['cluster_write_timeout'] - The time within which a write operation must complete on the cluster.
#                      Defaults to "5s"
# ['graphite_enabled'] - Use graphite plugin
#                     Defaults to false
# ['graphite_bind_address'] - Bind address for graphite plugin
#                     Defaults to "::2003"
# ['graphite_protocol'] - Graphite Protocol
#                     Defaults to "tcp"
# ['graphite_database'] - Graphite Database
#                     Defaults to "graphite"
# ['graphite_batch_size'] - Graphite batch size
#                     Defaults to 0
# ['graphite_batch_timeout'] - Graphite batch timeout
#                     Defaults to "10s"
# ['graphite_consistency_level'] - Default write consistency for the Graphite input 
#                     Defaults to "one"
# ['graphite_separator'] - If matching multiple measurement files, this string will be used to join the matched values.
#                      Defaults to .
# ['graphite_tags'] - Graphite tags
#                      Defaults to []
# ['graphite_templates'] - Graphite templates 
#                      Defaults to []
# ['collectd_enabled'] - Use collectd plugin
#                     Defaults to false
#
# === Examples
#
#  class { influxdb:
#    package_version  => '0.9.2',
#    graphite_enabled => true,
#  }
#
# === Authors
#
# Olivier Hanesse <olivier.hanesse@gmail.com>
#
# === Copyright
#
# Copyright 2015 Olivier Hanesse
#
class influxdb (
  # Installation parameters
  $package_name                   = $influxdb::params::package_name,
  $package_ensure                 = $influxdb::params::package_ensure,
  $package_source                 = $influxdb::params::package_source,
  $package_suffix                 = $influxdb::params::package_suffix,
  $package_version                = $influxdb::params::package_version,
  $package_dldir                  = $influxdb::params::package_dldir,
  $service_name                   = $influxdb::params::service_name,
  $proxy_http                     = $influxdb::params::proxy_http,
  $config_file                    = $influxdb::params::config_file,
  $influxdb_user                  = $influxdb::params::influxdb_user,
  $influxdb_group                 = $influxdb::params::influxdb_group,
  $conf_template                  = $influxdb::params::conf_template,

  # Configuration Parameters
  $reporting_disabled             = $influxdb::params::reporting_disabled,
  $storage_dir                    = $influxdb::params::storage_dir,

  # Meta Section
  $meta_influxdb_hostname         = $influxdb::params::meta_influxdb_hostname,
  $meta_bind_address              = $influxdb::params::meta_bind_address,
  $meta_retention_autocreate      = $influxdb::params::meta_retention_autocreate,
  $meta_election_timeout          = $influxdb::params::meta_election_timeout,
  $meta_heartbeat_timeout         = $influxdb::params::meta_heartbeat_timeout,
  $meta_leader_lease_timeout      = $influxdb::params::meta_leader_lease_timeout,
  $meta_commit_timeout            = $influxdb::params::meta_commit_timeout,

  # Data Section
  $data_max_wal_size              = $influxdb::params::data_max_wal_size,
  $data_wal_flush_interval        = $influxdb::params::data_wal_flush_interval,
  $data_wal_partition_flush_delay = $influxdb::params::data_wal_partition_flush_delay,

  # Cluster Section
  $cluster_shard_writer_timeout   = $influxdb::params::cluster_shard_writer_timeout,
  $cluster_write_timeout          = $influxdb::params::cluster_write_timeout,

  # Retention Section
  $retention_enabled              = $influxdb::params::retention_enabled,
  $retention_check_interval       = $influxdb::params::retention_check_interval,

  # Graphite Section
  $graphite_enabled               = $influxdb::params::graphite_enabled,
  $graphite_bind_address          = $influxdb::params::graphite_bind_address,
  $graphite_protocol              = $influxdb::params::graphite_protocol,
  $graphite_consistency_level     = $influxdb::params::graphite_consistency_level,
  $graphite_separator             = $influxdb::params::graphite_separator,
  $graphite_batch_size            = $influxdb::params::graphite_batch_size,
  $graphite_batch_timeout         = $influxdb::params::graphite_batch_timeout,
  $graphite_templates             = $influxdb::params::graphite_templates,
  $graphite_database              = $influxdb::params::graphite_database,
  $graphite_tags                  = $influxdb::params::graphite_tags,

  # hinted-handoff Section
  $hh_enabled                     = $influxdb::params::hh_enabled,
  $hh_max_size                    = $influxdb::params::hh_max_size,
  $hh_max_age                     = $influxdb::params::hh_max_age,
  $hh_retry_rate_limit            = $influxdb::params::hh_retry_rate_limit,
  $hh_retry_interval              = $influxdb::params::hh_retry_interval,

  # continuous_queries Section
  $cqueries_enabled                   = $influxdb::params::cqueries_enabled,
  $cqueries_recompute_previous_n      = $influxdb::params::cqueries_recompute_previous_n,
  $cqueries_recompute_no_older_than   = $influxdb::params::cqueries_recompute_no_older_than,
  $cqueries_compute_runs_per_interval = $influxdb::params::cqueries_compute_runs_per_interval, 
  $cqueries_compute_no_more_than      = $influxdb::params::cqueries_compute_no_more_than,

  # Monitoring Section
  $monitoring_enabled                 = $influxdb::params::monitoring_enabled,
  $monitoring_write_interval          = $influxdb::params::monitoring_write_interval,

  # collectd
  $collectd_enabled                   = $influxdb::params::collectd_enabled,
  $collectd_bind_address              = $influxdb::params::collectd_bind_address,
  $collectd_database                  = $influxdb::params::collectd_database,
  $collectd_typesdb                   = $influxdb::params::collectd_typesdb,



) inherits ::influxdb::params {

  # validate parameters here

  class { '::influxdb::install': } ->
  class { '::influxdb::config': } ~>
  class { '::influxdb::service': } ->
  Class['::influxdb']
}
