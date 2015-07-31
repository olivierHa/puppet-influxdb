require 'spec_helper'

describe '::influxdb', :type => :class do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "influxdb class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('influxdb::params') }
        it { should contain_class('influxdb::install').that_comes_before('influxdb::config') }
        it { should contain_class('influxdb::config') }
        it { should contain_class('influxdb::service').that_subscribes_to('influxdb::config') }

        it { should contain_service('influxdb') }
        it { should contain_package('influxdb').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'influxdb class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('influxdb') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end

  context "with default parameters" do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.8',
      }
    end
    it { is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with(
        'ensure'  => 'present',
        'owner'   => 'influxdb',
        'group'   => 'influxdb',
        'mode'    => '0644',
    ) }
    it do 
      is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with_content %r{dir = "/var/opt/influxdb/meta"}
      is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with_content %r{dir = "/var/opt/influxdb/hh"}
      is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with_content %r{dir = "/var/opt/influxdb/data"}
      is_expected.to contain_file("/var/opt/influxdb/meta")
      is_expected.to contain_file("/var/opt/influxdb/hh")
      is_expected.to contain_file("/var/opt/influxdb/data")
    end
  end

  context "when declaring another storage dir" do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.8',
      }
    end
    let :params do
      { :storage_dir => '/data/influxdb' }
    end
    it do 
      is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with_content %r{dir = "/data/influxdb/meta"}
      is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with_content %r{dir = "/data/influxdb/hh"}
      is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with_content %r{dir = "/data/influxdb/data"}
      is_expected.to contain_file("/data/influxdb/meta")
      is_expected.to contain_file("/data/influxdb/hh")
      is_expected.to contain_file("/data/influxdb/data")
    end
  end

  context "with specific wal size plugin" do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.8',
      }
    end
    let :params do
      {
        :data_max_wal_size => '1024000',  
      }
    end
    it { is_expected.to contain_file("/etc/opt/influxdb/influxdb.conf").with_content %r{max-wal-size = 1024000} }
  end

end
