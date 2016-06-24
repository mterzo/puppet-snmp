require 'puppetlabs_spec_helper/module_spec_helper'

OPERATING_SYSTEM_MAP = {
	'Centos' => {
  	'os'     => 'CentOS',
    'family' => 'Redhat',
    'release' => '6.4',
    'var_path' => '/var/lib/net-snmp'
	},
  'ubuntu' => {
  	'os' => 'Ubuntu',
    'family' => 'Debian',
    'release' => '12.04',
    'var_path' => '/var/lib/net-snmp'
	},
  'Debian' => {
		'os' => 'Debian',
    'family' => 'Debian',
		'release' => '6.0.7',
    'var_path' => '/var/lib/net-snmp'
	},
	'sles' => {
  	'os' => 'SLES',
		'family' => 'Suse',
    'release' => '11.1',
    'var_path' => '/var/lib/net-snmp'
	},
	'FreeBSD' => {
  	'os' => 'FreeBSD',
		'family' => 'FreeBSD',
    'release' => '9.2',
    'var_path' => '/var/lib/net-snmp'
	}
}
