# Sets up a puppet master.
class autopuppet::role::puppetmaster_bootstrap(
  $enable_dashboard = hiera('autopuppet::dashboard::enable'),
) {
  # os-395, use autopuppet::role::puppetmaster and ::agent in combination
  contain puppet::repo::puppetlabs
  include autopuppet::profile::reportclean
  require autopuppet::profile::master::apache_mpm

  class {'autopuppet::profile::master::main':}

  if $enable_dashboard {
    class {'autopuppet::profile::dashboard':
      require => Class['autopuppet::profile::master'],
    }
  }
}
