# == Class: influxdb
#
# Install and manage Influxdb 0.9.x
#
# === Parameters
#
# [*package_version*] - Specify influxdb version
#                      Defaults to "0.9.2"
# ['max_wal_size']   - Maximum size the WAL can reach before a flush.
#                      Defaults to "100MB"
# ['wal_flush_interval']  - Maximum time data can sit in WAL before a flush.
#                      Defaults to "10m"
# ['wal_partition_flush-delay'] - The delay time between each WAL partition being flushed.
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
#                         Defaults to "graphite"
# ['graphite_batch_size'] - Graphite batch size
#                           Defaults to 0
# ['graphite_batch_timeout'] - Graphite batch timeout
#                              Defaults to "10s"
# ['graphite_consistency_level'] - Default write consistency for the Graphite input 
#                                  Defaults to "one"
# ['graphite_separator'] - If matching multiple measurement files, this string will be used to join the matched values.
#                          Defaults to .
# ['graphite_tags'] - Graphite tags
#                     Defaults to []
# ['graphite_templates'] - Graphite templates 
#                          Defaults to []
# ['collectd_enabled'] - Use collectd plugin
#                        Defaults to false
# ['hh_max_size'] - Default maximum size of all hinted handoff queues in bytes
#                   Defaults to 1024 * 1024 * 1024
# ['hh_max_age'] - Default maximum amount of time that a hinted handoff write can stay in the queue.  After this time, the write will be purged
#                  Defaults to 7 * 24 h
# ['hh_retry_rate_limit'] - Default rate that hinted handoffs will be retried. The rate is in bytes per second and applies across all nodes when retried. 
#                           A value of 0 disables the rate limit
#                           Defaults to 0
# ['hh_retry_interval'] - Default amout of time the system waits before attempting to flush hinted handoff queues
#                         Defaults to 1s
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
  $main_section                   = $influxdb::params::main_section,

  # Meta Section
  $meta_section                   = $influxdb::params::meta_section,

  # Data Section
  $data_section                   = $influxdb::params::data_section,

  # Cluster Section
  $cluster_section                = $influxdb::params::cluster_section,

  # Retention Section
  $retention_section              = $influxdb::params::retention_section,

  # Http Section
  $http_section                   = $influxdb::params::http_section,

  # Admin Section
  $admin_section                  = $influxdb::params::admin_section,

  # Graphite Sections
  $graphite_sections,
  
  # hinted-handoff Section
  $hh_section                     = $influxdb::params::hh_section,

  # continuous_queries Section
  $cqueries_section               = $influxdb::params::cqueries_section,

  # Monitoring Section
  $monitoring_section             = $influxdb::params::monitoring_section,

  # collectd
  $collectd_section               = $influxdb::params::collectd_section,

  # Opentsdb section
  $opentsdb_section               = $influxdb::params::opentsdb_section,

  # UDP Section
  $udp_section                  = $influxdb::params::udp_section,

  # Shard Precreation
  $shard_pc_section                  = $influxdb::params::shard_pc_section

) inherits ::influxdb::params {

  # validate parameters here

  class { '::influxdb::install': } ->
  class { '::influxdb::config': } ~>
  class { '::influxdb::service': } ->
  Class['::influxdb']
}
