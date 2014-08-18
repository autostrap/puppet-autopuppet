class sys11puppet::profile::master(
  $puppet_master = hiera('sys11puppet::common::puppet_master'),
  $config_path = hiera('sys11puppet::master::config_path'),
  $reporturl = hiera('sys11puppet::master::reporturl'),
  $reports = hiera('sys11puppet::master::reports'),
  $modulepath = hiera('sys11puppet::master::modulepath'),
  $repos = hiera('sys11puppet::master::repos', false),
  $include_base_path = hiera('repodeploy::include_base_path', '/opt/puppet-modules-vcsrepo'),
) {
  if $repos {
    $repos_keys = keys($repos)
    repodeploy::deploy_repo { $repos_keys:
      repos             => $repos,
      include_base_path => $include_base_path,
    }
  }

  class { 'puppetdb':
    max_threads => '150',
  }
  
  class {'puppet::master':
    storeconfigs => true,
    modulepath   => join($modulepath, ':'),
    autosign     => true,
    reporturl    => $reporturl,
    reports      => $reports,
  }

  file {'/etc/puppet/hieradata':
    ensure => link,
    force  => true,
    target => "${config_path}/puppet/hieradata",
  }

  file {'/etc/puppet/hiera.yaml':
    ensure => link,
    force  => true,
    target => "${config_path}/puppet/hiera.yaml",
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
