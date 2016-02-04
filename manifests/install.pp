# == Class influxdb::install
#
class influxdb::install
{

  package {'influxdb':
    ensure   => $::influxdb::package_ensure,
  }

}
