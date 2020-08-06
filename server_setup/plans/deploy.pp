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
    ssh_authorized_key { 'notebook':
      ensure  => present,
      user    => 'fernando',
      type    => 'ssh-rsa',
      key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQCskr4gKnrzHBF9f0xCMKlA88rfPipeE5Kg0bh51mhyBTvJxp9RvPY2j1idmvzGGrYcMRSik6r9Kd5Ga5lC8RTXVPZPBLMv8DP16K6r5iXnEr1M+qdT4Klg87S5v1Sl4YvV4sEw3VJRU2AC4NpJGRYmbMMNaB/wTRa7wqEN+3wUdOZmGIsSMr4VR6t6Efx0VmUgLZXkUdRJ+m8YCSDiiy4juGY52KlXexDKcF0z5SfQZzCh643SuP66w4F62+z5F0K5k41dMwbyGtI3rmxitvnID4vOR1FOwA9rLnWsrnQdrmaMxkB+P3WT27bxOc8l/aVl1/dc1dA3l7eOHUTdrTw1UCjOY1gmHhQZMTED3qVBK1tbPrdATR2+gMAywCXiNZmgQ8tKWZ804ACc+prlsclIQoIGr/oJUDZYcQg19WwARWphbeDyv70Z3PMSdcUztkmWZ00jwfP0EDCckRKsQ/i4I0mfC4y1zIPAnyn7LN+2jnCalxsEh5DSIHhQSSnYxMk=',
      require => User['fernando'],
    }

    # Uninstall package chrony
    package { 'chrony':
      ensure => absent,
    }

    # Add repo to install neofetch
    yumrepo { 'konimex-neofetch-epel-7':
      ensure  => present,
      baseurl => 'https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo'
    }


    # Add epel repo

    # Install packages vim, wget, ntp, neofetch

    # Customize vim

    # Update Os to the latest version

    # Configure time zone Europe/Brussels

    # Add neofetch execution

    # Customize root prompt

  }
}
