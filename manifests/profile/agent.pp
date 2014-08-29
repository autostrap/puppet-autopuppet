class sys11puppet::profile::agent(
  $puppet_master = hiera('sys11puppet::common::puppet_master'),
  $runinterval = hiera('sys11puppet::agent::runinterval'),
  $noopvalue = hiera('sys11puppet::agent::noop'),
  $clientclean = hiera('sys11puppet::master::clientclean', false),
) {

  class {'puppet::agent':
    puppet_server       => "$puppet_master",
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

  if $clientclean {
    class {'sys11puppet::profile::agent::clientclean': }
  }
}

