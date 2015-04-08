class sys11puppet::profile::agent::monitoring(
  $puppet_master = hiera('sys11puppet::common::puppet_master'),
  $monitoring       = hiera('sys11stack::monitoring', false),
) {
  # only run when run via puppet-master
  if $::clientcert {
    case $monitoring {
      'sensu':  {

        ### Check for successful puppet run ###

        file {'/usr/lib/nagios/plugins/check_puppet_agent':
          ensure => file,
          mode   => '0555',
          source => "puppet:///modules/$module_name/check_puppet_agent",
        }

        file_line { 'sudo_check_puppet_agent':
          path    => '/etc/sudoers',
          line    => 'sensu ALL=(ALL) NOPASSWD: /usr/lib/nagios/plugins/check_puppet_agent',
          require => File['/usr/lib/nagios/plugins/check_puppet_agent'],
        }


        sensu::check{'check_puppet_agent':
          command     => 'sudo /usr/lib/nagios/plugins/check_puppet_agent',
          require     => [File['/usr/lib/nagios/plugins/check_puppet_agent'], File_line['sudo_check_puppet_agent']],
          interval    => 600,
          occurrences => 2,
        }


      ### Check for running puppet service ###

      file {'/usr/lib/nagios/plugins/check_puppet_agent_running':
          ensure => file,
          mode   => '0555',
          source => "puppet:///modules/$module_name/check_puppet_agent_running",
        }

      sensu::check{'puppet_agent_running':
          command     => '/usr/lib/nagios/plugins/check_puppet_agent_running',
          require     => File['/usr/lib/nagios/plugins/check_puppet_agent_running'],
          interval    => 60,
          occurrences => 1,
        }

      }

      false:  { }
      default: { fail("Only sensu monitoring supported ('$monitoring' given)") }
    }

  }
}
