**Note:** Forked from https://gerrit.wikimedia.org/r/mediawiki/vagrant so we have a copy.  This is a comprehensive and powerful Vagrant environment for MediaWiki development, and offers many good ideas for how to provide such a construct at Harvard.

***

## MediaWiki-Vagrant

http://www.mediawiki.org/wiki/Mediawiki-vagrant

MediaWiki-Vagrant is a portable MediaWiki development environment. It consists
of a set of configuration scripts that automate the creation of a virtual
machine that runs MediaWiki.

The virtual machine that MediaWiki-Vagrant creates makes it easy to learn
about, modify, and improve MediaWiki's code: useful debugging information is
displayed by default, and various developer tools are set up specifically for
inspecting and interacting with MediaWiki code, including a powerful debugger
and an interactive interpreter. Best of all, because the configuration is
automated and contained in a virtual environment, mistakes are easy to undo.


## Install

You'll need to install recent versions of Vagrant and VirtualBox.

 * VirtualBox: https://www.virtualbox.org/wiki/Downloads
 * Vagrant: http://downloads.vagrantup.com/ (version 1.2.2 or higher is
   required!)

Next, you'll need a copy of the mediawiki-vagrant project files.

 * zip: https://github.com/wikimedia/mediawiki-vagrant/archive/master.zip
 * tar.gz: https://gerrit.wikimedia.org/r/gitweb?p=mediawiki/vagrant.git;a=snapshot;h=HEAD;sf=tgz
 * Git: `git clone https://gerrit.wikimedia.org/r/mediawiki/vagrant`

If you download the zip file or tarball, you will need to extract it to a
directory of your choice. Once you do that, open up a terminal or a
command-prompt, and change your working directory to the location of the
extracted (or git-cloned) files. From there, run `vagrant up` to provision and
boot the virtual machine.

You'll now have to wait a bit, as Vagrant needs to retrieve the base image from
Canonical, retrieve some additional packages, and install and configure each of
them in turn.

If it all worked, you should be able to browse to http://127.0.0.1:8080/ and
see the main page of your MediaWiki instance.


## Use

To access a command shell on your virtual environment, run `vagrant ssh` from
the root mediawiki-vagrant directory or any of its subdirectories.

From there, run `phpsh` to interactively evaluate PHP code in a MediaWiki
context, or `mysql` to get an authenticated SQL shell on your wiki's database.

The admin account on MediaWiki is `admin` / `vagrant`.


## Update

When the vagrant Virtual Machine is running, it will periodically run Puppet
(an open source configuration management tool) to update its configuration,
which keeps various software packages up to date. To avoid clobbering any
changes you may have made to MediaWiki's source code, Puppet will not update
MediaWiki.

To pick up other changes to the install, on the host computer in the directory
with the vagrant files run `git pull` and then `vagrant reload`.  The latter
will restart the VM.

## Settings

For information about settings, see settings.d/README.

## Troubleshoot

Stuck? Here's where to get help.

 * http://www.mediawiki.org/wiki/Mediawiki-Vagrant#Troubleshooting
 * irc://chat.freenode.net/#mediawiki

Please report any bugs on Wikimedia's Bugzilla:
https://bugzilla.wikimedia.org/enter_bug.cgi?product=Tools&component=Vagrant

Patches and contributions are welcome!
See <http://www.mediawiki.org/wiki/How_to_become_a_MediaWiki_hacker> for details.
