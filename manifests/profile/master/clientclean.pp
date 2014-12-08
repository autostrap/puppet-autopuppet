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
    notify => File['/etc/default/stunnel4'],
  }

  # remove removal of own certificate
  ensure {'/etc/init/puppetmaster-clean-certificate.conf':
    ensure => absent,
  }

  file {'/etc/default/stunnel4':
    ensure  => file,
    mode    => '0644',
    source => "puppet:///modules/$module_name/default_stunnel4",
    require => Package['stunnel4'],
    notify  => Service['stunnel4'],
  }


  file_line { 'enable_stunnel4':
    path   => '/etc/default/stunnel4',
    line   => 'ENABLED=1',
    match  => '^ENABLED=',
  }

  service {'stunnel4':
    ensure  => running,
    enable  => true,
    require => File_Line['enable_stunnel4'],
  }
}

