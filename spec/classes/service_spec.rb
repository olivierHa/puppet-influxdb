require 'spec_helper'

describe 'influxdb::service', :type => :class do
  let :pre_condition do
    'include influxdb::params'
  end
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '7',
        :concat_basedir         => '/dne',
        :lsbdistcodename        => 'wheezy',
        :operatingsystem        => 'Debian',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false,
      }
    end

    it { is_expected.to contain_service("influxdb").with(
      'name'      => 'influxdb',
      'ensure'    => 'running',
      'enable'    => 'true'
      )
    }

    context "with $service_name => 'foo'" do
      let (:params) {{ :service_name => 'foo' }}
      it { is_expected.to contain_service("influxdb").with(
        'name'      => 'foo'
        )
      }
    end

    context "with $service_enable => true" do
      let (:params) {{ :service_enable => true }}
      it { is_expected.to contain_service("influxdb").with(
        'name'      => 'influxdb',
        'ensure'    => 'running',
        'enable'    => 'true'
        )
      }
    end

    context "with $service_enable => false" do
      let (:params) {{ :service_enable => false }}
      it { is_expected.to contain_service("influxdb").with(
        'name'      => 'influxdb',
        'ensure'    => 'running',
        'enable'    => 'false'
        )
      }
    end

    context "$service_enable must be a bool" do
      let (:params) {{ :service_enable => 'not-a-boolean' }}

      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end

    context "with $service_ensure => 'running'" do
      let (:params) {{ :service_ensure => 'running', }}
      it { is_expected.to contain_service("influxdb").with(
        'ensure'    => 'running',
        'enable'    => 'true'
        )
      }
    end

    context "with $service_ensure => 'stopped'" do
      let (:params) {{ :service_ensure => 'stopped', }}
      it { is_expected.to contain_service("influxdb").with(
        'ensure'    => 'stopped',
        'enable'    => 'true'
        )
      }
    end

    context "with $service_ensure => 'UNDEF'" do
      let (:params) {{ :service_ensure => 'UNDEF' }}
      it { is_expected.to contain_service("influxdb").without_ensure }
    end

  end

  context "on a RedHat 6 OS, do not manage service" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :operatingsystem        => 'RedHat',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :is_pe                  => false,
      }
    end
    let(:params) do
      {
        'service_ensure' => 'running',
        'service_name'   => 'influxdb',
        'service_manage' => false
      }
    end
    it 'should not manage the influxdb service' do
      expect(subject).not_to contain_service('influxdb')
    end
  end

end
