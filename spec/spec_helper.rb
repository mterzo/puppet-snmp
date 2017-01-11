require 'puppetlabs_spec_helper/module_spec_helper'

OPERATING_SYSTEM_MAP = {
	'Centos' => {
    'facts' => {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '6.4',
      :operatingsystemmajrelease => '6',
      :fqdn => 'myhost.localdomain'
    },
    'snmp_client_package' => 'net-snmp-utils',
  	'os'     => 'CentOS',
    'family' => 'RedHat',
    'release' => '6.4',
    'snmpd_sysconf' => '/etc/sysconfig/snmpd',
    'options' => '-LS0-6d -Lf /dev/null -p /var/run/snmpd.pid',
    'snmptrapd_conf' => '/etc/snmp/snmptrapd.conf',
    'snmptrap_sysconf' => '/etc/sysconfig/snmptrapd',
    'has_service_trapd' => true,
    'var_perm' => '0755',
    'var_path' => '/var/lib/net-snmp'
	},
  'ubuntu' => {
    'facts' => {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemrelease => '12.04',
      :fqdn => 'myhost.localdomain'
    },
    'snmp_client_package' => 'snmp',
  	'os' => 'Ubuntu',
    'family' => 'Debian',
    'release' => '12.04',
    'snmpd_package' => 'snmpd',
    'snmpd_sysconf' => '/etc/default/snmpd',
    'snmpd_conf_mode' => '0600',
    'options' => 'SNMPDOPTS=\'-Lsd -Lf /dev/null -u snmp -g snmp -I -smux -p /var/run/snmpd.pid\'',
    'snmptrap_sysconf' => nil,
    'snmptrapd_conf' => '/etc/snmp/snmptrapd.conf',
    'trapd_service_name' => 'snmpd',
    'snmpdtrapd_conf_mode' => '0600',
    'var_perm' => '0755',
    'var_owner' => 'snmp',
    'var_group' => 'snmp',
    'var_path' => '/var/lib/snmp'
	},
  'Debian' => {
    'facts' => {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0.7',
      :fqdn => 'myhost.localdomain'
    },
    'snmp_client_package' => 'snmp',
		'os' => 'Debian',
    'family' => 'Debian',
		'release' => '6.0.7',
    'snmpd_package' => 'snmpd',
    'snmpd_sysconf' => '/etc/default/snmpd',
    'snmpd_conf_mode' => '0600',
    'options' => 'SNMPDOPTS=\'-Lsd -Lf /dev/null -u snmp -g snmp -I -smux -p /var/run/snmpd.pid\'',
    'trapd_service_name' => 'snmpd',
    'snmptrap_sysconf' => nil,
    'snmptrapd_conf' => '/etc/snmp/snmptrapd.conf',
    'snmpdtrapd_conf_mode' => '0600',
    'var_perm' => '0755',
    'var_owner' => 'snmp',
    'var_group' => 'snmp',
    'var_path' => '/var/lib/snmp'
	},
	'sles' => {
    'facts' => {
      :osfamily => 'Suse',
      :operatingsystem => 'SLES',
      :operatingsystemrelease => '11.1',
      :fqdn => 'myhost.localdomain'
    },
    'snmp_client_package' => nil,
  	'os' => 'SLES',
		'family' => 'Suse',
    'release' => '11.1',
    'snmpd_conf_mode' => '0600',
    'snmpd_sysconf' => '/etc/sysconfig/net-snmp',
    'options' => 'SNMPD_LOGLEVEL="d"',
    'snmptrap_sysconf' => nil,
    'snmptrapd_conf' => '/etc/snmp/snmptrapd.conf',
    'has_service_trapd' => true,
    'snmpdtrapd_conf_mode' => '0600',
    'trapd_exec' => 'Exec[install /etc/init.d/snmptrapd]',
    'var_perm' => '0755',
    'var_path' => '/var/lib/net-snmp'
	},
	'FreeBSD' => {
    'facts' => {
      :osfamily => 'FreeBSD',
      :operatingsystem => 'FreeBSD',
      :operatingsystemrelease => '9.2',
      :fqdn => 'myhost.localdomain'
    },
    'snmpd_package' => 'net-mgmt/net-snmp',
    'snmp_client_package' => 'net-mgmt/net-snmp',
  	'os' => 'FreeBSD',
		'family' => 'FreeBSD',
    'release' => '9.2',
    'client_config' => '/usr/local/etc/snmp/snmp.conf',
    'options' => '-LS0-6d -Lf /dev/null -p /var/run/snmpd.pid',
    'has_service_trapd' => true,
    'snmpd_conf_file' => '/usr/local/etc/snmp/snmpd.conf',
    'snmpd_conf_group' => 'wheel',
    'snmpd_conf_mode' => '0755',
    'snmpd_sysconf' => nil,
    'snmptrap_sysconf' => nil,
    'snmptrapd_conf' => '/usr/local/etc/snmp/snmptrapd.conf',
    'trapd_conf_group' => 'wheel',
    'snmpdtrapd_conf_mode' => '0755',

    'var_perm' => '0600',
    'var_group' => 'wheel',
    'var_path' => '/var/net-snmp',
	}
}
