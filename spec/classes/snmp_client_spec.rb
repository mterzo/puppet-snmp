#!/usr/bin/env rspec

require 'spec_helper'

describe 'snmp::client', :type => 'class' do

  context 'on a non-supported osfamily' do
    let(:params) {{}}
    let :facts do
      {
        :osfamily        => 'foo',
        :operatingsystem => 'bar'
      }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Module snmp is not supported on bar/)
      }
    end
  end

  context 'on a supported osfamily, default parameters' do
    OPERATING_SYSTEM_MAP.each do |os, map|
      describe "on #{map['family']}[#{map['os']}]:#{map['version']}" do
        let :facts do
          map['facts']
        end
        let(:params) {{}}
        it do

          if map['snmp_client_package']
            should contain_package('snmp-client')
              .with(
                :ensure => 'present',
                :name   => map['snmp_client_package']
              )
            #required_pkg = "Package['snmp-client']{:name => '#{map['snmp_client_package']}'}"
            required_pkg = 'Package[snmp-client]'
          else
            should_not contain_package('snmp-client')
            required_pkg = nil
          end

          if map['client_config']
            path = map['client_config']
          else
            path = '/etc/snmp/snmp.conf'
          end

          should contain_file('snmp.conf')
            .with(
              :ensure  => 'present',
              :mode    => '0644',
              :owner   => 'root',
              :group   => 'root',
              :path    => path,
              :require => required_pkg
            )
        end
      end
    end
  end

  context 'on a supported osfamily, custom parameters' do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemmajrelease => '6',
        :operatingsystemrelease => '6.4'
      }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent' }}
      it do
        should contain_package('snmp-client').with_ensure('absent')
        should contain_file('snmp.conf').with_ensure('absent')
      end
    end

    describe 'ensure => badvalue' do
      let(:params) {{ :ensure => 'badvalue' }}
      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /ensure parameter must be present or absent/)
        }
      end
    end

    describe 'autoupgrade => true' do
      let(:params) {{ :autoupgrade => true }}
      it do
        should contain_package('snmp-client').with_ensure('latest')
        should contain_file('snmp.conf').with_ensure('present')
      end
    end

    describe 'autoupgrade => badvalue' do
      let(:params) {{ :autoupgrade => 'badvalue' }}
      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /"badvalue" is not a boolean./)
        }
      end
    end

    describe 'snmp_config => [ "defVersion 2c", "defCommunity public" ]' do
      let(:params) {{ :snmp_config => [ 'defVersion 2c', 'defCommunity public' ] }}
      it { should contain_file('snmp.conf') }
      it 'should contain File[snmp.conf] with contents "defVersion 2c" and "defCommunity public"' do
        verify_contents(catalogue, 'snmp.conf', [
          'defVersion 2c',
          'defCommunity public',
        ])
      end
    end
  end
end
