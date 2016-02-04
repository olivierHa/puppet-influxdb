# == Class: influxdb
#
# Install and manage Influxdb 0.10.x
#
# === Parameters
#
# [*package_ensure*] - Choose whether to install or uninstall
#                      Defaults to present
#
# [*config_file*] - Full path to config file (e.g. /etc/influxdb/influxdb.conf)
#                    NOTE: This does not create directories.
#                      Defaults to "/etc/influxdb/influxdb.conf"
#
# [*influxdb_user*] - Ownership of influxdb directories. (Don't set user that will run influxdb ... yet)
#                      Defaults to "influxdb"
#
# [*influxdb_group*] - Group of influxdb directories
#                      Defaults to "influxdb"
#
# [*conf_template*] - Specify template to use for influxdb conf file
#                      Defaults to "influxdb.conf.erb"
#
# [*$section*] - Each section of the config file is a hash.  Defaults most easily surmised from params.pp
#                      e.g.
#                         $data = {
#                             max-wal-size => 104857600,
#                             wal-flush-interval => '10m',
#                             wal-partition-flush-delay => '2s',
#                          }
#                       This data may also be pulled in from hiera
#
# === Examples
#
#  class { influxdb:
#    package_version  => '0.10.0',
#  }
#
# === Authors
#
# Olivier Hanesse <olivier.hanesse@gmail.com>
# Ashton Davis <acidrainfall@gmail.com>
#
# === Copyright
#
# Copyright 2015 Olivier Hanesse
#
class influxdb (
  # Installation parameters
  $package_ensure                 = $influxdb::params::package_ensure,
  $manage_repo                    = $influxdb::params::manage_repo,
  $config_file                    = $influxdb::params::config_file,
  $influxdb_user                  = $influxdb::params::influxdb_user,
  $influxdb_group                 = $influxdb::params::influxdb_group,
  $conf_template                  = $influxdb::params::conf_template,
  $ignore_default_graphite        = $influxdb::params::ignore_default_graphite,
  # Custom configuration parameters
  $main                   = {},
  $meta                   = {},
  $data                   = {},
  $cluster                = {},
  $retention              = {},
  $http                   = {},
  $admin                  = {},
  $graphite               = {},
  $hh                     = {},
  $continuous_queries     = {},
  $monitor                = {},
  $collectd               = {},
  $opentsdb               = {},
  $udp                    = {},
  $shard_precreation      = {},
  $snapshot               = {},
  $subscriber             = {},
) inherits ::influxdb::params {

  # validate parameters
  validate_hash($main)
  validate_hash($meta)
  validate_hash($data)
  validate_hash($cluster)
  validate_hash($retention)
  validate_hash($http)
  validate_hash($admin)
  validate_hash($graphite)
  validate_hash($hh)
  validate_hash($continuous_queries)
  validate_hash($monitor)
  validate_hash($collectd)
  validate_hash($opentsdb)
  validate_hash($udp)
  validate_hash($shard_precreation)
  validate_hash($snapshot)

  if $manage_repo {
    class { '::influxdb::repo': }
  }
  class { '::influxdb::install': } ->
  class { '::influxdb::config': } ~>
  class { '::influxdb::service': } ->
  Class['::influxdb']
}
