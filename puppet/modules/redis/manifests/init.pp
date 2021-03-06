# == Class: redis
#
# Redis is a fast in-memory key-value store, like memcached, but with
# support for rich data types. MediaWiki can use Redis as a back-end for
# the job queue.
#
# === Parameters
#
# [*max_memory*]
#   This parameter specifies the maximum amount of memory Redis will be
#   allowed to consume. Legal units include 'kb', 'mb', and 'gb'. If no
#   unit is specified, the value is measured in bytes. Default: '16mb'.
#
# [*persist*]
#   If true, redis will sync its contents to disk every 60 seconds,
#   provided at least one key has changed. If you need more granular
#   control, see the documentation for the 'settings' parameter below.
#   Default: false.
#
# [*settings*]
#   A hash-map of Redis config => value pairs. Empty by default. Its
#   contents are merged onto the default settings map and the result is
#   used to generate a redis.conf file.
#
#   For a full listing of configuration options and their meaning, see
#   <https://raw.github.com/antirez/redis/2.6/redis.conf>.
#
# === Examples
#
# If the configuration key contains a hyphen, use an underscore
# instead:
#
#  class { 'redis':
#    max_memory => '2mb',
#    settings   => {
#      maxmemory_policy => 'volatile-lru',
#      masterauth       => 'secret',
#    }
#  }
#
class redis(
    $max_memory = '16mb',
    $persist    = false,
    $settings   = {},
) {
    include redis::php

    $save = $persist ? {
        true    => [ '60', '1' ],
        default => undef,
    }

    $defaults = {
        daemonize  => 'yes',
        pidfile    => '/var/run/redis/redis-server.pid',
        logfile    => '/var/log/redis/redis-server.log',
        dir        => '/srv/redis',
        dbfilename => 'redis-db.rdb',
        maxmemory  => $max_memory,
        maxclients => 1000,
        save       => $save,
    }

    package { 'redis-server':
        ensure => '2:2.6.0-rc7-wmf1',
    }

    file { '/srv/redis':
        ensure  => directory,
        require => Package['redis-server'],
        owner   => 'redis',
        group   => 'redis',
        mode    => '0755',
    }

    file { '/etc/redis/redis.conf':
        content => template('redis/redis.conf.erb'),
        require => Package['redis-server'],
    }

    service { 'redis-server':
        ensure    => running,
        provider  => init,
        subscribe => File['/etc/redis/redis.conf'],
        require   => [
            File['/etc/redis/redis.conf', '/srv/redis'],
            Package['redis-server'],
        ],
    }
}
