class autopuppet::profile::master::main(
  $puppet_master = hiera('autopuppet::common::puppet_master', $::puppet_master),
  $config_path = hiera('autopuppet::master::config_path', undef),
  $reporturl = hiera('autopuppet::master::reporturl', ''),
  $reports = hiera('autopuppet::master::reports'),
  $modulepath = hiera('autopuppet::master::modulepath', false),
  $repos = hiera('autopuppet::master::repos', false),
  $include_base_path = hiera('repodeploy::include_base_path', '/opt/puppet-modules-vcsrepo'),
  $clientclean = hiera('autopuppet::master::clientclean', false),
  $environments = hiera('autopuppet::master::environments', 'config'),
  $masterenv = hiera('autopuppet::master::masterenv', {}),
) {
  if $repos {
    $repos_keys = keys($repos)
    repodeploy::deploy_repo { $repos_keys:
      repos             => $repos,
      include_base_path => $include_base_path,
    }
  }

  if $clientclean {
    class {'autopuppet::profile::master::clientclean':
      # stunnel won't start without the SSL certificates generated in the course of master setup.
      require => Class['::puppet::master'],
      }
  }

  # use deprecated modulepath setting for old-style config environments (dynamic)
  if $modulepath and $environments == 'config' {
    $modulepath_real = join($modulepath, ':')
  } else {
    $modulepath_real = undef
  }

  create_resources(puppet::masterenv, $masterenv)

  class { 'puppetdb':
    max_threads => '150',
  }

  class {'puppet::master':
    storeconfigs => true,
    modulepath   => $modulepath_real,
    autosign     => true,
    reporturl    => $reporturl,
    reports      => $reports,
    environments => $environments,
  }

  if $config_path {
    file {'/etc/puppet/hieradata':
      ensure => link,
      force  => true,
      target => "${config_path}/puppet/hieradata",
    }
  }

  file {'/etc/hiera.yaml':
    ensure => link,
    force  => true,
    target => '/etc/puppet/hiera.yaml',
  }

  file {'/etc/puppet/manifests/':
    ensure => directory,
  }

  file {'/etc/puppet/manifests/site.pp':
    ensure => file,
    source => "puppet:///modules/${module_name}/puppetmaster_site.pp",
  }
}
