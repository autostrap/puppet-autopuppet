class sys11puppet::profile::master::monitoring(
  $monitoring       = hiera('sys11stack::monitoring', false),
) {
  # only run when run via puppet-master
  if $::clientcert {
    case $monitoring {
      'sensu':  {
        sensu::check{'puppetdb_http':
          command => '/usr/lib/nagios/plugins/check_http -H localhost -p 8080',
        }
      }

      false:  { }
      default: { fail("Only sensu monitoring supported ('$monitoring' given)") }
    }
  }
}
