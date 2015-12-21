class autopuppet::profile::dashboard(
  $mysql_root_password = hiera('autopuppet::dashboard::mysql_root_password'),
  $mysql_user = hiera('autopuppet::dashboard::mysql_user'),
  $mysql_password = hiera('autopuppet::dashboard::mysql_password'),
) {
  class { '::mysql::server':
      root_password => $mysql_root_password,
  }

  mysql::db { puppet-dashboard:
    user     => "$mysql_user",
    password => "$mysql_password",
    host     => 'localhost',
    require  => Class['mysql::server'],
  }

  package {'puppet-dashboard':
    ensure  => installed,
    require => Class['mysql::server'],
  } ->

  file {'/etc/puppet-dashboard/database.yml':
    ensure    => file,
    content => "production:
      database: puppet-dashboard
      username: $mysql_user
      password: $mysql_password
      encoding: utf8
      adapter: mysql
      ",
  } ~>

  exec {'rake-migrate':
    path        => '/usr/bin/:/bin/',
    cwd         => '/usr/share/puppet-dashboard',
    command     => 'rake RAILS_ENV=production db:migrate',
    refreshonly => true,
  } ->

  file_line { 'init puppet-dashboard':
    line    => 'START=yes',
    path    => '/etc/default/puppet-dashboard',
    notify  => Exec['start-puppet-dashboard'],
  } ->

  file_line { 'init puppet-dashboard-workers':
    line    => 'START=yes',
    path    => '/etc/default/puppet-dashboard-workers',
    notify  => Exec['start-puppet-dashboard-workers'],
  } ->

  exec {'start-puppet-dashboard':
    path        => '/usr/bin/:/bin/:/sbin/:/usr/sbin/',
    command     => '/etc/init.d/puppet-dashboard start',
    refreshonly => true,
  }

  exec {'start-puppet-dashboard-workers':
    path        => '/usr/bin/:/bin/:/sbin:/usr/sbin/',
    command     => '/etc/init.d/puppet-dashboard-workers start',
    refreshonly => true,
  }
}
