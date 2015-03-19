class sys11puppet::profile::masterless(
  $runinterval = hiera('sys11puppet::masterless::runinterval', 5),
  $noopvalue = hiera('sys11puppet::agent::noop', false),
) {

  if $noop {
    $command = '/usr/local/sbin/run_puppet_hiera --logdest syslog'
  }
  else {
    $command = '/usr/local/sbin/run_puppet_hiera --logdest syslog'
  }

  cron{'run_puppet_hiera':
    command => 
    user    => root,
    minute  => "*/${runinterval}"
    }
}

