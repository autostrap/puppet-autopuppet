class sys11puppet::profile::agent::clientclean(
  $puppet_master = hiera('sys11puppet::common::puppet_master'),
) {
  file {'/etc/init/puppetmaster-clean-certificate.conf':
    ensure  => file,
    content => template("$module_name/upstart/puppetmaster-clean-certificate.conf.erb"),
  }
}
