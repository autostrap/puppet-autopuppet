class sys11puppet::profile::masterless(
  $runinterval = hiera('sys11puppet::masterless::runinterval', 5),
  $noopvalue = hiera('sys11puppet::agent::noop', false),
) {
    $command_noop = '/usr/local/sbin/run_puppet_hiera --logdest syslog'
    $command = '/usr/local/sbin/run_puppet_hiera --logdest syslog'

  if $noop {
    # Remove normal command
    cron{'run_puppet_hiera':
      ensure  => absent,
      command => $command,
      user    => root,
      minute  => "*/${runinterval}"
      }

    # Add normal command
    cron{'run_puppet_hiera':
      command => $command_noop,
      user    => root,
      minute  => "*/${runinterval}"
      }
  }
  else {
    # Add normal command
    cron{'run_puppet_hiera':
      command => $command,
      user    => root,
      minute  => "*/${runinterval}"
      }

    # Remove noop command
    cron{'run_puppet_hiera':
      ensure  => absent,
      command => $command_noop,
      user    => root,
      minute  => "*/${runinterval}"
      }
  }

}

