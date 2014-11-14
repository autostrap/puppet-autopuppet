class sys11puppet::profile::agent::monitoring(
  $puppet_master = hiera('sys11puppet::common::puppet_master'),
  $monitoring       = hiera('sys11stack::monitoring', false),
) {
  # only run when run via puppet-master
  if $::clientcert {
    case $monitoring {
      'sensu':  {
        augeas { 'is_sensu_puppet_member':
          context => '/files/etc/group',
          onlyif  => 'match /files/etc/group/puppet size != 0',
          notify  => Service['sensu-client'],
          changes => [
            'set /files/etc/group/puppet/user[.=\'sensu\'] sensu'
          ],
        }

        file {'/usr/lib/nagios/plugins/check_puppet_agent':
          ensure => file,
          mode   => 555,
          source => "puppet:///modules/$module_name/check_puppet_agent",
        }

        sensu::check{'check_puppet_agent':
          command => "PATH=\$PATH:/usr/lib/nagios/plugins/ check_puppet_agent",
          require => File['/usr/lib/nagios/plugins/check_puppet_agent'],
        }
      }
      false:  { }
      default: { fail("Only sensu monitoring supported ('$monitoring' given)") }
    }

  }
}
