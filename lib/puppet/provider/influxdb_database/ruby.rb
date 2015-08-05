Puppet::Type.type(:influxdb_database).provide(:ruby) do
  desc 'Manages InfluxDB databases.'

commands :influx_cli => '/opt/influxdb/influx'

def get_database_list()
  begin
    output = influx_cli(['-execute', 'show databases'])
  rescue Puppet::ExecutionFailure => e
    Puppet.debug("#get_database_list had an error -> #{e.inspect}")
    return nil
  end
  databases = output.split("\n")[2..-1]
  Puppet.debug("#get_database_list output -> #{databases}")
  databases
end

def exists?
  dbs = get_database_list()
  dbs.include? resource[:name]
end

def create
  influx_cli(['-execute', "create database #{resource[:name]}"].compact)
end

def destroy
  influx_cli(['-execute', "drop database #{resource[:name]}"].compact)
end

end
