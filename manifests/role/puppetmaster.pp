# Sets up a puppet master.
class sys11puppet::role::puppetmaster(
  $enable_dashboard = hiera('sys11puppet::dashboard::enable'),
) {
  # os-395, use sys11puppet::role::puppetmaster and ::agent in combination
  contain puppet::repo::puppetlabs
  include sys11puppet::profile::reportclean
  require sys11puppet::profile::master::apache_mpm

  class {'sys11puppet::profile::master::main':}
  class {'sys11puppet::profile::master::monitoring':}

  if $enable_dashboard {
    class {'sys11puppet::profile::dashboard':
      require => Class['sys11puppet::profile::master'],
    }
  }
}
