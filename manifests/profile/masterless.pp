class sys11puppet::profile::masterless(
  $runinterval = hiera('sys11puppet::masterless::runinterval', 5),
  $noopvalue = hiera('sys11puppet::masterless::noop', false),
) {
    $command_noop = '/usr/local/sbin/run_puppet_hiera --noop --logdest syslog'
    $command = '/usr/local/sbin/run_puppet_hiera --logdest syslog'

  if $noopvalue {
    # Remove normal command
    cron{'run_puppet_hiera':
      ensure  => absent,
      command => $command,
      user    => root,
      minute  => "*/${runinterval}"
      }

    # Add noop command
    cron{'run_puppet_hiera noop':
      command     => $command_noop,
      user        => root,
      environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      minute      => "*/${runinterval}"
      }
  }
  else {
    # Add normal command
    cron{'run_puppet_hiera':
      command     => $command,
      user        => root,
      minute      => "*/${runinterval}",
      environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }

    # Remove noop command
    cron{'run_puppet_hiera noop':
      ensure  => absent,
      command => $command_noop,
      user    => root,
      minute  => "*/${runinterval}"
      }
  }

}

