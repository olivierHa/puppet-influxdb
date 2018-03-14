# == Class influxdb::service
#
# Manages the InfluxDB daemon
#
# Parameters:
#
# Actions:
#   - Manage Influxdb service
class influxdb::service {
  if $influxdb::service_manage {
    service { 'influxdb':
      ensure     => $influxdb::service_ensure,
      name       => $influxdb::service_name,
      enable     => $influxdb::service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
