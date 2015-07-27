# == Class influxdb::service
#
# This class is meant to be called from influxdb
# It ensure the service is running
#
class influxdb::service {

  service { $influxdb::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
