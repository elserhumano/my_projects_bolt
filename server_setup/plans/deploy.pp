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

  # Add user's as member of wheel and assign ssh_authorized_key
  $users = lookup('users')
  $users.each | String $user, $values | {
      user { $user:
        ensure     => $values['ensure'],
        groups     => $values['groups'],
        membership => $values['membership'],
      }

      # Add public key to user
      ssh_authorized_key { $values['name']:
        ensure => $values['ensure'],
        user   => $user,
        type   => $values['type'],
        key    => $values['key'],
      }
  }
  
    # Add special users
    $special_users = lookup('special_users')
    $special_users.each | String $special_user, $values | {
      user { $special_user:
        ensure => $values['ensure'],
        groups => $values['groups'],
        membership => $values['membership'],
      }
    }

    # Enable members wheel do sudo without password
    sudo::conf { 'wheel':
      ensure  => present,
      content => '%wheel ALL=(ALL) NOPASSWD: ALL',
    }

    # Disable SELinux
    class { 'selinux':
      mode => 'permissive',
      type => 'targeted',
    }

    # Disable and stop services
    $unservices = lookup('unservices')
    $unservices.each | String $unservice | {
      service { $unservice:
        ensure => stopped,
        enable => false,
      }
    }

    # Uninstall package's
    $unpackages = lookup('unpackages')
    $unpackages.each | String $unpack | {
      package { $unpack:
        ensure => absent,
      }
    }

    # Add repo's for install application's
    $repositories = lookup('repositories')
    $repositories.each | String $repo, $values | {
      yumrepo { $repo:
        ensure   => $values['ensure'],
        baseurl  => $values['baseurl'],
        gpgcheck => $values['gpgcheck'],
      }
    }

    # Install packages vim, wget, ntp, neofetch
    $packages = lookup('packages')
    $packages.each | String $pack | {
      package { $pack:
        ensure => present,
      }
    }

    # Asure the files .bashrc and .vimrc exist
    $files = lookup('files')
    $files.each | String $the_file | {
      file { $the_file:
        ensure => present,
      }
    }

    # Customize vimrc and bashrc
    $file_lines = lookup('file_lines')
    $file_lines.each | String $name, $values | {
      file_line { $name:
        ensure  => $values['ensure'],
        path    => $values['path'],
        line    => $values['line'],
        match   => $values['match'],
        require => File[$values['path']]
      }
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
  }
}

