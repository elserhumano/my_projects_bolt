plan server_setup::mgmt_puppet
(
  TargetSpec $nodes,
)
{
  # Install the puppet-agent package if Puppet is not detected.
  # Copy over custom facts from the Bolt module path.
  # Run the `facter` command line tool to gather target information.
  $nodes.apply_prep

  # Compile the manifest block into a catalog
  apply($nodes) {

    # Add repo's for install application's see hiera
    $repositories = lookup('mgmt_puppet::repositories')
    $repositories.each | String $repo, $values | {
      yumrepo { $repo:
        ensure  => $values['ensure'],
        baseurl => $values['baseurl'],
      }
    }

    # Install packages see hiera
    $packages = lookup('mgmt_puppet::packages')
    $packages.each | String $pack | {
      package { $pack:
        ensure => present,
      }
    }
  }
}

