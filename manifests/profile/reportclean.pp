# Ensures reports are cleaned up periodically since they will quickly use up lots of disk space.
class autopuppet::profile::reportclean(
  $clean_reports = hiera('autopuppet::clean_reports', true),
  $max_age = hiera('autopuppet::report_max_age', 4),  # Maximum allowed age for reports in days (must be >= 1).
) {
  if $clean_reports {
    cron{'cleanup-puppet-reports':
      command => "find /var/lib/puppet/reports -type f -mtime +$max_age -delete > /dev/null",
      user    => 'root',
      hour    => '3',
      minute  => '0',
    }
  } else {
    cron{'cleanup-puppet-reports':
      ensure => absent,
    }
  }

}
