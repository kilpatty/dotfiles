#compdef gcloud
#------------------------------------------------------------
# Description:
#
#  Completion script for Google Cloud SDK
#
# Author:
#
#  * Colin Su (https://github.com/littleq0903)
#
# Source Code:
#
#  https://github.com/littleq0903/gcloud-zsh-completion
#
#------------------------------------------------------------

## Util functions

# get authorized account list
__account_list ()
{
    _wanted application expl 'Authorized Google Accounts' compadd $(command gcloud auth list 2> /dev/null | grep - | sed -e "s/^ - //g" | sed -e "s/(active)//g")
}

# get config variable names
__variable_list ()
{
    _wanted application expl 'gcloud :: config :: Configuration Variables' compadd $(command gcloud config list 2> /dev/null | grep "=" | sed -e "s/ = .*//g")
}

## Common stuffs
local -a _first_arguments
_first_arguments=(
  # these are command groups
  'auth:Manage oauth2 credentials for the Google Cloud SDK'
  'components:Install, update, or remove the tools in the Google Cloud SDK'
  'compute:Read and manipulate Google Compute Engine resources'
  'config:View and edit Google Cloud SDK properties'
  'sql:Manage Cloud SQL databases'
  # these are just commands
	'init:Initialize a gcloud workspace in the current directory'
	'interactive:Use this tool in an interactive python shell'
	'version:Print version information for Cloud SDK components'
)

# common options
common_ops=(
  {--project+,-p+}":Google Cloud Platform project to use for this invocation:( )"
  {--quiet,-q}"[Disable all interactive prompts when running gcloud commands. If input is required, defaults will be used, or an error will be raised.]"
  "--user-output-enabled+:Control whether user intended output is printed to the console.:(true false)"
  "--verbosity+:Override the default verbosity for this command. This must be a standard logging verbosity level:(debug info warning error critical none)"
)

## for 'auth' command group
# Commands
local -a _auth_arguments
_auth_arguments=(
  "activate-refresh-token:Get credentials via an existing refresh token"
  "list:List the accounts for known credentials"
  "login:Get credentials via Google's oauth2 web flow"
  "revoke:Revoke authorization for credentials"
)

__gcloud-auth ()
{
  local curcontext="$curcontext" state line
  local -A opt_args

  _arguments \
    ':command:->command' \
    '*::options:->options'

  case $state in
    (command)
      _describe -t subcommand "gcloud :: auth Commands" _auth_arguments
      return
      ;;
    (options)
      case $line[1] in
        (list)
          _arguments \
            "--account+::List only credentials for one account:( )"
        ;;
        (login)
          # TODO: make options repeatable
          local args
          args=(
            "--account+:Override the account acquired from the web flow:( )"
            "--do-not-activate[Do not set the new credentials as active]"
            "--no-launch-browser[Print a URL to be copied instead of launching a web browser]"
            )
          _arguments -C $args
        ;;
        (revoke)
          _arguments \
            "--all[Revoke all known credentials]"
        ;;
      esac
      ;;
  esac
}

## for 'components' command groups
local -a _components_arguments
_components_arguments=(
  'list:Command to list the current state of installed components'
  'remove:Command to remove installed components'
  'restore:Command to restore a backup of a Cloud SDK installation'
  'update:Command to update existing or install new components'
)

__gcloud-components ()
{
  local curcontext="$curcontext" state line
  local -A opt_args

  _arguments -C \
    ':command:->command' \
    '*::options:->options'

  case $state in
    (command)
      _describe -t commands "gcloud :: components Commands" _components_arguments
      return
      ;;
    (options)
      case $line[1] in
        (list)
          _arguments \
            "--show-versions[Show version information for all components]"
          ;;
        (remove)
          ;;
        (restore)
          ;;
        (update)
          ;;
      esac
      ;;
  esac
}

## for 'compute' command groups
local -a _compute_arguments
_compute_arguments=(
  "addresses:Read and manipulate Google Compute Engine addresses."
  "backend-services:List, create, and delete backend services."
  "disk-types:Read Google Compute Engine virtual disk types."
  "disks:Read and manipulate Google Compute Engine disks."
  "firewall-rules:List, create, and delete Google Compute Engine firewall rules."
  "forwarding-rules:Read and manipulate forwarding rules to send traffic to load balancers."
  "http-health-checks:Read and manipulate HTTP health checks for load balanced instances."
  "images:List, create, and delete Google Compute Engine images."
  "instances:Read and manipulate Google Compute Engine virtual machine instances."
  "machine-types:Read Google Compute Engine virtual machine types."
  "networks:List, create, and delete Google Compute Engine networks."
  "operations:Read and manipulate Google Compute Engine operations."
  "project-info:Read and manipulate project-level data like quotas and metadata."
  "regions:List Google Compute Engine regions."
  "routes:Read and manipulate routes."
  "snapshots:List, describe, and delete Google Compute Engine snapshots."
  "target-http-proxies:List, create, and delete target HTTP proxies."
  "target-instances:Read and manipulate Google Compute Engine virtual target instances."
  "target-pools:Read and manipulate Google Compute Engine target pools."
  "url-maps:List, create, and delete URL maps."
  "zones:List Google Compute Engine zones."
  "config-ssh:Populate SSH config files with Host entries from each instance"
  "copy-files:Copy files to and from Google Compute Engine virtual machines."
  "ssh:SSH into a virtual machine instance."
)

