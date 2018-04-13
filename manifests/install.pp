# == Class influxdb::install
#
class influxdb::install {
  case $facts['osfamily'] {
    'Debian': {
      $packages = $::influxdb::manage_repo ? {
        true    => [ 'influxdb' ],
        default => [ 'influxdb', 'influxdb-client' ],
      }
    }
    default: {
      $packages = [ 'influxdb' ]
    }
  }

  if $::influxdb::manage_repo {
	ensure_packages($packages, {
	  ensure    => $::influxdb::package_ensure,
	  require   => Class['::influxdb::repo'],
	})
  } else {
    ensure_packages($packages, {ensure => $::influxdb::package_ensure})
  }
}
