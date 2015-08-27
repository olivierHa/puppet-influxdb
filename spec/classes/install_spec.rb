require 'spec_helper'

describe 'influxdb', :type => :class do
  context "defaut install parameters" do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.8',
      }
    end
   it do
     should contain_package('curl').with_ensure('present')
     should contain_package('influxdb').with_ensure('latest')
     should contain_exec('get_influxdb')
   end
  end
end
