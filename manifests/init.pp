# Simple module uses hiera hashes with basic iteration to implement many
# resource types.  This enables management of many system components
# without dedicated puppet modules.
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

  # Iterate over all module parameters
  lookup(basic::params).each |String $param| {
    case $param {
      'notifications': {
        Basic::Type { 'notify':
          hash => $notifications
        }
      }
      'schedules': {
        Basic::Type { 'schedule':
          hash => $schedules
        }
      }
      'stages': {
        Basic::Type { 'stage':
          hash => $stages
        }
      }
      'binary': {
        Basic::Binary { keys($binary):
          properties => $binary
        }
      }
      default: {
        Basic::Type { $param:
          hash => getvar("basic::${param}")
        }
      }
    }
  }
}

