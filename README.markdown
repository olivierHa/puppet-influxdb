[![Build Status](https://travis-ci.org/olivierHa/puppet-influxdb.svg)](https://travis-ci.org/olivierHa/puppet-influxdb)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with influxdb](#setup)
    * [What influxdb affects](#what-influxdb-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with influxdb](#beginning-with-influxdb)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The influxdb module lets you use Puppet to install, configure, and manage Influxdb, version > 0.9.x.
The current InfluxDB version is 0.9.2

##Module Description

InfluxDB is a Open source distributed time series, events, and metrics database. 
This module handles the installation (currently via downloading the package from influxdb website) and every configuration parameters.

Support for Puppet 3.x and Puppet 4.x

##Setup

###Beginning with influxdb

To install InfluxDB with the default parameters

~~~puppet
  class { 'influxdb': }
~~~

If your server can't connect directly to Internet, let's use a proxy :

~~~puppet
  class { 'influxdb': 
    proxy_http => 'http://squid:3128',
  }
~~~

###What influxdb affects

* influxdb package.
* influxdb configuration file.
* influxdb service.

##Usage

To enable Graphite plugin

~~~puppet
  class { 'influxdb': 
    graphite_enable => true,
  }
~~~

####A more complex example

~~~puppet
  class { 'influxdb': 
    graphite_enabled       => true,
    graphite_database      => 'mygraphitedb',
    graphite_batch_size    => 500,
    graphite_batch_timeout => "1s",
    graphite_tags          => ['region=us-east', 'zone=1c'],
    graphite_templates     => [
     "servers.* .host.measurement*",
     "stats.* .host.measurement* region=us-west,agent=sensu",
     ]
  }
~~~

To enable Collectd plugin:

~~~puppet
  class { 'influxdb': 
    collectd_enable => true,
  }
~~~

For a clustering setup : 

~~~puppet
  class { 'influxdb': 
    meta_peers => [
      'IP_address_A:bind_address_port_A',
      'IP_address_B:bind_address_port_B',
      'IP_address_C:bind_address_port_C',
      ]
  }
~~~

####Hiera example

```yaml
influxdb::package_version: '0.9.2'
influxdb::graphite_enabled: true
influxdb::graphite_batch_size: 500,
influxdb::retention_replication: 3
influxdb::meta_peers:
 - 'IP_address_A:bind_address_port_A'
 - 'IP_address_B:bind_address_port_B'
 - 'IP_address_C:bind_address_port_C'
```

##Reference

###Classes

####Public Classes

* [`influxdb`](#class-influxdb): Guides the basic setup of InfluxDB.

####Private Classes

* `influxdb::install`: Installs InfluxDB packages.
* `influxdb::config`: Configures InfluxDB.
* `influxdb::params`: Manages InfluxDB parameters.
* `influxdb::service`: Manages the InfluxDB daemon.

###Parameters

Every configuration option of influxdb is managed by this module. 
Puppet variables can't contain hyphens, so they are replaced by an underscore to match influxdb variables ; puppet variables got a prefix to avoid collision too.

####`package_name`

String

####`package_ensure`

####`package_source`

####`package_suffix`

####`package_version`

####`package_dldir`

####`package_source`

####`service_name`

####`proxy_http`

####`config_file`

####`influxdb_user`

####`influxdb_group`

####`conf_template`

####`reporting_disabled`

####`storage_dir`

####`meta_influxdb_hostname`

####`meta_bind_address`

####`meta_retention_autocreate`

####`meta_election_timeout`

####`meta_heartbeat_timeout`

####`meta_leader_lease_timeout`

####`meta_commit_timeout`

####`meta_peers`

####`data_max_wal_size`

####`data_wal_flush_interval`

####`data_wal_partition_flush_delay`

####`cluster_shard_writer_timeout`

####`cluster_write_timeout`

####`retention_enabled`

####`retention_check_interval`

####`retention_replication`

####`shard_precreation_enabled`

####`shard_precreation_check_interval`

####`shard_precreation_advance_period`

####`http_enabled`

####`http_bind_address`

####`http_log_enabled`

####`http_auth_enabled`

####`http_write_tracing`

####`http_pprof_enabled`

####`http_https_enabled`

####`http_https_certificate`

####`admin_enabled`

####`admin_bind_address`

Default bind address for the HTTP server

####`admin_https_enabled`

####`admin_https_certificate`

####`graphite_enabled`

Boolean, if enabled sets up the graphite plugin

####`graphite_bind_address`

Default binding interface if none is specified.

####`graphite_protocol`

Default IP protocol used by the Graphite input

####`graphite_consistency_level`

Default write consistency for the Graphite input

####`graphite_separator`

Default join character to use when joining multiple measurment parts in a template

####`graphite_batch_size`

####`graphite_batch_timeout`

####`graphite_templates`

Templates allow matching parts of a metric name to be used as tag names in the stored metric. They have a similar format to graphite metric names. The values in between the separators are used as the tag name. The location of the tag name that matches the same position as the graphite metric section is used as the value. If there is no value, the graphite portion is skipped.

The special value measurement is used to define the measurement name. It can have a trailing * to indicate that the remainder of the metric should be used. If a measurement is not specified, the full metric name is used.

####`graphite_database`

Default database if none is specified

####`graphite_tags`

If you need to add the same set of tags to all metrics, you can define them globally at the plugin level and not within each template description.

####`opentsdb_enabled`

Boolean, if enabled sets up the opentsdb plugin

####`opentsdb_bind_address`

Default address that the service binds to.

####`opentsdb_database`

Default database used for writes.

####`opentsdb_retention_policy`

Default retention policy used for writes.

####`opentsdb_consistency_level`

Default write consistency level.

####`cqueries_enabled`

If this flag is set to false, both the brokers and data nodes should ignore any CQ processing.

####`cqueries_recompute_previous_n`

When continuous queries are run we'll automatically recompute previous intervals in case lagged data came in. 
Set to zero if you never have lagged data. We do it this way because invalidating previously computed intervals would be insanely hard and expensive.

####`cqueries_recompute_no_older_than`

The RecomputePreviousN setting provides guidance for how far back to recompute, the RecomputeNoOlderThan setting sets a ceiling on how far back in time it will go. 
For example, if you have 2 PreviousN and have this set to 10m, then we'd only compute the previous two intervals for any CQs that have a group by time <= 5m. For all others, we'd only recompute the previous window

####`cqueries_compute_runs_per_interval`

ComputeRunsPerInterval will determine how many times the current and previous N intervals will be computed. 
The group by time will be divided by this and it will get computed  this many times: group by time seconds / runs per interval

This will give partial results for current group by intervals and will determine how long it will be until lagged data is recomputed. 
For example, if this number is 10 and the group by time is 10m, it will be a minute past the previous 10m bucket of time before lagged data is picked up

####`cqueries_compute_no_more_than`

ComputeNoMoreThan paired with the RunsPerInterval will determine the ceiling of how many times smaller group by times will be computed. 
For example, if you have RunsPerInterval set to 10 and this setting to 1m. Then for a group by time(1m) will actually only get computed once per interval (and once per PreviousN).
If you have a group by time(5m) then you'll get five computes per interval. Any group by time window larger than 10m will get computed 10 times for each interval.

###Defined Types

#### influxdb_database

~~~
influxdb_database { 'graphite':
  ensure  => 'present',
}
~~~

#### influxdb_retention_policy

`influxdb_retention_policy` creates retention policy on databases. 
To use it you must create the title of the resource as shown below,
following the pattern of `policy_name@database`:

~~~
influxdb_retention_policy { '1w@graphite':
  ensure      => present,
  database    => 'graphite',
  duration    => '1w',
  is_default  => true,
  replication => '1',
}
~~~

Right now, there is a bug in influxdb, Puppet will try at each run to alter the database with the same value.
See : https://github.com/influxdb/influxdb/issues/3634

##Limitations

This module has been tested on:

 - Debian 7 Wheezy

It should also work on Debian-based OS (Ubuntu) and RedHat osfamily

This module is fully compatible with Puppet 3.x and Puppet 4.x

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/olivierHa/puppet-influxdb/issues)

##Development

 - Validation of given parameters
 - rspec and beaker tests
