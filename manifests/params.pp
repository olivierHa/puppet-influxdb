# == Class influxdb::params
#
# This class is meant to be called from influxdb
# It sets variables according to platform
#
class influxdb::params {

  $manage_repo   = true
  $influxdb_user = 'influxdb'
  $influxdb_group = 'influxdb'
  $package_ensure = 'present'

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
        if $::lsbdistcodename == 'jessie' {
          $service_provider = undef
        } else {
          $service_provider = undef
        }
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
  $config_file = '/etc/influxdb/influxdb.conf'
  $conf_template = 'influxdb/influxdb.conf.erb'

  $ignore_default_graphite = false
  
  # Main Section
  $main = {
    reporting-disabled => false,
  }

  # Meta Section
  $meta = {
    dir => '/var/lib/influxdb/meta',
    hostname => 'localhost',
    bind-address => ':8088',
    retention-autocreate => true,
    election-timeout => '1s',
    heartbeat-timeout => '1s',
    leader-lease-timeout => '500ms',
    commit-timeout => '50ms',
    cluster-tracing => false,
    raft-promotion-enabled => true,
    logging-enabled => true,
  }

  # Data Sections
  $data = {
    dir => '/var/lib/influxdb/data',
    engine => 'tsm1',
    max-wal-size => 104857600,
    wal-flush-interval => '10m0s',
    wal-partition-flush-delay => '2s',
    wal-dir => '/var/lib/influxdb/wal',
    wal-logging-enabled => true,
    trace-logging-enabled => true,
    wal-compaction-threshold => 0.5,
    wal-max-series-size => 1048576,
    wal-flush-cold-interval => '5s',
    wal-partition-size-threshold => 52428800,
    query-log-enabled => true,
    cache-max-memory-size => 524288000,
    cache-snapshot-memory-size => 26214400,
    cache-snapshot-write-cold-duration => '1h0m0s',
    compact-full-write-cold-duration => '24h0m0s',
    max-points-per-block => 0,
  }

  # Cluster Section
  $cluster = {
    force-remote-mapping => false,
    write-timeout => '5s',
    shard-writer-timeout => '5s',
    shard-mapper-timeout => '5s',
  }

  # Retention Section
  $retention = {
    enabled => true,
    check-interval => '30m0s',
  }

  # Shard precreation Section
  $shard_precreation = {
        enabled => true,
        check-interval => '10m0s',
        advance-period => '30m0s',
  }

  # Admin Section
  $admin = {
        enabled => true,
        bind-address => ':8083',
        https-enabled => false,
        https-certificate => '/etc/ssl/influxdb.pem',
  }

  # Monitor Section
  $monitor = {
    store-enabled => true,
    store-database => '_internal',
    store-interval => '10s',
  }

  # Http Section
  $http = {
        enabled => true,
        bind-address => ':8086',
        auth-enabled => false,
        log-enabled => true,
        write-tracing => false,
        pprof-enabled => false,
        https-enabled => false,
        https-certificate => '/etc/ssl/influxdb.pem',
  }

  # Graphite Section
  $graphite = {
      main => {
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
      },
  }

  # Collectd Section
  $collectd = {
        enabled => false,
        bind-address => ':25826',
        database => 'collectd',
        typesdb => '/usr/share/collectd/types.db',
        batch-size => 5000,
        batch-pending => 10,
        batch-timeout => '10s',
        retention-policy => '',
        read-buffer => 0,
  }

  # Opentsdb section
  $opentsdb = {
        enabled => false,
        bind-address => ':4242',
        database => 'opentsdb',
        retention-policy => '',
        consistency-level => 'one',
        tls-enabled => false,
        log-point-errors => true,
        batch-size => '1000',
        batch-pending => 5,
        batch-timeout => '1s',
  }

  # hinted-handoff Section
  $hh = {
        dir => '/var/lib/influxdb/hh',
        enabled => true,
        max-size => 1073741824,
        max-age => '168h0m0s',
        retry-rate-limit => 0,
        retry-interval => '1s',
  }

  # continuous_queries Section
  $continuous_queries = {
        enabled => true,
        log-enabled => true,
        run-interval => '1s',
        recompute-previous-n => 2,
        recompute-no-older-than => '10m0s',
        compute-runs-per-interval => 10,
        compute-no-more-than => '2m0s',
  }

  # udp section
  $udp = {
    enabled => false,
  }

  # snapshot section
  $snapshot = {
    enabled => false,
  }

  # subscriber section
  $subscriber = {
    enabled => true,
  }

}

