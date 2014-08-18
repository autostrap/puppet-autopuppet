class sys11puppet::role::puppetmaster(
  $enable_dashboard = hiera('sys11puppet::dashboard::enable'),
) {
  class {'sys11puppet::profile::master':}

  if $enable_dashboard {
    class {'sys11puppet::profile::dashboard':
      require => Class['sys11puppet::profile::master'],
    }
  }
}
