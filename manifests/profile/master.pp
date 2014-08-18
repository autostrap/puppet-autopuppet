class sys11puppet::profile::master(
  $puppet_master = hiera('sys11puppet::common::puppet_master'),
  $config_path = hiera('sys11puppet::master::config_path'),
  $reporturl = hiera('sys11puppet::master::reporturl'),
  $reports = hiera('sys11puppet::master::reports'),
  $modulepath = hiera('sys11puppet::master::modulepath'),
  $repos = hiera('sys11puppet::master::repos', false)
) {
  # TODO put this in own class?
  define copy_directory(
    $source) {
    $path = split($title, '/')
    file { "/opt/puppet-modules-vcsrepo/${path[-1]}":
      ensure  => directory,
      source  => "$source/$title",
      recurse => true,
    }
  }

  define deploy_repo($repos) {
    if $repos[$name]['provider'] {
      $provider = $repos[$name]['provider']
    } else {
      $provider = 'git'
    }

    if $repos[$name]['source'] {
      $source = $repos[$name]['source']
    } else {
      fail('You need to provide a source as parameter!')
    }
    vcsrepo { $name:
      ensure   => present,
      provider => $provider,
      source   => $source,
    }

    if $repos[$name]['include'] {
      file {'/opt/puppet-modules-vcsrepo':
        ensure => directory,
      }
      copy_directory { $repos[$name]['include']:
        source  => $name,
        require => Vcsrepo[$name],
      } 
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
    source => "module:///modules/${module_name}/puppetmaster_site.pp",
  }

  if $repos {
    $repos_keys = keys($repos)
    deploy_repo { $repos_keys:
      repos => $repos,
    }
  }
}
