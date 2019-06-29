# Simple module uses hiera hashes with create_resources for many resource types.
# Enables management of many system components without dedicated puppet modules.
#
# All the native puppet 5.5 types, 'file_line' from puppetlabs/stdlib, and 'archive'
# from puppet/archive are included.  The module parameters for native types 'notify',
# 'schedule', and 'stage' are renamed to avoid conflict with their use as metaparamenters,
# and instead use the parameter names: 'notifications', 'schedules', and 'stages'.
#
# - https://puppet.com/docs/puppet/5.5/type.html
# - https://forge.puppet.com/puppetlabs/stdlib
# - https://forge.puppet.com/puppet/archive#archive
#
# The local 'binary' type allows binary files to be created using the same type
# attributes as 'file', with the difference being that the 'content' must be a
# base64 encoded string.

class basic (
  Hash $augeas,
  Hash $computer,
  Hash $cron,
  Hash $exec,
  Hash $file,
  Hash $filebucket,
  Hash $group,
  Hash $host,
  Hash $interface,
  Hash $k5login,
  Hash $macauthorization,
  Hash $mailalias,
  Hash $maillist,
  Hash $mcx,
  Hash $mount,
  Hash $nagios_command,
  Hash $nagios_contact,
  Hash $nagios_contactgroup,
  Hash $nagios_host,
  Hash $nagios_hostdependency,
  Hash $nagios_hostescalation,
  Hash $nagios_hostextinfo,
  Hash $nagios_hostgroup,
  Hash $nagios_service,
  Hash $nagios_servicedependency,
  Hash $nagios_serviceescalation,
  Hash $nagios_serviceextinfo,
  Hash $nagios_servicegroup,
  Hash $nagios_timeperiod,
  Hash $notifications,
  Hash $package,
  Hash $resources,
  Hash $router,
  Hash $schedules,
  Hash $scheduled_task,
  Hash $seboolean,
  Hash $selmodule,
  Hash $service,
  Hash $ssh_authorized_key,
  Hash $sshkey,
  Hash $stages,
  Hash $tidy,
  Hash $user,
  Hash $vlan,
  Hash $yumrepo,
  Hash $zfs,
  Hash $zone,
  Hash $zpool,
  Hash $file_line,
  Hash $archive,
  Hash $binary,
) {

  # Native puppet resources
  create_resources('Augeas',$augeas)
  create_resources('Computer',$computer)
  create_resources('Cron',$cron)
  create_resources('Exec',$exec)
  create_resources('File',$file)
  create_resources('Filebucket',$filebucket)
  create_resources('Group',$group)
  create_resources('Host',$host)
  create_resources('Interface',$interface)
  create_resources('K5login',$k5login)
  create_resources('Macauthorization',$macauthorization)
  create_resources('Mailalias',$mailalias)
  create_resources('Maillist',$maillist)
  create_resources('Mcx',$mcx)
  create_resources('Mount',$mount)
  create_resources('Nagios_command',$nagios_command)
  create_resources('Nagios_contact',$nagios_contact)
  create_resources('Nagios_contactgroup',$nagios_contactgroup)
  create_resources('Nagios_host',$nagios_host)
  create_resources('Nagios_hostdependency',$nagios_hostdependency)
  create_resources('Nagios_hostescalation',$nagios_hostescalation)
  create_resources('Nagios_hostextinfo',$nagios_hostextinfo)
  create_resources('Nagios_hostgroup',$nagios_hostgroup)
  create_resources('Nagios_service',$nagios_service)
  create_resources('Nagios_servicedependency',$nagios_servicedependency)
  create_resources('Nagios_serviceescalation',$nagios_serviceescalation)
  create_resources('Nagios_serviceextinfo',$nagios_serviceextinfo)
  create_resources('Nagios_servicegroup',$nagios_servicegroup)
  create_resources('Nagios_timeperiod',$nagios_timeperiod)
  create_resources('Notify',$notifications)
  create_resources('Package',$package)
  create_resources('Resources',$resources)
  create_resources('Router',$router)
  create_resources('Schedule',$schedules)
  create_resources('Scheduled_task',$scheduled_task)
  create_resources('Seboolean',$seboolean)
  create_resources('Selmodule',$selmodule)
  create_resources('Service',$service)
  create_resources('Ssh_authorized_key',$ssh_authorized_key)
  create_resources('Sshkey',$sshkey)
  create_resources('Stage',$stages)
  create_resources('Tidy',$tidy)
  create_resources('User',$user)
  create_resources('Vlan',$vlan)
  create_resources('Yumrepo',$yumrepo)
  create_resources('Zfs',$zfs)
  create_resources('Zone',$zone)
  create_resources('Zpool',$zpool)

  # Resources provided by modules
  create_resources('File_line',$file_line)
  create_resources('Archive',$archive)

  # locally defined types
  Basic::Binary { keys($binary):
    properties => $binary,
  }

}

