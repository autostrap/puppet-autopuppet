class autopuppet::profile::agent(
  $puppet_master = hiera('autopuppet::common::puppet_master', $::puppet_master),
  $runstyle = hiera('autopuppet::agent::runstyle', 'service'),
  $runinterval = hiera('autopuppet::agent::runinterval', '5'),
  $noopvalue = hiera('autopuppet::agent::noop', false),
  $clientclean = hiera('autopuppet::master::clientclean', false),
  $include_base_path = hiera('repodeploy::include_base_path', '/opt/puppet-modules-vcsrepo'),
  $repos = hiera('autopuppet::master::repos', false),
) {

  if $repos {
    $repos_keys = keys($repos)
    repodeploy::deploy_repo { $repos_keys:
      repos             => $repos,
      include_base_path => $include_base_path,
    }
  }


  class {'puppet::agent':
    puppet_server       => "$puppet_master",
    puppet_run_style    => "$runstyle",
    puppet_run_interval => "$runinterval",
  }

  Ini_setting {
      path    => $::puppet::params::puppet_conf,
      require => File[$::puppet::params::puppet_conf],
      section => 'agent',
  }

  ini_setting {'puppetagentnoop':
    ensure  => present,
    setting => 'noop',
    value   => "$noopvalue",
  }

  ini_setting {'puppetagentdiff':
    ensure  => present,
    setting => 'show_diff',
    value   => 'true',
  }

  class {'autopuppet::profile::agent::clientclean':
      enable => $clientclean,
  }
}

