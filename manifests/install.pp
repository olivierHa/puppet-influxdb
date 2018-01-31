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

  package { $packages :
    ensure   => $::influxdb::package_ensure,
  }
}
