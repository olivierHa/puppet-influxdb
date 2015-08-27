# == Class influxdb::config
#
# This class is called from influxdb
#
class influxdb::config (
  $data_dir = "${influxdb::storage_dir}/data",
  $meta_dir = "${influxdb::storage_dir}/meta",
  $hh_dir   = "${influxdb::storage_dir}/hh",
  $wal_dir  = "${influxdb::storage_dir}/wal",
) {

  file { $::influxdb::storage_dir:
    ensure => directory,
    owner  => $::influxdb::influxdb_user,
    group  => $::influxdb::influxdb_group,
    mode   => '0750',
  }

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
    mode    => '0644',
    content => template($::influxdb::conf_template),
  }

}
