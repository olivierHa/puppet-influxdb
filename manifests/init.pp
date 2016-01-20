# == Class: influxdb
#
# Install and manage Influxdb 0.10.x
#
# === Parameters
#
# [*package_version*] - Specify influxdb version
#                      Defaults to "0.10.0"
#
# [*package_source*] - Specify package source prefix
#                      Defaults to "http://s3.amazonaws.com/influxdb/influxdb_"
#
# [*package_suffix*] - Specify package source suffix
#                      Defaults to _$arch.$package_provider (e.g. -1.x86_64.rpm or _amd64.deb)
#
# [*package_ensure*] - Choose whether to install or uninstall
#                      Defaults to present
#
# [*package_dldir*] - Choose where the package is downloaded
#                      Defaults to "/opt"
#
# [*service_name*] - Specify service name 
#                      Defaults to "influxdb"
#
# [*proxy_http*] - Specify http proxy for package download
#                      Defaults to undef
#
# [*config_file*] - Full path to config file (e.g. /etc/influxdb/influxdb.conf)
#                    NOTE: This does not create directories.
#                      Defaults to "/etc/influxdb/influxdb.conf"
#
# [*influxdb_user*] - User influxdb will run as (will also create user)
#                      Defaults to "influxdb"
#
# [*influxdb_group*] - Group influxdb will run as (will also create user)
#                      Defaults to "influxdb"
#
# [*influxdb_group*] - Specify http proxy for package download
#                      Defaults to undef
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
#    package_version  => '0.9.6.1',
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
  $ignore_default_graphite        = $influxdb::params::ignore_default_graphite,
  # Configuration Parameters
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

  class { '::influxdb::install': } ->
  class { '::influxdb::config': } ~>
  class { '::influxdb::service': } ->
  Class['::influxdb']
}
