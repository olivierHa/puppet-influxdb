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
  String $package_ensure                      = 'present',
  Boolean $manage_repo                        = true,
  String $config_file                         = '/etc/influxdb/influxdb.conf',
  String $influxdb_user                       = 'influxdb',
  String $influxdb_group                      = 'influxdb',
  String $conf_template                       = 'influxdb/influxdb.conf.erb',
  Boolean $ignore_default_graphite            = false,
  # Service management
  String $service_name                        = 'influxdb',
  Boolean $service_enable                     = true,
  Enum['stopped', 'running'] $service_ensure  = 'running',
  Boolean $service_manage                     = true,
  # Custom configuration parameters
  Hash $main                                  = {},
  Hash $meta                                  = {},
  Hash $data                                  = {},
  Hash $cluster                               = {},
  Hash $retention                             = {},
  Hash $http                                  = {},
  Hash $admin                                 = {},
  Hash $graphite                              = {},
  Hash $hh                                    = {},
  Hash $continuous_queries                    = {},
  Hash $monitor                               = {},
  Hash $collectd                              = {},
  Hash $opentsdb                              = {},
  Hash $udp                                   = {},
  Hash $shard_precreation                     = {},
  Hash $snapshot                              = {},
  Hash $subscriber                            = {},
  Hash $databases                             = {},
  Hash $retention_policies                    = {},
) inherits ::influxdb::params {

  if $manage_repo {
    class { '::influxdb::repo': }
  }
  class { '::influxdb::install': } ->
  class { '::influxdb::config': } ~>
  class { '::influxdb::service': } ->
  Class['::influxdb']

  create_resources(influxdb_database, $databases)
  create_resources(influxdb_retention_policy, $retention_policies)
}
