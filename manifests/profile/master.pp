class sys11puppet::profile::master() {
  include sys11puppet::profile::master::monitoring
  include sys11puppet::profile::master::main
}
