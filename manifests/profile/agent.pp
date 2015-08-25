class sys11puppet::profile::agent(
  $puppet_master = hiera('sys11puppet::common::puppet_master', $::puppet_master),
  $runstyle = hiera('sys11puppet::agent::runstyle', 'service'),
  $runinterval = hiera('sys11puppet::agent::runinterval'),
  $noopvalue = hiera('sys11puppet::agent::noop'),
  $clientclean = hiera('sys11puppet::master::clientclean', false),
  $include_base_path = hiera('repodeploy::include_base_path', '/opt/puppet-modules-vcsrepo'),
  $repos = hiera('sys11puppet::master::repos', false),
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

  class {'sys11puppet::profile::agent::clientclean':
      enable => $clientclean,
  }
}

