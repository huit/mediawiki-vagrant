# == Class: apache
#
# Configures Apache HTTP Server
#
class apache {
    package { 'apache2':
        ensure  => present,
    }

    package { 'libapache2-mod-php5':
        ensure => present,
    }

    file { '/etc/apache2/ports.conf':
        content => template('apache/ports.conf.erb'),
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    # Set EnableSendfile to 'Off' to work around a bug with Vagrant.
    # See <https://github.com/mitchellh/vagrant/issues/351>.
    apache::conf { 'disable sendfile':
        content => 'EnableSendfile Off',
    }

    file { '/etc/apache2/site.d':
        ensure  => directory,
        require => Package['apache2'],
    }

    service { 'apache2':
        ensure     => running,
        provider   => 'init',
        require    => Package['apache2'],
        hasrestart => true,
    }

     Apache::Mod <| |>
     Apache::Conf <| |>
     Apache::Site <| |>
}
