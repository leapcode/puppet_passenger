# passenger module
#
# Copyright 2010, Riseup Networks
# Micah Anderson micah(at)riseup.net
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.

class passenger ( $use_gems = false, $use_munin = true )
{

  if $passenger_ensure_version == '' { $passenger_ensure_version = 'installed' }
  if $librack_ensure_version == '' { $librack_ensure_version = 'installed' }

  if $use_gems {
    package {
      "passenger":
        provider => gem,
        ensure => $passenger_ensure_version;
    }
    if !defined(Package["rack"]) {
      package {
        "rack":
          provider => gem,
          ensure => $librack_ensure_version;
      }
    }
  }
  else {
    if !defined(Package["libapache2-mod-passenger"]) {
      package {
        "libapache2-mod-passenger":
          alias => 'passenger',
          ensure => $passenger_ensure_version;
      }
    }
    if !defined(Package["librack-ruby"]) {
      package {
        [ "librack-ruby", "librack-ruby1.8"] :
          ensure => $librack_ensure_version;
      }
    }
  }
  
  apache2::module {
    "passenger": ensure => present, require_package => "passenger";
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
