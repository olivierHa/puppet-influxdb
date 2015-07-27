# == Class influxdb::params
#
# This class is meant to be called from influxdb
# It sets variables according to platform
#
class influxdb::params {

  # Install options
  $proxy_host = undef
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
      $config_file      = '/etc/opt/influxdb/influxdb.conf'
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
  $storage_dir = '/var/opt/influxdb/'
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

  # Graphite Section
  $graphite_enabled = false
  $graphite_bind_address = ':2003'
  $graphite_protocol = 'tcp'
  $graphite_consistency_level = 'one'
  $graphite_separator = '.'
  $graphite_batch_size = 0
  $graphite_batch_timeout = '10s'
  $graphite_templates = []
  $graphite_database  = 'graphite'
  $graphite_tags  = []

}
