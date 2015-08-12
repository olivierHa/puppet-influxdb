Puppet::Type.newtype(:influxdb_retention_policy) do
  @doc = 'Manage Influxdb retention policies.'

  ensurable

  autorequire(:class) { 'influxdb::install' }

  newparam(:name, :namevar => true) do
    desc 'The name of the retention to manage.'
  end

  def munge_boolean(value)
    case value
    when true, "true", :true
      :true
    when false, "false", :false
      :false
    else
      fail("munge_boolean only takes booleans")
    end
  end

  newproperty(:database,) do
    desc "Database retention"
    newvalues(/^\S+$/)
  end

  newproperty(:duration,) do
  # Need to find a good regex for this one
    desc "Duration of retention"
  end
 
  newproperty(:replication,) do
    desc "Number of replication"
    newvalues(/^\d+$/)
  end

  newproperty(:is_default, :boolean => true) do
    desc "Is it the default retention policy for this database"
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

end
