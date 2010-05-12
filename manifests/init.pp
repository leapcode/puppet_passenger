# passenger module
#
# Copyright 2010, Riseup Networks
# Micah Anderson micah(at)riseup.net
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.

class passenger {
  
  case $operatingsystem {
    debian: { include passenger::debian }
    default: { include passenger::base }
  }

  if $use_munin {
    include passenger::munin
  }  

}
