# == Class influxdb::repo
#
# Configures InfluxDB repository
class influxdb::repo (
  $influxdb_flavour = 'stable',
) {
    case $::osfamily {

      'RedHat': {
        $rpm_url = $::operatingsystemrelease ? {
          /^5/    => "https://repos.influxdata.com/rhel/5/${::architecture}/${influxdb_flavour}",
          /^6/    => "https://repos.influxdata.com/rhel/6/${::architecture}/${influxdb_flavour}",
          /^7/    => "https://repos.influxdata.com/rhel/7/${::architecture}/${influxdb_flavour}",
          default => Fail['Operating system or release version not supported.'],
        }
        $rpm_gpgkey = 'https://repos.influxdata.com/influxdb.key'

        yumrepo { 'influxdb':
          descr    => 'InfluxDB Repository - RHEL',
          baseurl  => $rpm_url,
          gpgkey   => $rpm_gpgkey,
          enabled  => 1,
          gpgcheck => 1;
        }
      }
      'Debian': {
        include ::apt

        ensure_resource('package', 'apt-transport-https', {'ensure' => 'present' })

        apt::key { 'influxdb':
          key         => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
          key_content => template('influxdb/aptkey.erb'),
        }

        apt::source { 'influxdb':
          location    => 'https://repos.influxdata.com/debian',
          release     => $::lsbdistcodename,
          repos       => $influxdb_flavour,
          include_src => false,
          require     => Apt::Key['influxdb'],
        }
      }
      default: {
        fail('Operating system or release version not supported.')
      }
    }
}
