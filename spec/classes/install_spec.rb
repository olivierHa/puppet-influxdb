require 'spec_helper'

describe 'influxdb', :type => :class do
  context "defaut install parameters" do
    let :facts do
      {
        :osfamily => 'Debian',
        :lsbdistid => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.8',
        :lsbdistcodename => 'wheezy',
      }
    end
   it do
     should contain_package('influxdb').with_ensure('present')
   end
  end
end
