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
# [*$_section*] - Each section of the config file is a hash.  Defaults most easily surmised from params.pp
#                      e.g.
#                         $data_section = {
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
