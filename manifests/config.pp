# == Class influxdb::config
#
# This class is called from influxdb
#
class influxdb::config (
) {

  $main_section = merge($::influxdb::params::main, $::influxdb::main)
  $meta_section = merge($::influxdb::params::meta, $::influxdb::meta)
  $data_section = merge($::influxdb::params::data, $::influxdb::data)
  $cluster_section = merge($::influxdb::params::cluster, $::influxdb::cluster)
  $retention_section = merge($::influxdb::params::retention, $::influxdb::retention)
  $http_section = merge($::influxdb::params::http, $::influxdb::http)
  $admin_section = merge($::influxdb::params::admin, $::influxdb::admin)
  $hh_section = merge($::influxdb::params::hh, $::influxdb::hh)
  $continuous_queries_section = merge($::influxdb::params::continuous_queries, $::influxdb::continuous_queries)
  $monitor_section = merge($::influxdb::params::monitor, $::influxdb::monitor)
  $collectd_section = merge($::influxdb::params::collectd, $::influxdb::collectd)
  $opentsdb_section = merge($::influxdb::params::opentsdb, $::influxdb::opentsdb)
  $udp_section = merge($::influxdb::params::udp, $::influxdb::udp)
  $shard_precreation_section = merge($::influxdb::params::shard_precreation, $::influxdb::shard_precreation)

  if $::influxdb::graphite != {} {
    if $::influxdb::ignore_default_graphite {
      $graphites_section = $::influxdb::graphite
    }
    else {
      $graphites_section = merge($::influxdb::params::graphite,$::influxdb::graphite)
    }
  } else {
    $graphites_section = $::influxdb::params::graphite
  }

#  file { $::influxdb::storage_dir:
#    ensure => directory,
#    owner  => $::influxdb::influxdb_user,
#    group  => $::influxdb::influxdb_group,
#    mode   => '0750',
#  }

  $data_dir = $data_section['dir']
  $meta_dir = $meta_section['dir']
  $hh_dir   = $hh_section['dir']
  $wal_dir  = $data_section['wal-dir']

  file { $meta_dir:
    ensure => directory,
    owner  => $::influxdb::influxdb_user,
    group  => $::influxdb::influxdb_group,
    mode   => '0750',
  }

  file { $hh_dir:
    ensure => directory,
    owner  => $::influxdb::influxdb_user,
    group  => $::influxdb::influxdb_group,
    mode   => '0750',
  }

  file { $data_dir:
    ensure => directory,
    owner  => $::influxdb::influxdb_user,
    group  => $::influxdb::influxdb_group,
    mode   => '0750',
  }

  file { $wal_dir:
    ensure => directory,
    owner  => $::influxdb::influxdb_user,
    group  => $::influxdb::influxdb_group,
    mode   => '0750',
  }

  file { $::influxdb::config_file:
    ensure  => $::influxdb::package_ensure,
    owner   => $::influxdb::influxdb_user,
    group   => $::influxdb::influxdb_group,
    mode    => '0640',
    content => template($::influxdb::conf_template),
  }

}
