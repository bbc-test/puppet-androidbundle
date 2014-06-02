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
    timeout => 1800,
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

  exec { "tidy" :
      command => "/bin/rmdir /opt/adt/adt-bundle-linux-x86_64-20140321",
      require => [Exec['mv eclipse'],Exec['mv sdk']]
  }


  exec { 'chown' :
    command => "/bin/chown -R vagrant:vagrant /opt/adt/",
    require => Exec["tidy"]
  }

  exec { 'chmod' :
      command => "/bin/chmod -R 755 /opt/adt/",
      require => Exec['chown']
  }

  exec { 'add paths' :
    command => "/bin/sh -c 'echo PATH=\"\$PATH:/opt/adt/sdk/tools:/opt/adt/sdk/platform-tools\" >> /etc/profile'",
    require => [Exec['mv eclipse'],Exec['mv sdk']]
  }

  if $lsbdistrelease == 14.04 {
    ensure_packages(["libc6-i386", "lib32stdc++6", "lib32gcc1", "lib32ncurses5", "lib32z1"])
  }

}
