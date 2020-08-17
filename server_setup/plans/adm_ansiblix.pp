plan server_setup::adm_ansiblix
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

  # Add root ssh_authorized_key
  $keys = lookup('adm_ansiblix::keys')

  $keys.each | String $name, $values | {
    ssh_authorized_key { 'key_name':
      ensure => $values['ensure'],
      user   => $name,
      type   => $values['type'],
      key    => $values['key'],
    }
  }
 }
}

