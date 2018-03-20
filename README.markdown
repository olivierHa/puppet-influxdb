[![Build Status](https://travis-ci.org/olivierHa/puppet-influxdb.svg)](https://travis-ci.org/olivierHa/puppet-influxdb)

#### Table of Contents

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

## Overview

The influxdb module lets you use Puppet to install, configure, and manage Influxdb version 1.0.0+
The current InfluxDB version is 1.2.0

## Deprecation Warning

InfluxDB 1.0.0 contains [breaking changes](https://github.com/influxdata/influxdb/blob/master/CHANGELOG.md#v100-2016-09-08)
which require changing the `data-logging-enabled` config attribute to `trace-logging-enabled`.
The other configuration changes are managed by the `influxdb.conf.erb` template already.

If you are using an older version of InfluxDB, you will need to use version 0.5.0 of this module

## Module Description

InfluxDB is a Open source distributed time series, events, and metrics database. 
This module handles the installation  and every configuration parameters.

Support for Puppet 3.x and Puppet 4.x

## Setup

### Beginning with influxdb

To install InfluxDB with the default parameters

```puppet
  class { 'influxdb': }
```

### What influxdb affects

* influxdb package.
* influxdb configuration file.
* influxdb service.

## Usage

To enable Graphite plugin : 

```puppet
  class { 'influxdb': 
    graphite => {
     main => {
        enabled => true,
     }
    }
  }
```

With InfluxDB, you can configure several graphite backends.

#### A more complex example

```puppet
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
```

To enable Collectd plugin:

```puppet
  class { 'influxdb': 
    collectd => {  
      enabled => true,
    }
  }
```

#### Hiera Example

```yaml
influxdb::package_ensure: 'latest'
influxdb::graphite:
 main:
   enabled: true
   batch_size: 3
influxdb::data:
  dir: '/mnt/influxdb/data'
```

## Reference

### Classes

#### Public Classes

* [`influxdb`](#class-influxdb): Guides the basic setup of InfluxDB.

#### Private Classes

* `influxdb::install`: Installs InfluxDB packages.
* `influxdb::config`: Configures InfluxDB.
* `influxdb::params`: Manages InfluxDB parameters.
* `influxdb::service`: Manages the InfluxDB daemon.

### Parameters

As InfluxDB is moving quickly, this module has a "dynamic" structure.
Each section of the Influxdb configuration file is mapped to a hash.
So you can easily add/remove new parameters as the influxdb software evolves, without change this module.

#### Section Hashes

Each config file section accepts a hash of values. Defaults are set in params.pp

Here are the default values for the meta section :

```puppet

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
```

#### `package_ensure`
Choose whether to install or uninstall, or force to the latest version. Default: present

#### `manage_repo`
Choose whether to configure influxdb repositories. Default: true

#### `config_file`
Full path to config file (e.g. /etc/influxdb/influxdb.conf). Defaults to "/etc/influxdb/influxdb.conf"

####` influxdb_user`
Ownership of influxdb directories. (Don't set user that will run influxdb ... yet) Default: 'influxdb'

#### `influxdb_group`
Group of influxdb directories. Default: 'influxdb'

#### `conf_template`
Specify template to use for influxdb conf file. Defaults to "influxdb/influxdb.conf.erb"

### Defined Types

#### influxdb_database

```puppet
influxdb_database { 'graphite':
  ensure  => 'present',
}
```

#### influxdb_retention_policy

`influxdb_retention_policy` creates retention policy on databases. 
To use it you must create the title of the resource as shown below,
following the pattern of `policy_name@database`:

```puppet
influxdb_retention_policy { '1w@graphite':
  ensure      => present,
  database    => 'graphite',
  duration    => '1w',
  is_default  => true,
  replication => '1',
}
```

## Limitations

This module has been tested on:

* Debian 7 Wheezy
* Debian 8 Jessie

It **should** also work on Debian-based OS (Ubuntu) and RedHat osfamily

This module is fully compatible with Puppet 3.x and Puppet 4.x

Providers work without authentication/authorization (work in progress)

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/olivierHa/puppet-influxdb/issues)

## Development

 - rspec and beaker tests
 - authentication/authorization for provider
