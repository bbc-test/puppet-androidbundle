# == Class: androidbundle
#
# This class is used to install the android SDK development bundle and platform tools
#
# === Authors
#
# Paul Carey <paul.carey@ignition.it>
#
class androidbundle() {

  package { "unzip" : }

  archive { 'adt':
    ensure => present,
    extension => "zip",
    checksum => false,
    url    => 'http://dl.google.com/android/adt/22.6.2/adt-bundle-linux-x86_64-20140321.zip',
    target => '/opt/adt',
    require => Package["unzip"]
  }

  exec { "mv eclipse" :
      command => "/bin/mv /opt/adt/adt-bundle-linux-x86_64-20140321/eclipse /opt/adt/eclipse",
      require => Archive["adt"],
  }

  exec { "mv sdk" :
    command => "/bin/mv /opt/adt/adt-bundle-linux-x86_64-20140321/sdk /opt/adt/sdk",
    require => Archive["adt"],
  }

  exec { "/bin/rmdir /opt/adt/adt-bundle-linux-x86_64-20140321" :
      require => [Exec['mv eclipse'],Exec['mv sdk']]
  }
}
