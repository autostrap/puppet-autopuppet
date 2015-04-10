# Sets up masterless puppet runs.
class sys11puppet::role::masterless() {
  contain sys11puppet::profile::reportclean
  class {'sys11puppet::profile::masterless':}
}
