#!/usr/bin/env rspec

require 'spec_helper'

describe 'snmp::snmpv3_user', :type => 'define' do

  context 'on a supported osfamily' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.4',
      :operatingsystemmajrelease => '6'
    }
    end

    describe 'authtype => badString' do
      let(:title) { 'authtype' }

      let :params do {
        :authpass => 'myauthpass',
        :authtype => 'badString',
      }
      end

      it 'should fail' do
        expect {
          should raise_error(Puppet::Error,
                             /$authtype must be either SHA or MD5./)
        }
      end
    end

    describe 'privtype => badString' do
      let(:title) { 'privtype' }

      let :params do {
        :authpass => 'myauthpass',
        :privtype => 'badString',
      }
      end

      it 'should fail' do
        expect {
          should raise_error(Puppet::Error,
                             /$privtype must be either AES or DES./)
        }
      end
    end

    describe 'daemon => badString' do
      let(:title) { 'daemon' }

      let :params do {
        :authpass => 'myauthpass',
        :daemon   => 'badString',
      }
      end

      it 'should fail' do
        expect {
          should raise_error(Puppet::Error,
                             /$daemon must be either snmpd or snmptrapd./)
        }
      end
    end
  end

  OPERATING_SYSTEM_MAP.each do |os, map|
    context "on #{map['family']}[#{map['os']}]:#{map['version']}"  do
      let :facts do
        map['facts']
      end

      describe 'with default settings' do
        let(:title) { 'myDEFAULTuser' }
        let :params do {
          :authpass => 'myauthpass',
        }
        end
        user = 'myDEFAULTuser'

        it do
          cmd = 'service snmpd stop ; sleep 5 ; '
          cmd += 'echo "createUser %s %s \"%s\"" ' % [user, 'SHA',
                                                      'myauthpass']
          cmd += '>>%s/snmpd.conf && touch %s/%s-snmpd' % [map['var_path'],
                                                           map['var_path'],
                                                           user]

          should contain_exec("create-snmpv3-user-#{user}")
            .with(
              :command => cmd,
              :creates => "#{map['var_path']}/#{user}-snmpd",
              :require => [ 'Package[snmpd]', 'File[var-net-snmp]' ],
              :before  => 'Service[snmpd]'
            )
        end
      end

      describe 'with all settings' do
        let(:title) { 'myALLuser' }

        let :params do {
          :authpass => 'myauthpass',
          :authtype => 'MD5',
          :privpass => 'myprivpass',
          :privtype => 'DES'
        }
        end

        user = 'myALLuser'

        it do
          cmd = 'service snmpd stop ; sleep 5 ; '
          cmd += 'echo "createUser %s %s \"%s\" %s \"%s\"" ' % [user,'MD5',
                                                                'myauthpass',
                                                                'DES',
                                                                'myprivpass']
          cmd += '>>%s/snmpd.conf && touch %s/%s-snmpd' % [map['var_path'],
                                                           map['var_path'],
                                                           user]

          should contain_exec("create-snmpv3-user-#{user}")
            .with(
              :command => cmd,
              :creates => "#{map['var_path']}/#{user}-snmpd",
              :require => [ 'Package[snmpd]', 'File[var-net-snmp]' ],
              :before  => 'Service[snmpd]'
            )
        end
      end

      describe 'with snmptrapd settings' do
        let(:title) { 'myTRAPuser' }

        let :params do {
          :authpass => 'myauthpass',
          :daemon   => 'snmptrapd',
        }
        end

        user = 'myTRAPuser'

        it do

          if map['family'] == 'Debian'
            service = 'snmpd'
          else
            service = 'snmptrapd'
          end


          cmd = 'service %s stop ; sleep 5 ; ' % service
          cmd += 'echo "createUser %s %s \"%s\"" ' % [user,'SHA', 'myauthpass']
          cmd += '>>%s/%s.conf && touch %s/%s-%s' % [map['var_path'],
                                                     'snmptrapd',
                                                     map['var_path'], user,
                                                     'snmptrapd']
          should contain_exec("create-snmpv3-user-#{user}")
            .with(
              :command => cmd,
              :creates => "#{map['var_path']}/#{user}-snmptrapd",
              :require => [ 'Package[snmpd]', 'File[var-net-snmp]' ],
              :before  => "Service[#{service}]"
            )
        end
      end
    end
  end
end
