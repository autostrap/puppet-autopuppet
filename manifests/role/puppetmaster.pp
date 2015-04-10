# Sets up a puppet master.
class sys11puppet::role::puppetmaster(
  $enable_dashboard = hiera('sys11puppet::dashboard::enable'),
) {
  # os-395, use sys11puppet::role::puppetmaster and ::agent in combination
  contain puppet::repo::puppetlabs
  contain sys11puppet::profile::reportclean

  class {'sys11puppet::profile::master':}

  if $enable_dashboard {
    class {'sys11puppet::profile::dashboard':
      require => Class['sys11puppet::profile::master'],
    }
  }
}
