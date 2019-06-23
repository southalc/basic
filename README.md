#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Development](#development)

## Description

Enable management of many system components without dedicated puppet modules.
This module includes all the puppet 5.5 types plus the 'file_line' from the
stdlib module (except metaparameters 'notify', 'schedule', and 'stage').

All resource types are used as module parameters of the same name, and are
initialized as empty hashes by default, with merge strategy set to hash to
be extensible and easy to override in hiera.

## Usage

Define resources in hiera.  Many puppet modules only perform simple tasks like
installing packages, configuring files, and starting services.  Here is an
example to show how this single module can replace many single-purpose modules.

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

simple::exec:
  iptables_restore:
    path: '/sbin:/usr/sbin:/bin:/usr/bin'
    command: 'iptables-restore /etc/sysconfig/iptables'
    subscribe: 'File[/etc/sysconfig/iptables]'
    refreshonly: true
```
## Development

This module is under lazy development and is unlikely to get much attention.

