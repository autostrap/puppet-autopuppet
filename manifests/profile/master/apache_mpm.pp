class sys11puppet::profile::master::apache_mpm(
  $mpm = hiera('apache::mpm_module', 'event'),
) {
  if $mpm != 'event' {
    exec { 'disable-mpm-event':
      command => 'a2dismod mpm_event',
      path    => [ '/usr/sbin', '/usr/bin', '/bin' ],
      onlyif  => 'test -e /etc/apache2/mods-enabled/mpm_event.load',
      require => Package['apache2'],
      before  => Service['apache2'],
    }
  }
}

