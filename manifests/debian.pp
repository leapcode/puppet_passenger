class passenger::base::debian inherits passenger::base {

  if !defined(Package["libapache2-mod-passenger"]) {
    if $passenger_ensure_version == '' { $passenger_ensure_version = 'installed' }
    apache::debian::module { 'passenger':
      ensure => $passenger_ensure_version,
      package_name => 'libapache2-mod-passenger';
    }
  }

  if !defined(Package["librack-ruby"]) {
    if $librack_ensure_version == '' { $librack_ensure_version = 'installed' }
    package {
    "librack-ruby":
      ensure => $librack_ensure_version;
    }
  }

}
