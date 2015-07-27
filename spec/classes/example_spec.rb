require 'spec_helper'

describe 'influxdb' do
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
end
