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

The influxdb module lets you use Puppet to install, configure, and manage Influxdb, version > 0.8 (so 0.9.x and 0.10.x)
The current InfluxDB version is 0.10 (rc1)

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

To enable Graphite plugin : 

~~~puppet
  class { 'influxdb': 
    graphite => {
     main => {
        enabled => true,
     }
    }
  }
~~~

With InfluxDB, you can configure several graphite backends.

####A more complex example

~~~puppet
  class { 'influxdb': 
    graphite => {
     main => {
        enabled => true,
        database      => 'mygraphitedb',
        batch_size    => 500,
        tags          => ['region=us-east', 'zone=1c'],
        templates     => [
           "servers.* .host.measurement*",
           "stats.* .host.measurement* region=us-west,agent=sensu",
        ]
     },
     udp => {
        enabled => true,
        bind-address => ':20003',
        protocol => 'udp',
     }
    }
  }
~~~

To enable Collectd plugin:

~~~puppet
  class { 'influxdb': 
    collectd => {  
      enabled => true,
    }
  }
~~~

####Hiera example

```yaml
influxdb::package_version: '0.10.0'
influxdb::graphite:
 main:
   enabled: true
   batch_size: 3
influxdb::data:
  dir: '/mnt/influxdb/data'
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

As InfluxDB is moving quickly, this module has a "dynamic" structure.
Each section of the Influxdb configuration file is mapped to a hash.
So you can easily add/remove new parameters as the influxdb software evolves, without change this module.

####`Section Hashes`

Each config file section accepts a hash of values. Defaults are set in params.pp

Here are the default values for the meta section :

~~~puppet

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
~~~

####`package_ensure`
Choose whether to install or uninstall. Default: present

####`package_source`
Specify package source prefix. Defaults to "http://s3.amazonaws.com/influxdb/influxdb_"

####`package_suffix`
Specify package source suffix. Defaults to _$arch.$package_provider (e.g. -1.x86_64.rpm or _amd64.deb)

####`package_version`
Default: '0.10.0-0.rc1'

####`package_dldir`
Choose where the package is downloaded. Defaults to "/opt"

####`service_name`
Specify service name. Defaults to "influxdb"

####`proxy_http`
Specify http proxy for package download. Defaults to undef

####`config_file`
Full path to config file (e.g. /etc/influxdb/influxdb.conf). Defaults to "/etc/influxdb/influxdb.conf"

####`influxdb_user`
Ownership of influxdb directories. (Don't set user that will run influxdb ... yet) Default: 'influxdb'

####`influxdb_group`
Group of influxdb directories. Default: 'influxdb'

####`conf_template`
Specify template to use for influxdb conf file. Defaults to "influxdb/influxdb.conf.erb"

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

##Limitations

This module has been tested on:

 - Debian 7 Wheezy
 - Debian 8 Jessie
 - CentOS 6.7

It should also work on Debian-based OS (Ubuntu) and RedHat osfamily

This module is fully compatible with Puppet 3.x and Puppet 4.x

Providers work without authentication/authorization (work in progress)

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/olivierHa/puppet-influxdb/issues)

##Development

 - rspec and beaker tests
 - authentication/authorization for provider
