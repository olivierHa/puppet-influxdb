require 'spec_helper'

describe '::influxdb', :type => :class do
  context 'Debian default parameters' do
      describe "influxdb class without any parameters on Debian" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => 'Debian',
          :operatingsystem => 'Debian',
          :lsbdistid => 'Debian',
          :operatingsystemrelease => '7.8',
          :lsbdistcodename => 'wheezy',
        }}

        it { should compile.with_all_deps }
        it { should contain_class('influxdb::params') }
        it { should contain_class('influxdb::install').that_comes_before('class[influxdb::config]') }
        it { should contain_class('influxdb::config') }
        it { should contain_class('influxdb::service').that_subscribes_to('class[influxdb::config]') }
        it { should contain_service('influxdb') }
        it { should contain_package('influxdb').with_ensure('present') }
      end
  end

  context 'RedHat default parameters' do
      describe "influxdb class without any parameters on RedHat" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemrelease => '6',
          :lsbdistid => 'RedHat',
        }}

        it { should compile.with_all_deps }
        it { should contain_class('influxdb::params') }
        it { should contain_class('influxdb::install').that_comes_before('class[influxdb::config]') }
        it { should contain_class('influxdb::config') }
        it { should contain_class('influxdb::service').that_subscribes_to('class[influxdb::config]') }
        it { should contain_service('influxdb') }
        it { should contain_package('influxdb').with_ensure('present') }
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
        :lsbdistid => 'Debian',
        :operatingsystemrelease => '7.8',
        :lsbdistcodename => 'wheezy',
      }
    end
    it { is_expected.to contain_file("/etc/influxdb/influxdb.conf").with(
        'ensure'  => 'file',
        'owner'   => 'influxdb',
        'group'   => 'influxdb',
        'mode'    => '0640',
    ) }
    it do 
      is_expected.to contain_file("/etc/influxdb/influxdb.conf").with_content %r{dir = "/var/lib/influxdb/meta"}
      is_expected.to contain_file("/etc/influxdb/influxdb.conf").with_content %r{dir = "/var/lib/influxdb/hh"}
      is_expected.to contain_file("/etc/influxdb/influxdb.conf").with_content %r{dir = "/var/lib/influxdb/data"}
      is_expected.to contain_file("/var/lib/influxdb/meta")
      is_expected.to contain_file("/var/lib/influxdb/hh")
      is_expected.to contain_file("/var/lib/influxdb/data")
    end
  end

  context "when declaring another dir" do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :lsbdistid => 'Debian',
        :operatingsystemrelease => '7.8',
        :lsbdistcodename => 'wheezy',
      }
    end
    let(:params) { {
      :data => {
         'dir' => '/data/influxdb/data', 
      },
      :meta => {
         'dir' => '/data/influxdb/meta', 
      },
      :hh => {
         'dir' => '/data/influxdb/hh', 
      },
    } }
    it do 
      is_expected.to contain_file("/etc/influxdb/influxdb.conf").with_content %r{dir = "/data/influxdb/meta"}
      is_expected.to contain_file("/etc/influxdb/influxdb.conf").with_content %r{dir = "/data/influxdb/hh"}
      is_expected.to contain_file("/etc/influxdb/influxdb.conf").with_content %r{dir = "/data/influxdb/data"}
      is_expected.to contain_file("/data/influxdb/meta")
      is_expected.to contain_file("/data/influxdb/hh")
      is_expected.to contain_file("/data/influxdb/data")
    end
  end

  context "with specific wal size plugin" do
    let :facts do
      {
        :osfamily => 'Debian',
        :lsbdistid => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.8',
        :lsbdistcodename => 'wheezy',
      }
    end
    let :params do
      {   :data => { 'max-wal-size' => '1024000'} 
      }
    end
    it { is_expected.to contain_file("/etc/influxdb/influxdb.conf").with_content %r{max-wal-size = 1024000} }
  end

end
