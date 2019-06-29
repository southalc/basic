#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Types](#types)
1. [Feedback](#feedback)
1. [Development](#development)

## Description

Enable management of many system components without dedicated puppet modules.
This module supports all the [native puppet 5.5 types](https://puppet.com/docs/puppet/5.5/type.html),
the ['file_line' type](https://forge.puppet.com/puppetlabs/stdlib/5.2.0/types#file_line)
from puppetlabs/stdlib, the ['archive'](https://forge.puppet.com/puppet/archive#archive)
type from puppet/archive, and the local defined type ['binary'](#types).

All resource types are used as module parameters of the same name with exceptions
for the metaparameters 'notify', 'schedule', and 'stage'.  The module parameters
for these types are:
* $notifications  =  notify
* $schedules      =  schedule
* $stages         =  stage

All module parameters are initialized as empty hashes by default, with merge
strategy set to hash to be easily managed with hiera.  Resources are created
as defined by the merged hiera hash for the module parameters.

## Usage

Define resources in hiera.  Many puppet modules only perform simple tasks like
installing packages, configuring files, and starting services.  Since this module
can do all these things and more, it's possible to replace the functionality of
many modules by using this one and defining resources in hiera.

Example - This demonstrates installation of a package, configuration of a
service, and ordering of resources with 'require' and 'notify' metaparameters.
```
basic::package:
  nscd:
    ensure: 'installed'

basic::file:
  '/etc/nscd.conf':
    ensure: 'file'
    owner: 'root'
    group: 'root'
    mode: '600'
    require:
      - 'Package[nscd]'
    notify:
      - 'Service[nscd]'
    content: |
      ## FILE MANAGED BY PUPPET - LOCAL CHANGES WILL NOT PERSIST
        logfile                /var/log/nscd.log
        server-user            nscd
        debug-level            0
        paranoia               no
      
        enable-cache           hosts           yes
        positive-time-to-live  hosts           3600
        negative-time-to-live  hosts           20
        suggested-size         hosts           211
        check-files            hosts           yes
        persistent             hosts           yes
        shared                 hosts           yes
        max-db-size            hosts           33554432

basic::service:
  nscd:
    ensure: 'running'
    enable: true
    require:
      - 'Package[nscd]'
```
Example - This demonstrates use of an exec resource for reloading iptables
when the subscribed resource file is updated.
```
basic::file:
  /etc/sysconfig/iptables:
    ensure: 'file'
    owner: 'root'
    group: 'root'
    mode: '600'
    content: |
      *filter
      :INPUT DROP
      :FORWARD DROP
      :OUTPUT ACCEPT
      -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
      -A INPUT -i lo -j ACCEPT
      -A INPUT -p icmp -j ACCEPT
      -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
      COMMIT

basic::exec:
  iptables_restore:
    path: '/sbin:/usr/sbin:/bin:/usr/bin'
    command: 'iptables-restore /etc/sysconfig/iptables'
    subscribe: 'File[/etc/sysconfig/iptables]'
    refreshonly: true
```
## Types

The 'binary' defined type works like the standard 'file' type and uses all the
same parameters.  The only difference is that the 'content' attribute of a binary
type should be a base64 encoded string.

## Feedback

Please use the [project wiki on github](https://github.com/southalc/basic/wiki) for feedback, questions, or to share your creative use of this module.

## Development

This module is under lazy development and is unlikely to get much attention.
That said, it's pretty simple and unlikely to need much upkeep.

