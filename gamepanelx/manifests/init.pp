# GamePanelX
# Written by Ryan Gehrig <ryan@gamepanelx.com>
# Jan 1, 2016

# Base class for both master/remotes
class gamepanelx {
	case $operatingsystem {
	  'RedHat', 'CentOS': { 
	    $pkgs = [ 'screen','glibc.i686','libstdc++.i686','libgcc_s.so.1','libgcc.i686','java-1.7.0','wget','unzip','expect' ]
	  }
	  /^(Debian|Ubuntu)$/:{ 
	    $pkgs = [ 'lib32bz2','lib32ncurses5','lib32tinfo5','lib32z1','libc6','libstdc++6','expect' ]
	  }
	  default: { 
	    warning('This module does not support this OS.  You must ensure your own dependencies are setup!')
	    $pkgs = [ ]
	  }
	}

	# Install packages
	$pkgs.each |String $pkg| {
	  package { $pkg:
	    ensure => installed
	  }
	}
}

# GPX Master
class gamepanelx::master inherits gamepanelx {
	case $operatingsystem {
          'RedHat', 'CentOS': {
            $pkgs = [ 'httpd','php','php-mysql','php-bcmath','php-posix','php-common','php-curl','mysql','mysql-server' ]
          }
          /^(Debian|Ubuntu)$/:{
            $pkgs = [ 'php5-mysql ','php5-common' ]
          }
          default: {
            warning('This module does not support this OS.  You must ensure your own dependencies are setup!')
            $pkgs = [ ]
          }
        }

        # Install packages
        $pkgs.each |String $pkg| {
          package { $pkg:
            ensure => installed
          }
        }

	#####################################

	# Start services
        service {'mysqld':
          ensure  => running,
          enable  => true,
          require => Package['mysql-server'],
        }
	service {'httpd':
          ensure  => running,
          enable  => true,
          require => Package['httpd'],
        }
	
	# Secure MySQL, set random root pass
	file { "/tmp/secure_mysql.sh":
	    ensure => present,
	    mode   => 0755,
	    owner  => root,
	    group  => root,
	    source => "puppet:///modules/gamepanelx/secure_mysql.sh"
	}
	exec { 'secure_mysql':
	  command => 'secure_mysql.sh',
	  path    => '/tmp'
	  require => [ Service['mysqld'],File['/tmp/secure_mysql.sh'] ],
	}

	




}

# GPX Remotes
class gamepanelx::remote inherits gamepanelx {
	# ...
}
