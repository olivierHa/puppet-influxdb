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
     should contain_package('influxdb').with_ensure('present')
   end
  end
end
