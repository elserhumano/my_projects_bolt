plan server_setup::deploy
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

    # Add user fernando as member of wheel
    user { 'fernando':
      ensure     => present,
      groups     => ['wheel'],
      membership => minimum,
    }

    # Enable members wheel do sudo without password
    # puppet module install saz-sudo
    sudo::conf { 'wheel':
      ensure  => present,
      content => "%wheel ALL=(ALL) NOPASSWD: ALL",
    }

    # Add public key to fernando user

    # Uninstall package chrony

    # Add repo to install neofetch

    # Add epel repo

    # Install packages vim, wget, ntp, neofetch

    # Customize vim

    # Update Os to the latest version

    # Configure time zone Europe/Brussels

    # Add neofetch execution

    # Customize root prompt

  }
}
