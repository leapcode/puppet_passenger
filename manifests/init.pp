# passenger module
#
# Copyright 2010, Riseup Networks
# Micah Anderson micah(at)riseup.net
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.

class passenger (
  $use_gems = false, $use_munin = true,
  $passenger_ensure_version = 'installed',
  $librack_ensure_version = 'installed' )
{

  if ! $use_gems {
    class { 'apache::module':
      module => 'passenger',
      ensure => $passenger_ensure_version,
      package_name => 'libapache2-mod-passenger';
    }
    
    if !defined(Package["librack-ruby"]) {
      package {
        [ "librack-ruby", "librack-ruby1.8"] :
          ensure => $librack_ensure_version;
      }
    }
  }
  else {
    package {
      "passenger":
        provider => gem,
        ensure => $passenger_ensure_version;
      "rack":
        provider => gem,
        ensure => $librack_ensure_version;
    }
  }
  
  if $use_munin {
    case $passenger_memory_munin_config { '':
      { $passenger_memory_munin_config = "user root\nenv.passenger_memory_stats /usr/sbin/passenger-memory-stats" }
    }

    case $passenger_stats_munin_config { '':
      { $passenger_stats_munin_config = "user root\n" }
    }

    munin::plugin::deploy {
      'passenger_memory_stats':
        source => "passenger/munin/passenger_memory_stats",
        config => $passenger_memory_munin_config;
      'passenger_stats':
        source => "passenger/munin/passenger_stats",
        config => $passenger_stats_munin_config;
    }
  }
}
