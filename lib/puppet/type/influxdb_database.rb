Puppet::Type.newtype(:influxdb_database) do
  @doc = 'Manage Influxdb databases.'

  ensurable

  autorequire(:class) { 'influxdb::install' }

  newparam(:name, :namevar => true) do
    desc 'The name of the Influxdb database to manage.'
  end

end
