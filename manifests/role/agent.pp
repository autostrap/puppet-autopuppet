class autopuppet::role::agent() {
  # os-395, use autopuppet::role::puppetmaster and ::agent in combination
  contain puppet::repo::puppetlabs

  class {'autopuppet::profile::agent':}
  class {'autopuppet::profile::agent::monitoring':}
}
