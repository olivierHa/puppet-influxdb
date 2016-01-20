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

The influxdb module lets you use Puppet to install, configure, and manage Influxdb, version > 0.10.x
The current InfluxDB version is 0.10

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

####`Section Hashes`
Each config file section accepts a hash of values.  There are also defaults set in params.pp.

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
 - CentOS 6.7

It should also work on Debian-based OS (Ubuntu) and RedHat osfamily

This module is fully compatible with Puppet 3.x and Puppet 4.x

Providers work without authentication/authorization (work in progress)

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/olivierHa/puppet-influxdb/issues)

##Development

 - Validation of given parameters
 - rspec and beaker tests
