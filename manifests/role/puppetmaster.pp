# Sets up a puppet master.
class autopuppet::role::puppetmaster(
  $enable_dashboard = hiera('autopuppet::dashboard::enable'),
) {
  # os-395, use autopuppet::role::puppetmaster and ::agent in combination
  contain puppet::repo::puppetlabs
  include autopuppet::profile::reportclean

  class {'autopuppet::profile::master::main':}
  class {'autopuppet::profile::master::monitoring':}

  if $enable_dashboard {
    class {'autopuppet::profile::dashboard':
      require => Class['autopuppet::profile::master'],
    }
  }
}
