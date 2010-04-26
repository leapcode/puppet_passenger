# passenger module
#
# Copyright 2010, Riseup Networks
# Micah Anderson micah(at)riseup.net
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# If you need to install a specific version of passenger or
# librack-ruby, you can specify the version to be installed by
# providing a variable, for example:
#
# $passenger_ensure_version = "2.2.3-2~bpo50+1"
# $librack-ruby_ensure_version = "1.0.0-2~bpo50+1"

class passenger {

  if !defined(Package["libapache2-mod-passenger"]) {
    if $passenger_ensure_version == '' { $passenger_ensure_version = 'installed' }
    package {
      "libapache2-mod-passenger":
        ensure => $passenger_ensure_version;
    }
  }
  if !defined(Package["librack-ruby"]) {
    if $librack-ruby_ensure_version == '' { $librack-ruby_ensure_version = 'installed' }
    package {
    "librack-ruby":
      ensure => $librack-ruby_ensure_version;
    }
  }

  file {
    "/usr/local/share/munin-plugins/passenger_mem":
      source => [ "puppet://$server/modules/site-passenger/munin/passenger_mem",
                  "puppet://$server/modules/passenger/munin/passenger_mem" ],
      mode => 0755, owner => root, group => root;

    "/usr/local/share/munin-plugins/passenger_stats":
      source => [ "puppet://$server/modules/site-passenger/munin/passenger_stats",
                  "puppet://$server/modules/passenger/munin/passenger_stats" ],
      mode => 0755, owner => root, group => root;
  }

  munin::plugin { [ passenger_mem, passenger_stats ]:
    config => "user root",
    script_path_in => "/usr/local/share/munin-plugins";
  }
}
