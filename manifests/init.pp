# == Class: influxdb
#
# Install and manage Influxdb 0.9.x
#
# === Parameters
#
# [*package_version*] - Specify influxdb version
#                      Defaults to "0.9.4"
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
#                      Defaults to "/etc/opt/influxdb/influxdb.conf"
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
#    package_version  => '0.9.4',
#    graphite_enabled => true,
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

  # Configuration Parameters
  $main                   = $influxdb::params::main,

  # Meta Section
  $meta                   = $influxdb::params::meta,

  # Data Section
  $data                   = $influxdb::params::data,

  # Cluster Section
  $cluster                = $influxdb::params::cluster,

  # Retention Section
  $retention              = $influxdb::params::retention,

  # Http Section
  $http                   = $influxdb::params::http,

  # Admin Section
  $admin                  = $influxdb::params::admin,

  # Graphite Sections
  $graphite_sections,
  
  # hinted-handoff Section
  $hh                     = $influxdb::params::hh,

  # continuous_queries Section
  $cqueries               = $influxdb::params::cqueries,

  # Monitoring Section
  $monitoring             = $influxdb::params::monitoring,

  # collectd
  $collectd               = $influxdb::params::collectd,

  # Opentsdb section
  $opentsdb               = $influxdb::params::opentsdb,

  # UDP Section
  $udp                  = $influxdb::params::udp,

  # Shard Precreation
  $shard_pc                  = $influxdb::params::shard_pc

) inherits ::influxdb::params {

  # validate parameters here
  $main_section = merge($main, $::influxdb::params::main)
  $meta_section = merge($meta, $::influxdb::params::meta)
  $data_section = merge($data, $::influxdb::params::data)
  $cluster_section = merge($cluster, $::influxdb::params::cluster)
  $retention_section = merge($retention, $::influxdb::params::retention)
  $http_section = merge($http, $::influxdb::params::http)
  $admin_section = merge($admin, $::influxdb::params::admin)
  $hh_section = merge($hh, $::influxdb::params::hh)
  $cqueries_section = merge($cqueries, $::influxdb::params::cqueries)
  $collectd_section = merge($collectd, $::influxdb::params::collectd)
  $opentsdb_section = merge($opentsdb, $::influxdb::params::opentsdb)
  $udp_section = merge($udp, $::influxdb::params::udp)
  $shard_pc_section = merge($shard_pc, $::influxdb::params::shard_pc)

  class { '::influxdb::install': } ->
  class { '::influxdb::config': } ~>
  class { '::influxdb::service': } ->
  Class['::influxdb']
}