__gcloud-compute ()
{
  local curcontext="$curcontext" state line
  local -A opt_args

  _arguments -C \
    ':command:->command' \
    '*::options:->options'

  case $state in
    (command)
      _describe -t commands "gcloud :: compute commands" _compute_arguments
      return
      ;;
  esac

        

}

## for 'config' command groups
local -a _config_arguments
_config_arguments=(
  'list:View Google Cloud SDK properties'
  'set:Edit Google Cloud SDK properties'
  'unset:Erase Google Cloud SDK properties'
)

__gcloud-config ()
{
  local curcontext="$curcontext" state line
  local -A opt_args

  _arguments -C \
    ':command:->command' \
    '*::options:->options'

  case $state in
    (command)
      _describe -t commands "gcloud :: config Commands" _config_arguments
      return
      ;;
    (options)
      case $line[1] in
        (list)
          _arguments \
            "--all[List all set and unset properties that match the arguments]" \
            {--section+,-s+}":The section whose properties shall be listed:( )"
          ;;
        (set)
          # FEATURE: gcloud config set <property>, will complete the property names
          local -a _config_set_arguments
          _config_set_arguments=(
            "--global-only[Set the option in the global properties file]"
            {--section+,-s+}":The section containing the option to be set:( )"
          )

          _arguments -C \
            $_config_set_arguments \
            '1:feature:__variable_list' \
            '*:value:->value'

          case $state in
            (value)
              case $line[1] in
                (account)
                  # FEATURE: gcloud config set account <authed_account>
                  # when `config set account <cursor>`, completing by authroized accounts
                  _arguments -C \
                    '2:feature:__account_list'
                  ;;
              esac
              ;;
          esac

          ;;
        (unset)
          # FEATURE: gcloud config unset <property>, will complete the property names
          local -a _config_unset_arguments
          _config_unset_arguments=(
            "--global-only[Unset the option in the global properties file]"
            {--section+,-s+}":The section containing the option to be unset:( )"
          )
          _arguments \
            $_config_unset_arguments \
            '1:feature:__variable_list'
          ;;
      esac
      ;;
  esac
}


## for 'sql' command groups
local -a _sql_arguments
_sql_arguments=(
  'backups:Provide commands for working with backups of Cloud SQL instances'
  'instances:Provide commands for managing Cloud SQL instances'
  'operations:Provide commands for working with Cloud SQL instance operations'
  'ssl-certs:Provide commands for managing SSL certificates of Cloud SQL instances'
  'tiers:Provide a command to list tiers'
)

