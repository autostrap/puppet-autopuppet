class sys11puppet::role::agent() {
  # os-395, use sys11puppet::role::puppetmaster and ::agent in combination
  contain puppet::repo::puppetlabs

  class {'sys11puppet::profile::agent':}
  class {'sys11puppet::profile::agent::monitoring':}
}
