#!/usr/bin/env ruby
# Helper methods for MediaWiki-Vagrant
#
require 'rbconfig'
require 'pathname'

## Shortcuts

$VP = Pathname.new($DIR)  # Vagrant path
$IP = $VP + 'mediawiki'   # MediaWiki path
$PP = $VP + 'puppet'      # Puppet path


# Are we running on windows?
def windows?
    RbConfig::CONFIG['host_os'] =~ /mswin|msys|mingw32|windows/i
end

# Get short SHA1 of installed MediaWiki-Vagrant, if available.
def commit
	$VP.join('.git/refs/heads/master').read[0..8] rescue nil
end

# Try to ascertain the version of VirtualBox installed on the host.
def virtualbox_version
    cmd = windows? ?
        '"%ProgramFiles%\\Oracle\\VirtualBox\\VBoxManage" -v 2>NUL' :
        'VBoxManage -v 2>/dev/null'
    `#{cmd}`[/[\d\.]+/] rescue nil
end

# If it has been a week or more since remote commits have been fetched,
# run 'git fetch origin', unless the user disabled automatic fetching.
# You can disable automatic fetching by creating an empty 'no-updates'
# file in the root directory of your repository.
def update
    unless ENV.has_key? 'MWV_NO_UPDATE' or File.exist?($VP + 'no-update')
        system('git fetch origin') if Time.now - File.mtime($VP + '.git/FETCH_HEAD') > 604800 rescue nil
    end
end


$manifest_path = File.join $DIR, 'puppet/manifests'

def roles_available
    IO.readlines(File.join $manifest_path, 'roles.pp').map { |line|
        /^[^#]*role::(\S+)/.match(line) and $1.tr(':', '#')
    }.compact.sort.uniq - ['generic', 'mediawiki']
end

def roles_enabled
    IO.readlines(File.join $manifest_path, 'manifests.d/vagrant-managed.pp').map { |line|
        /^[^#]*include role::(\S+)/.match(line) and $1.tr(':', '#')
    }.compact.sort.uniq rescue []
end

def update_roles(roles)
    File.open(File.join($manifest_path, 'manifests.d/vagrant-managed.pp'), 'w') { |f|
        f.puts '# This file is managed by Vagrant. Do not edit.'
        f.puts '# Use "vagrant list-roles / enable-role / disable-role" instead.'
        f.puts roles.sort.uniq.map { |r|
            "include role::#{r.gsub(/^role::/, '')}"
        }.join("\n")
    }
end

# Migrate the content of old 'Roles' / 'Roles.yaml' files
[$VP + 'Roles', $VP + 'Roles.yaml'].each do |roles_file|
	begin
		roles = IO.readlines(roles_file).map { |line|
			/^[^#]*role::(\S+)/.match(line) and $1
		}.compact.sort.uniq - ['generic', 'mediawiki']
		update_roles(roles + roles_enabled)
		File.delete(roles_file)
	rescue Errno::ENOENT
		# OK -- nothing to migrate.
	end
end
