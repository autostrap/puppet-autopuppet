class autopuppet::profile::masterless(
  $runinterval = hiera('autopuppet::masterless::runinterval', 5),
  $noopvalue = hiera('autopuppet::masterless::noop', false),
) {
    $command_noop = '/usr/local/sbin/run_puppet_hiera --noop --logdest syslog >/dev/null 2>&1'
    $command = '/usr/local/sbin/run_puppet_hiera --logdest syslog >/dev/null 2>&1'
    $path = 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

  if $noopvalue {
    # Remove normal command
    cron{'run_puppet_hiera':
      ensure  => absent,
      command => "$path $command",
      user    => root,
      minute  => "*/${runinterval}"
      }

    # Add noop command
    cron{'run_puppet_hiera noop':
      command     => "$path $command_noop",
      user        => root,
      minute      => "*/${runinterval}"
      }
  }
  else {
    # Add normal command
    cron{'run_puppet_hiera':
      command     => "$path $command",
      user        => root,
      minute      => "*/${runinterval}",
      }

    # Remove noop command
    cron{'run_puppet_hiera noop':
      ensure  => absent,
      command => "$path $command_noop",
      user    => root,
      minute  => "*/${runinterval}"
      }
  }

}

