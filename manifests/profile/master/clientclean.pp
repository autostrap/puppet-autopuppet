class sys11puppet::profile::master::clientclean(
  $puppet_master = hiera('sys11puppet::common::puppet_master'),
) {
  package {'stunnel4': }

  file {'/usr/local/bin/puppetmaster_stunnel_clientclean':
    ensure => file,
    mode   => '555',
    source => "puppet:///modules/$module_name/puppetmaster_stunnel_clientclean",
  }

  file {'/etc/stunnel/puppetmaster.conf':
    ensure  => file,
    content => template("$module_name/stunnel_puppetmaster.conf.erb"),
    require => Package['stunnel4'],
    notify => Service['stunnel4'],
  }

  file_line { 'enable_stunnel4':
    path   => '/etc/default/stunnel4',
    line   => 'ENABLED=1',
    match  => '^ENABLED=',
    notify => Service['stunnel4'],
  }

  service {'stunnel4':
    ensure => running,
    enable => true,
  }
}
