class autopuppet::profile::agent::clientclean(
  $puppet_master = hiera('autopuppet::common::puppet_master', $::puppet_master),
  $enable = false,
) {
  $cleanup_script = '/etc/init/puppetmaster-clean-certificate.conf'

  if $::fqdn != $puppet_master and $enable == true {
    file {$cleanup_script:
      ensure  => file,
      content => template("$module_name/upstart/puppetmaster-clean-certificate.conf.erb"),
    }
  }

  if $enable == false {
    file {$cleanup_script:
      ensure => absent,
      }
  }
}