__gcloud-sql ()
{
  local curcontext="$curcontext" state line
  local -A opt_args

  _arguments -C \
    ':command:->command' \
    '*::options:->options'

  case $state in
    (command)
      _describe -t commands "gcloud :: sql Commands" _sql_arguments
      return
      ;;
    (options)
      case $line[1] in
        (backups)
          _sql_backups_arguments=(
            "get:Retrieves information about a backup"
            "list:Lists all backups associated with a given instance"
          )

          _arguments \
            ':command:->command' \
            {--instance+,-i+}":Cloud SQL instance ID:( )" \
            '*::options:->options'

          case $state in
            (command)
              local -a _sql_backups_arguments
              _describe -t commands "gcloud :: sql :: backup Commands" _sql_backups_arguments
              ;;
          esac
          ;;
        (instances)
          # too many optional options in here, cry ;(
          _sql_instances_arguments=(
            'create:Creates a new Cloud SQL instance'
            'delete:Deletes a Cloud SQL instance'
            'export:Exports data from a Cloud SQL instance'
            'get:Retrieves information about a Cloud SQL instance'
            'import:Imports data into a Cloud SQL instance from Google Cloud Storage'
            'list:Lists Cloud SQL instances in a given project'
            'patch:Updates the settings of a Cloud SQL instance'
            'reset-ssl-config:Deletes all client certificates and generates a new server certificate'
            'restart:Restarts a Cloud SQL instance'
            'restore-backup:Restores a backup of a Cloud SQL instance'
            'set-root-password:Sets the password of the MySQL root user'
          )

          _arguments \
            ':command:->command' \
            '*::options:->options'

          case $state in
            (command)
              _describe -t commands "gcloud :: sql :: instances Commands" _sql_instances_arguments
              ;;
          esac
          ;;
        (operations)
          local -a _sql_operations_arguments
          _sql_operations_arguments=(
            "get:Retrieves information about a Cloud SQL instance operation."
            "list:Lists all instance operations for the given Cloud SQL instance"
          )

          _arguments \
            ':command:->command' \
            {--instance+,-i+}":Cloud SQL instance ID:( )" \
            '*::options:->options'

          case $state in
            (command)
              _describe -t commands "gcloud :: sql :: operations Commands" _sql_backups_arguments
              ;;
          esac
          ;;
        (ssl-certs)
          local -a _sql_sslcerts_arguments
          _sql_sslcerts_arguments=(
            'create:Creates an SSL certificate for a Cloud SQL instance'
            'delete:Deletes an SSL certificate for a Cloud SQL instance'
            'get:Retrieves information about an SSL cert for a Cloud SQL instance'
            'list:Lists all SSL certs for a Cloud SQL instance'
          )

          _arguments \
            ':command:->command' \
            {--instance+,-i+}":Cloud SQL instance ID:( )" \
            '*::options:->options'

          case $state in
            (command)
              _describe -t commands "gcloud :: sql :: ssl-certs Commands" _sql_sslcerts_arguments
              ;;
          esac
          ;;
        (tiers)
          local -a _sql_tiers_arguments
          _sql_tiers_arguments=(
            "list:Lists all available service tiers for Google Cloud SQL"
          )

          _arguments \
            ':command:->command' \
            '*::options:->options'

          case $state in
            (command)
              _describe -t commands "gcloud :: sql :: tiers Commands" _sql_tiers_arguments
              ;;
          esac
          ;;
      esac
      ;;
  esac
}

## Top-level completion function
local expl
local curcontext="$curcontext" state line
local -A opt_args

_arguments -C \
  $common_ops \
  ':command:->command' \
  '*::options:->options'

case $state in
  (command)
    _describe -t commands "Google Cloud SDK Commands" _first_arguments
  ;;

  (options)
    # subcommands
    case $line[1] in
      (auth)
        __gcloud-auth
        ;;
      (compute)
        __gcloud-compute
        ;;
      (components)
        __gcloud-components
        ;;
      (config)
        __gcloud-config
        ;;
      (sql)
        __gcloud-sql
        ;;
    esac
  ;;
esac

return 0

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et

#compdef appcfg.py
#------------------------------------------------------------
# Description:
#
#  Completion script for App Engine appcfg.py script
#
# Author:
#
#  * Colin Su (https://github.com/littleq0903)
#
# Source Code:
#
#  https://github.com/littleq0903/gcloud-zsh-completion
#
#------------------------------------------------------------

## Utils

__get_yaml_files () {
    _wanted application expl 'Google App Engine Configuration' compadd $(command find . -depth 1 -name "*.yaml")
    _wanted application expl 'Google App Engine Configuration' compadd $(command echo '.')
}

## Actions
local -a _action_backends_arguments
_action_backends_arguments=(
	'configure:Reconfigure a backend without stopping it'
	'delete:Delete a backend'
	'list:List all backends configured for the app'
	'rollback:Roll back an update of a backend'
	'start:Start a backend'
	'stop:Stop a backend'
	'update:Update one or more backends'
)

local -a _action_arguments
_action_arguments=(
	'backends:Perform a backend action'

	'create_bulkloader_config:Create a bulkloader.yaml from a running application'
	'cron_info:Display information about cron jobs'
	'delete_version:Delete the specified version for an app'
	'download_app:Download a previously-uploaded app'
	'download_data:Download entities from datastore'
	'help:Print help for a specific action'
	'list_versions:List all uploaded versions for an app'
	'request_logs:Write request logs in Apache common log format'
	'resource_limits_info:Get the resource limits'
	'rollback:Rollback an in-progress update'
	'set_default_version:Set the default (serving) version'
	'start_module_version:Start a module version'
	'stop_module_version:Stop a module version'

	'update:Create or update an app version'
	'update_cron:Update application cron definitions'
	'update_dispatch:Update application dispatch definitions'
	'update_dos:Update application dos definitions'
	'update_indexes:Update application indexes'
	'update_queues:Update application task queue definitions'
	'upload_data:Upload data records to datastore'

	'vacuum_indexes:Delete unused indexes from application'
)

