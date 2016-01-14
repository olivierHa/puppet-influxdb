# == Class influxdb::params
#
# This class is meant to be called from influxdb
# It sets variables according to platform
#
class influxdb::params {

  # Install options
  $proxy_http = undef
  $package_dldir = '/opt'
  $influxdb_user = 'influxdb'
  $influxdb_group = 'influxdb'
  $package_ensure = 'present'
  $package_version = '0.9.4'
  $service_name = 'influxdb'

  case $::osfamily {
    'Debian': {
      $package_provider = 'dpkg'
      $package_source   = 'http://s3.amazonaws.com/influxdb/influxdb_'
      $package_suffix = $::architecture ? {
          /64/    => '_amd64.deb',
          default => '_i386.deb',
      }
      if $::operatingsystem == 'Ubuntu' {
        $service_provider = 'upstart'
      } else {
        $service_provider = undef
      }
    }
    'RedHat', 'Amazon': {
      $package_provider = 'rpm'
      $package_source = 'http://s3.amazonaws.com/influxdb/influxdb-'
      $package_suffix = $::architecture ? {
          /64/    => '-1.x86_64.rpm',
          default => '-1.i686.rpm',
        }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  # Configuration options
  $storage_dir = '/var/opt/influxdb'
  $config_file = '/etc/opt/influxdb/influxdb.conf'
  $conf_template = 'influxdb/influxdb.conf.erb'

  $reporting_disabled = false

  $meta = {
    dir => "/var/opt/influxdb/meta",
    hostname => 'localhost',
    bind-address => ':8088',
    retention-autocreate => true,
    election-timeout => '1s',
    heartbeat-timeout => '1s',
    leader-lease-timeout => '500ms',
    commit-timeout => '50ms'
  }

  # Data Sections
  $data = {
    dir => "/var/opt/influxdb/data",
    wal-dir => "/var/opt/influxdb/wal",
    max-wal-size => 104857600,
    wal-flush-interval => '10m',
    wal-partition-flush-delay => '2s',
   }

  # Cluster Section
  $cluster = {
    shard-writer-timeout => '5s',
    write-timeout => '5s',
  }

  # Retention Section
  $retention = {
    enabled => true,
    check-interval => '10m',
    replication => 3,
  }

  # Http Section
  $http = {
        enabled => true,
        bind-address => ':8086',
        log-enabled => true,
        auth-enabled => false,
        write-tracing => false,
        pprof-enabled => false,
        https-enabled => false,
        https-certificate => '/etc/ssl/influxdb.pem',
  }

  # Admin Section
  $admin = {
        enabled => true,
        bind-address => ':8083',
        https-enabled => false,
        https-certificate => '/etc/ssl/influxdb.pem',
  }
  # Graphite Section
  $graphites = {
        enabled => false,
        bind-address => ':2003',
        protocol => 'tcp',
        consistency-level => 'one',
        separator => '.',
        batch-size => 1000,
        batch-timeout => '1s',
        templates => [],
        database  => 'graphite',
        tags  => [],
  }

  # Collectd Section
  $collectd = {
        enabled => false,
        bind-address => ':25826',
        database => 'collectd',
        typesdb => '/usr/share/collectd/types.db',
        batch-size => 5000,
        batch-timeout => '10s',
        retention-policy => '',
  }
  # Opentsdb section
  $opentsdb = {
        enabled => false,
        bind-address => ':4242',
        database => 'opentsdb',
        retention-policy => '',
        consistency-level => 'one',
  }

  # hinted-handoff Section
  $hh = {
        dir => "/var/opt/influxdb/hh",
        enabled => true,
        max-size => 1073741824,
        max-age => '168h0m0s',
        retry-rate-limit => 0,
   retry-interval => '1s'
  }
  # continuous_queries Section
  $cqueries = {
        enabled => true,
        recompute-previous-n => 2,
        recompute-no-older-than => '10m0s',
        compute-runs-per-interval => 10,
        compute-no-more-than => '2m0s',
  }
  # monitoring section
  $monitoring = {
    enabled => true,
    write-interval => '1m0s',
  }

  # udp section
  $udp = {
    enabled => false,
  }

  # Shard precreation Section
  $shard_pc = {
        precreation-enabled => true,
        precreation-check-interval => '10m0s',
        precreation-advance-period => '30m0s',
  }
}

