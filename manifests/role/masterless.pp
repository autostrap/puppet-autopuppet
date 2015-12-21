# Sets up masterless puppet runs.
class autopuppet::role::masterless() {
  include autopuppet::profile::reportclean
  class {'autopuppet::profile::masterless':}
}
