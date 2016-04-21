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

  def duration_to_s(dur)
    re = /^(\d+w)?(\d+d)?(\d+h)?(\d+m)?(\d+s?)?$/
    match = dur.match re
    if match
      val = 0
      val += match[1].chop.to_i * 604800 if match[1]
      val += match[2].chop.to_i * 86400 if match[2]
      val += match[3].chop.to_i * 3600 if match[3]
      val += match[4].chop.to_i * 60 if match[4]
      val += match[5].chop.to_i if match[5]
      return "#{val}s"
    end
    return nil
  end

  newproperty(:database) do
    desc "Database retention"
    newvalues(/^\S+$/)
  end

  newproperty(:duration) do
    desc "Duration of retention, format is <INT>w<INT>d<INT>h<INT>s"
    newvalues(/^(\d+w)?(\d+d)?(\d+h)?(\d+m)?(\d+s)?$/)

    munge do |value|
      @resource.duration_to_s(value)
    end

  end

  newproperty(:replication) do
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
