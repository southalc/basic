#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Types](#types)
1. [Feedback](#feedback)
1. [Development](#development)

## Description

Enable management of many system components without dedicated puppet modules.
This module supports ALL the [native puppet 5.5 types](https://puppet.com/docs/puppet/5.5/type.html),
the ['file_line' type](https://forge.puppet.com/puppetlabs/stdlib/5.2.0/types#file_line)
from puppetlabs/stdlib, the ['archive type'](https://forge.puppet.com/puppet/archive#archive)
from puppet/archive, and the local defined type ['binary'](#types).  With
version 0.4.0 the implementation has been updated to drop the legacy
'create_resources' in favor of each() style iteration, while maintaining the
same module behaviour.

All resource types are used as module parameters of the same name with exceptions
for the metaparameters 'notify', 'schedule', and 'stage'.  The module parameters
for these types are:
* $notifications  =  notify
* $schedules      =  schedule
* $stages         =  stage

All module parameters are initialized as empty hashes by default, with merge
strategy set to hash to be easily managed from hiera.  Resources are created
as defined by the merged hiera hash for the module parameters.  If there is
nothing defined in hiera, the module does nothing.

## Usage

Define resources in hiera.  Many puppet modules only perform simple tasks like
installing packages, configuring files, and starting services.  Since this module
can do all these things and more, it's possible to replace the functionality of
MANY modules by using this one and defining resources in hiera.

Use [relationship metaparameters](https://puppet.com/docs/puppet/6.6/lang_relationships.html#reference-2871)
to order resource dependencies.  A typical application will have 'package', 'file',
and 'service' resources, and the logical order would have the file resource(s)
'require' the package, and either have the service resource 'subscribe'
to the file resource(s) or have the file resource(s) 'notify' the corresponding
service.

Example - This deployment of the name service caching daemon demonstrates installation
of a package, configuration of a file, and a refresh of the service when the configuration
file chagnes.
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

The 'basic::binary' defined type works like the standard 'file' type and uses all
the same attributes, but the attributes must be passed to the type as a hash with
the parameter name 'properties'.  The other significant difference against the
'file' type is that the 'content' attribute of a binary type must be a base64
encoded string.

The 'basic::type' defined type replaces create_resources() by using abstracted
resource types as [documented here.](https://puppet.com/docs/puppet/5.5/lang_resources_advanced.html)
This should be invoked by the resource type being created with a '$hash' parameter
containing the properties of the resource.

For both 'basic::binary' and 'basic::type', an optional 'defaults' hash may be
passed which could be useful in reducing the amount of data needed when declaring
many resources with similar attributes.

## Feedback

Please use the [project wiki on github](https://github.com/southalc/basic/wiki) for feedback, questions, or to share your creative use of this module.

## Development

This module is under lazy development and is unlikely to get much attention.
That said, it's pretty simple and unlikely to need much upkeep.

