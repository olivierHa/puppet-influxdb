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

##Module Description

InfluxDB is a Open source distributed time series, events, and metrics database. 
This module handles the installation (currently via downloading the package from influxdb website) and most of the parameters.

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

* Configuration files are under /etc/opt/influxdb
* Binaries are under /opt/influxdb

##Usage

To enable Graphite plugin

~~~puppet
  class { 'influxdb': 
    graphite_enable => true,
  }
~~~

You can also use advanced custom configuration:

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

##Reference

###Classes

####Public Classes

* [`influxdb`](#class-influxdb): Guides the basic setup of InfluxDB.

####Private Classes

* `influxdb::install`: Installs InfluxDB packages.
* `influxdb::config`: Configures InfluxDB.
* `influxdb::params`: Manages InfluxDB parameters.
* `influxdb::service`: Manages the InfluxDB daemon.

##Limitations

This module has been tested on:

 - Debian 7 Wheezy

It should also work on Debian-based OS (Ubuntu) and RedHat osfamily

This module is fully compatible with Puppet 3.x and Puppet 4.x

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/olivierHa/puppet-influxdb/issues)

##Development

 - Support of clustering and others services
 - rspec and beaker tests
