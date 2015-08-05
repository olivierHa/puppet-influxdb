# == Class influxdb::params
#
# This class is meant to be called from influxdb
# It sets variables according to platform
#
class influxdb::params {

  # Install options
  $proxy_http = undef
  $package_dldir = '/opt'
  $influxdb_user = 'influxdb'
  $influxdb_group = 'influxdb'
  $package_ensure = 'present'
  $package_version = '0.9.2'
  $service_name = 'influxdb'

  case $::osfamily {
    'Debian': {
      $package_provider = 'dpkg'
      $package_source   = 'http://s3.amazonaws.com/influxdb/influxdb_'
      $package_suffix = $::architecture ? {
          /64/    => '_amd64.deb',
          default => '_i386.deb',
      }
      if $::operatingsystem == 'Ubuntu' {
        $service_provider = 'upstart'
      } else {
        $service_provider = undef
      }
    }
    'RedHat', 'Amazon': {
      $package_provider = 'rpm'
      $package_source = 'http://s3.amazonaws.com/influxdb/influxdb-'
      $package_suffix = $::architecture ? {
          /64/    => '-1.x86_64.rpm',
          default => '-1.i686.rpm',
        }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  # Configuration options
  $storage_dir = '/var/opt/influxdb'
  $config_file = '/etc/opt/influxdb/influxdb.conf'
  $conf_template = 'influxdb/influxdb.conf.erb'

  $reporting_disabled = false

  $meta_influxdb_hostname = 'localhost'
  $meta_bind_address = ':8088'
  $meta_retention_autocreate = true
  $meta_election_timeout = '1s'
  $meta_heartbeat_timeout = '1s'
  $meta_leader_lease_timeout = '500ms'
  $meta_commit_timeout = '50ms'
  $meta_peers = []

  # Data Sections
  $data_max_wal_size = 104857600
  $data_wal_flush_interval = '10m'
  $data_wal_partition_flush_delay = '2s'

  # Cluster Section
  $cluster_shard_writer_timeout = '5s'
  $cluster_write_timeout = '5s'

  # Retention Section
  $retention_enabled = true
  $retention_check_interval = '10m'
  $retention_replication = 3

  # Http Section

  $http_enabled = true
  $http_bind_address = ':8086'
  $http_log_enabled = true
  $http_auth_enabled = false
  $http_write_tracing = false
  $http_pprof_enabled = false
  $http_https_enabled = false
  $http_https_certificate = '/etc/ssl/influxdb.pem'

  # Admin Section

  $admin_enabled = true
  $admin_bind_address = ':8083'
  $admin_https_enabled = false
  $admin_https_certificate = '/etc/ssl/influxdb.pem'

  # Graphite Section
  $graphite_enabled = false
  $graphite_bind_address = ':2003'
  $graphite_protocol = 'tcp'
  $graphite_consistency_level = 'one'
  $graphite_separator = '.'
  $graphite_batch_size = 0
  $graphite_batch_timeout = '0'
  $graphite_templates = []
  $graphite_database  = 'graphite'
  $graphite_tags  = []

  # Collectd Section
  $collectd_enabled = false
  $collectd_bind_address = ':25826'
  $collectd_database = 'collectd'
  $collectd_typesdb = '/usr/share/collectd/types.db'
  $collectd_batch_size = 5000
  $collectd_batch_timeout = '10s'
  $collectd_retention_policy = ''

  # Opentsdb section
  $opentsdb_enabled = false
  $opentsdb_bind_address = ':4242'
  $opentsdb_database = 'opentsdb'
  $opentsdb_retention_policy = ''
  $opentsdb_consistency_level = 'one'
  

  # hinted-handoff Section
  $hh_enabled = true
  $hh_max_size = 1073741824
  $hh_max_age = '168h0m0s'
  $hh_retry_rate_limit = 0
  $hh_retry_interval= '1s'

  # continuous_queries Section
  $cqueries_enabled = true
  $cqueries_recompute_previous_n = 2
  $cqueries_recompute_no_older_than = '10m0s'
  $cqueries_compute_runs_per_interval = 10
  $cqueries_compute_no_more_than = '2m0s'

  # monitoring section
  $monitoring_enabled = true
  $monitoring_write_interval = '1m0s'
  
  # Shard precreation Section
  $shard_precreation_enabled = true
  $shard_precreation_check_interval = '10m0s'
  $shard_precreation_advance_period = '30m0s'

}
