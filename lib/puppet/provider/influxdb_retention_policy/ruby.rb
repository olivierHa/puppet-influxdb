Puppet::Type.type(:influxdb_retention_policy).provide(:ruby) do
  desc 'Manages InfluxDB retention policy.'

commands :influx_cli => '/opt/influxdb/influx'

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
        ret_name , duration , replica, is_default = policy.split("\t").reject { |e| e.to_s.empty? }
        instances << new(
           :name        => "#{ret_name}@#{db}",
           :ensure      => :present,
           :database    => db,
           :replication => replica,
           :duration    => duration,
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
    if @property_flush
      cmd_arguments << ' DURATION ' << @property_flush[:duration] if @property_flush[:duration]
      cmd_arguments << ' REPLICATION ' << @property_flush[:replication] if @property_flush[:replication]
      cmd_arguments << ' DEFAULT' if @property_flush[:is_default]
    end
    if ! cmd_arguments.empty?
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

  def duration=(duration)
    @property_flush[:duration] = duration
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
