# == Class influxdb::service
#
# Manages the InfluxDB daemon
#
# Parameters:
#
# Actions:
#   - Manage Influxdb service
class influxdb::service (
  $service_name    = 'influxdb',
  $service_enable  = true,
  $service_ensure  = 'running',
  $service_manage  = true,
) {

  validate_bool($service_enable)
  validate_bool($service_manage)

  case $service_ensure {
    true, false, 'running', 'stopped': {
      $_service_ensure = $service_ensure
    }
    default: {
      $_service_ensure = undef
    }
  }

  if $service_manage {
    service { 'influxdb':
      ensure     => $_service_ensure,
      name       => $service_name,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
