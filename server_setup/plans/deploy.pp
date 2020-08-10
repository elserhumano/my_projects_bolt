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
      baseurl => 'https://download.copr.fedorainfracloud.org/results/konimex/neofetch/epel-7-$basearch/'
    }

    # Add epel repo
    yumrepo { 'epel':
      ensure => present,
      baseurl => 'https://download.fedoraproject.org/pub/epel/$releasever/$basearch/'
    }

    # Install packages vim, wget, ntp, neofetch
    $list_packages = ['vim','wget','ntp','neofetch']
    package { $list_packages:
      ensure => present,
    }

    # Customize vim
    file_line { 'add colot to vim':
      ensure => present,
      path   => '/root/.vimrc',
      line   => 'color murphy',
    }

    file_line { 'add tabs to vim':
      ensure => present,
      path   => '/root/.vimrc',
      line   => 'set tabstop=2 shiftwidth=2 expandtab',
    }

    # Update Os to the latest version
    exec { 'yum -y update':
      provider => shell,
      unless   => 'yum -y update | grep "No packages"',
    }

    # Configure time zone Europe/Brussels
    class { 'timezone':
      timezone => 'Europe/Brussels'
    }

    # Add neofetch execution
    # Disable because afte this cannot run bolt again
#    file_line { 'add neofetch execution':
#      ensure => present,
#      path   => '/root/.bashrc',
#      line   => 'neofetch',
#    }       

    # Customize root prompt
    file_line { 'add root prompt':
      ensure => present,
      path   => '/root/.bashrc',
      line   => "PS1='\\[\\033[1;36m\\]\\u\\[\\033[1;31m\\]@\\[\\033[1;32m\\]\\h:\\[\\033[1;35m\\]\\w\\[\\033[1;31m\\]\\n\\$ \\[\\033[0m\\]'",
      match  => 'PS1=',
    }       
  }
}

