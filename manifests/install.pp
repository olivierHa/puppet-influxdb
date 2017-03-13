# == Class influxdb::install
#
class influxdb::install
{
	$packages = [
		'influxdb',
		'influxdb-client'
	]

  package { $packages :
    ensure   => $::influxdb::package_ensure,
  }

}
