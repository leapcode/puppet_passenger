class passenger::apache{
  include apache
  package{'mod_passenger':
    ensure => installed,
    require => Package['apache'],
  }
}
