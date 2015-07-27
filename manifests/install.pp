# == Class influxdb::install
#
class influxdb::install (
) inherits influxdb {

  if $::influxdb::proxy_http {
    $exec_env = [
      "http_proxy=${::influxdb::proxy_http}",
      "https_proxy=${::influxdb::proxy_http}",
    ]
  }
  else
  {
    $exec_env = undef
  }

  ensure_packages('curl')

  # Until they release a proper repository we will need to do with that
  exec {'get_influxdb':
    environment => $exec_env,
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "curl -s ${::influxdb::package_source}${::influxdb::package_version}${::influxdb::package_suffix} -o ${::influxdb::package_dldir}/influxdb_${::influxdb::package_version}${::influxdb::package_suffix} && touch ${::influxdb::package_dldir}/.get_influxdb_${::influxdb::package_version}",
    creates     => "${::influxdb::package_dldir}/.get_influxdb_${::influxdb::package_version}",
    require     => Package['curl'],
  } ->
  package {'influxdb':
    ensure   => $::influxdb::package_ensure,
    provider => $::influxdb::package_provider,
    source   => "${::influxdb::package_dldir}/influxdb_${::influxdb::package_version}${::influxdb::package_suffix}",
  }

}