## Options
local -a _options_arguments
_options_arguments=(
  {-h,--help}'[Show the help message and exit]'
  {-q,--quiet}'[Print errors only]'
  {-v,--verbose}'[Print info level logs]'
  '--noisy[Print all logs]'
  {-s+,--server=}':The App Engine server:( )'
  {-e+,--email=}':The username to use. Will prompt if omitted:( )'
  {-H+,--host=}':Overrides the Host header sent with all RPCs:( )'
  '--no_cookies[Do not save authentication cookies to local disk]'
  '--skip_sdk_update_check Do not check for SDK updates'
  '--passin[Read the login password from stdin]'
  {-A+,--application=}':Set the application,overriding the application value from app.yaml file:( )'
  {-V+,--version=}':Set the (major) version,overriding the version value from app.yaml file:( )'
  {-r+,--runtime=}':Override runtime from app.yaml file:( )'
  {-E+,--env_variable=}':Set an environment variable,potentially overriding an env_variable value from app.yaml file (flag may be repeated to set multiple variables):( )'
  {-R,--allow_any_runtime}'[Do not validate the runtime in app.yam]'
  '--oauth2[Use OAuth2 instead of password auth]'
  '--oauth2_refresh_token=:An existing OAuth2 refresh token to use. Will not attempt interactive OAuth approval:( )'
  '--oauth2_access_token=:An existing OAuth2 access token to use. Will not attempt interactive OAuth approval:( )'
  '--authenticate_service_account[Authenticate using the default service account for the Google Compute Engine VM in which appcfg is being calle]'
  '--noauth_local_webserver[Do not run a local web server to handle redirects during OAuth authorization]'
  {-f,--force}'[Force deletion without being prompted]'
  '--has_header[Whether the first line of the input file should be skippe]'
  '--loader_opts= A string to pass to the Loader.initialize method'
  '--url=:The location of the remote_api endpoint:( )'
  '--batch_size=:jNumber of records to post in each request:( )'
  '--bandwidth_limit=:The maximum bytes/second bandwidth for transfers:( )'
  '--rps_limit=:The maximum records/second for transfers:( )'
  '--http_limit=:The maximum requests/second for transfers:( )'
  '--db_filename=:Name of the progress database file:( )'
  '--auth_domain=:The name of the authorization domain to use:( )'
  '--log_file=:File to write bulkloader logs.:If not supplied then a new log file will be created,named: bulkloader-log- TIMESTAMP:( )'
  '--dry_run[Do not execute any remote_api call]'
  '--namespace=:Namespace to use when accessing datastore:( )'
  '--num_threads=:Number of threads to transfer records with:( )'
  '--filename=:The name of the file where output data is to be written. (Required:( )'
  '--kind=:The kind of the entities to retrieve:( )'
  '--exporter_opts=:A string to pass to the Exporter.initialize method:( )'
  '--result_db_filename=:Database to write entities to for download:( )'
  '--config_file=:Name of the configuration file:( )'
  '--num_runs=:Number of runs of each cron job to displayDefault is :( )'
  '--no_precompilation:Disable automatic precompilation (ignored for Go apps)'
  '--backends[Update backends when performing appcfg update]'
  {-I+,--instance=}':Instance to debug:( )'
  {-n+,--num_days=}':Number of days worth of log data to get. The cut-off point is midnight US/Pacific. Use 0 to get all available logs. Default is 1,unless --append is also given; then the default is 0:( )'
  {-a,--append}'[Append to existing file]'
  '--severity=:Severity of app-level log messages to get. The range is 0 (DEBUG) through 4 (CRITICAL). If omitted,only request logs are returned:( )'
  '--vhost=:The virtual host of log messages to get. If omitted,all log messages are returned:( )'
  '--include_vhost[Include virtual host in log messages]'
  '--include_all[Include everything in log messages]'
  '--end_date=:End date (as YYYY-MM-DD) of period for log data. Defaults to today:( )'
)

## completion
local expl
local curcontext="$curcontext" state line
local -A opt_args

_arguments -C \
  $_options_arguments \
  ':action:->action' \
  '*::options:->options'

case $state in
  (action)
    _describe -t actions "Google App Engine appcfg.py Actions" _action_arguments
    ;;
  (options)
    local -a args

    case $words[1] in
      (backends)
        # if action argument is 'backends', give its subcommand
        _arguments -C \
          ':action:->action' \
          '*::options:->options'

        case $state in
          (action)
            _describe -t subactions "appcfg.py backends" _action_backends_arguments
            ;;
          (options)
            _arguments '*:feature:__get_yaml_files'
            ;;
        esac
        ;;
      (*)
        _arguments -C '*:feature:__get_yaml_files'
        ;;
    esac

    _arguments $args
    ;;
esac

return 0

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et