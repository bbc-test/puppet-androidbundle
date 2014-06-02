# == Class: androidbundle
#
# This class is used to install the android SDK development bundle and platform tools
#
# === Authors
#
# Paul Carey <paul.carey@ignition.it>
#
class androidbundle(
$download_url = 'http://dl.google.com/android/adt/22.6.2/adt-bundle-linux-x86_64-20140321.zip') {

  package { "unzip" : }

  archive { 'adt':
    ensure => present,
    extension => "zip",
    checksum => false,
    url    => $download_url,
    target => '/opt/adt',
    timeout => 1800,
    require => Package["unzip"]
  }

  exec { "mv eclipse" :
    command => "/bin/mv /opt/adt/adt-bundle-linux-x86_64-20140321/eclipse /opt/adt/eclipse",
    require => Archive["adt"],
    creates => '/opt/adt/eclipse',
  }

  exec { "mv sdk" :
    command => "/bin/mv /opt/adt/adt-bundle-linux-x86_64-20140321/sdk /opt/adt/sdk",
    require => Archive["adt"],
    creates => '/opt/adt/sdk',
  }

  exec { "tidy" :
    command => "/bin/rm -rf /opt/adt/adt-bundle-linux-x86_64-20140321",
    require => [Exec['mv eclipse'],Exec['mv sdk']],
    onlyif => '/usr/bin/test -e /opt/adt/adt-bundle-linux-x86_64-20140321',
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
    require => [Exec['mv eclipse'],Exec['mv sdk']],
    onlyif => "/bin/sh -c 'echo $PATH | grep adt'"
  }

  if $lsbdistrelease == 14.04 {
    ensure_packages(["libc6-i386", "lib32stdc++6", "lib32gcc1", "lib32ncurses5", "lib32z1"])
  }

}
