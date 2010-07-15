class passenger::base {

  include apache
  
  apache::config::file { 'mod_passenger':
    ensure => present,
    source => [ "puppet://${server}/modules/site-passenger/${fqdn}/mod_passenger.conf",
                "puppet://${server}/modules/site-passenger/mod_passenger.conf",
                "puppet://${server}/modules/passenger/mod_passenger.conf",
              ],
  }

}
