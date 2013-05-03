class passenger::apache{
    case $operatingsystem {
        centos: { include passenger::apache::centos }
        debian: { include passenger::apache::debian }
        defaults: { include passenger::apache::base }
    }
}


    
class passenger::apache::centos inherits passenger::apache::base {
  package{'mod_passenger':
    ensure => installed,
    require => Package['apache'],
  }

  file{'/var/www/passenger_buffer':
    ensure => directory,
    require => [ Package['apache'], Package['mod_passenger'] ],
    owner => apache, group => 0, mode => 0600;
  }

  file{'/etc/httpd/conf.d/mod_passenger_custom.conf':
    content => "PassengerUploadBufferDir /var/www/passenger_buffer\n",
    require => File['/var/www/passenger_buffer'],
    notify => Service['apache'],
    owner => root, group => 0, mode => 0644;
  }
}

class passenger::apache::debian inherits passenger::apache::base {
  package{'libapache2-mod-passenger':
    ensure => installed,
    require => Package['apache2'],
  }

  file{'/var/www/passenger_buffer':
    ensure => directory,
    require => [ Package['apache2'], Package['libapache2-mod-passenger'] ],
    owner => www-data, group => 0, mode => 0600;
  }

  file{'/etc/apache2/conf.d/mod_passenger_custom.conf':
    content => "PassengerUploadBufferDir /var/www/passenger_buffer\n",
    require => File['/var/www/passenger_buffer'],
    notify => Service['apache2'],
    owner => root, group => 0, mode => 0644;
  }
}

class passenger::apache::base {
   # Todo !
    include apache
}
