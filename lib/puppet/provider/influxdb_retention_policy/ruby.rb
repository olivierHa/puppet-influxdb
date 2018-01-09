Puppet::Type.type(:influxdb_retention_policy).provide(:ruby) do
  desc 'Manages InfluxDB retention policy.'

commands :influx_cli => '/usr/bin/influx'

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    instances = []
    begin
      dbs = influx_cli(['-execute', 'show databases'])
    rescue Puppet::ExecutionFailure => e
      Puppet.debug("#show databases had an error -> #{e.inspect}")
      return nil
    end
    databases = dbs.split("\n")[3..-1]

    databases.collect do |db|
      begin
        output = influx_cli(['-execute', "show retention policies on #{db}"].compact)
      rescue Puppet::ExecutionFailure => e
        Puppet.debug("#show retention policies had an error -> #{e.inspect}")
        return nil
      end
      policies = output.split("\n")[1..-1]
      policies.each do |policy|
        ret_name , duration , replica, is_default = policy.split(/\s+/).reject { |e| e.to_s.empty? }
        dur_s = self.duration_to_s(duration)
        instances << new(
           :name        => "#{ret_name}@#{db}",
           :ensure      => :present,
           :database    => db,
           :replication => replica,
           :duration    => dur_s,
           :is_default  => is_default
          )
      end
    end

  return instances
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def flush
    if @property_flush[:ensure] == :absent
        influx_cli(['-execute', "drop RETENTION POLICY #{resource[:name]} ON #{resource[:database]}"].compact)
        return
    end
    short_ret_name = "#{resource[:name]}".split('@').first
    if @property_flush[:ensure] == :present
      if resource[:is_default]
        influx_cli(['-execute', "create RETENTION POLICY \"#{short_ret_name}\" ON #{resource[:database]} DURATION #{resource[:duration]} REPLICATION #{resource[:replication]} DEFAULT"].compact)
      else
        influx_cli(['-execute', "create RETENTION POLICY \"#{short_ret_name}\" ON #{resource[:database]} DURATION #{resource[:duration]} REPLICATION #{resource[:replication]}"].compact)
      end
      return
    end
    cmd_arguments = "ALTER RETENTION POLICY \"#{short_ret_name}\" ON #{resource[:database]} "
    if @property_flush and ! @property_flush.empty?
      cmd_arguments << ' DURATION ' << @property_flush[:duration] if @property_flush[:duration]
      cmd_arguments << ' REPLICATION ' << @property_flush[:replication] if @property_flush[:replication]
      cmd_arguments << ' DEFAULT' if @property_flush[:is_default]
      influx_cli(['-execute', "#{cmd_arguments}"].compact)
    end
  end

  def exists?
    @property_hash[:ensure] == :present || false
  end

  def create
    @property_flush[:ensure] = :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def self.duration_to_s(dur)
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

  def duration=(duration)
    d1 = self.class.duration_to_s(duration)
    d2 = self.class.duration_to_s(@property_hash[:duration])
    if !d1.nil? and !d2.nil? and d1.to_i != d2.to_i
      @property_flush[:duration] = duration
    end
  end

  def replication=(replication)
    @property_flush[:replication] = replication
  end

  def is_default=(is_default)
    if is_default.to_s == 'true'
      @property_flush[:is_default] = is_default
    end
  end

end
