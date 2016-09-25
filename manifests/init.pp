# Class: golang
#
# Install golang (go) so you can execute or compile go.
#

class golang (
  $version    = '1.7.1',
  $workdir    = '/usr/src/go',
  $installdir = '/usr/local',
){

  if ! defined(Package['curl']) { package { 'curl': } }
  if ! defined(Package['tar'])  { package { 'tar': } }
  if ! defined(Package['grep'])  { package { 'grep': } }
  if ! defined(Package['which'])  { package { 'which': } }

  Exec {
    path => "${installdir}/go/bin:/usr/local/bin:/usr/bin:/bin",
  }

  $kernel = downcase($::kernel)

  $arch = $::architecture ? {
    'x86_64' => 'amd64',
    'i386'   => '386',
    default  => $::architecture
  }

  file { '/opt/puppetlabs/facter/facts.d/golang.yaml':
    ensure  => present,
    content => "---\ngoversion: ${version}\ngopath: ${workdir}\ngoroot: ${installdir}/go\n",
    path    => '/opt/puppetlabs/facter/facts.d/golang.yaml',
  }

  $url =  "https://storage.googleapis.com/golang/go${version}.${kernel}-${arch}.tar.gz"

  file { [$workdir,
          "${workdir}/src",
          "${workdir}/pkg",
          "${workdir}/bin" ]:
      ensure  => directory,
  }

  exec { 'download':
    command => "curl -o /tmp/go-${version}.tar.gz ${url}",
    creates => "/tmp/go-${version}.tar.gz",
    unless  => "which go && go version | grep ' go${version} '",
    require => [ Package['curl'], Package['grep'], Package['which']],
  }

  exec { 'unarchive':
    command => "tar -C ${installdir} -xzf /tmp/go-${version}.tar.gz && rm /tmp/go-${version}.tar.gz",
    onlyif  => "test -f /tmp/go-${version}.tar.gz",
    require => Package['tar'],
  }

  exec { 'remove-previous':
    command => "rm -rf ${installdir}/go",
    onlyif  => [
      "test -f /tmp/go-${version}.tar.gz",
    ],
    before  => Exec['unarchive'],
    require => [ Package['grep'], Package['which']],
  }

  file { '/etc/profile.d/golang.sh':
    content => template('golang/etc/profile.d/golang.sh'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

}
