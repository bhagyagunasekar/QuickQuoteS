#!/bin/bash

declare -r TRUE=0
declare -r FALSE=1

declare -r TRACE=0
declare -r DEBUG=1
declare -r INFO=2
declare -r WARN=3
declare -r ERROR=4
declare -r LOG_PRIORITY=$TRACE
declare -r HOSTFILE=/etc/hosts

declare STATUS='FAILURE'

function _timestamp(){
        echo $(date '+%F %X')
}
function _log() {
        local priority=$1;
        local priorityTag=$2;shift 2
        [ $priority -ge $LOG_PRIORITY ] && \
        	echo -e [$(_timestamp)]:[$priorityTag]: "$@"
}
function _error() {
	_log $ERROR ERROR "$@"
}
function _warn() {
	_log $WARN WARN "$@"
}
function _info() {
	_log $INFO INFO "$@"
}
function _debug() {
	_log $DEBUG DEBUG "$@"
}
function _trace() {
	_log $TRACE TRACE "$@"
}
 
source /etc/profile

function getManagerUrl() {
	<#assign hostname = 
		this.template.topology.parent.parent.lookupVariable("MANAGER_HOSTNAME")/>
	<#if !hostname??>
   		failure "MANAGER_HOSTNAME is undefined"
	</#if>
	echo ${Manager.Protocol}://${hostname.value}:${Manager.Port}
}

declare -r AGILITY_URL=$(getManagerUrl)

_debug "[AGILITY_URL] : "$AGILITY_URL
_debug "[REPO_USER] : "${REPO_USER}
_debug "[REPO_PASSWORD] : "${REPO_PASSWORD}
_debug "[PACKAGE_URL] : "${PACKAGE_URL}
_debug "[PACKAGE_ID] : "${PACKAGE_ID}
_debug "[REQUEST_ID] : "${REQUEST_ID}
_debug "[DEPLOYER_STATUS] : "${DEPLOYER_STATUS}

function out() {
	local exitCode=$1
	local status=$2; shift 2
	local message="$@"
	STATUS=$status
	setDeployerStatus $status "$message"
	exit $exitCode
}

function failure() {
	_error "$@"
	out 1 FAILURE "$@"
}

function success() {
	_info "$@"
	out 0 SUCCESS "$@"
}

function validateRequiredVariables() {
	[ -z ${REQUEST_ID} ] && failure "\\$REQUEST_ID is null."
	[ -z ${PACKAGE_ID} ] && failure "\\$PACKAGE_ID is null."
	[ -z ${PACKAGE_URL} ] && failure "\\$PACKAGE_URL is null."
	[ -z ${REPO_USER} ] && failure "\\$REPO_USER is null."
	[ -z ${REPO_PASSWORD} ] && failure "\\$REPO_PASSWORD is null."
	[ -z $CATALINA_HOME ] && failure "\\$CATALINA_HOME is null."
}

function getDeployerStatusMessage() {
local requestId=$1
local packageId=$2
local packageUrl=$3
local statusCode=$4; shift 4
local statusMessage="$@"
echo "
{
   \"deployment\":{
      \"request\" : {
          \"id\" : \"$requestId\"
      },
      \"packages\":[
        {
            \"id\":\"$packageId\",
            \"url\":\"$packageUrl\",
            \"status\":{
               \"code\":\"$statusCode\",
               \"message\":\"$statusMessage\"
       		}
       	}
      ]
   }
}
"
}

function getVariableXml() {
	local varId=$1
	local varName=$2; shift 2
	local varValue="$@"

cat <<vareof
<Variable xmlns="http://servicemesh.com/agility/api/v1.0">
	<id>$varId</id>
    <name>$varName</name>
    <value><![CDATA[$varValue ]]></value>
	<encrypted>false</encrypted>
	<overridable>true</overridable>
</Variable>
vareof
}

function getDeployedUrl() {
	local url='not-deployed'
	[ "$STATUS" == "SUCCESS" ] && url=${this.publicAddress}
	<#noparse>
		printf "http://%s:8080/%s/" $url ${packageName%%.*}
	</#noparse>
}

function setDeployerStatus() {
	local status=$1; shift
	local message="$@"
	# Build uri to variable for api call
	<#assign variable = this.template.topology.lookupVariable("DEPLOYER_STATUS")/>
	variableId=$(echo ${variable.id} | tr -d ',')

	uri=$AGILITY_URL/agility/api/v1.0
	uri=$uri/topology/${this.template.topology.id}/variable/$variableId

	_debug "Updating variable : {id}: $variableId, {name}: ${variable.name}"

	# Create temporary file with variable-XML to be posted
	variableXml=`mktemp 'varXXXXX'`
	deployedUrl=$(getDeployedUrl)
	_debug DEPLOYED-URL : $deployedUrl

	deployerStatusMessage=$(getDeployerStatusMessage ${REQUEST_ID} ${PACKAGE_ID} $deployedUrl $status "$message")
	echo $(getVariableXml $variableId ${variable.name} "$deployerStatusMessage") > $variableXml

	_debug "$deployerStatusMessage"

	# PUT var xml
	curl -s -X PUT -u 'admin:M3sh@dmin!' -k -H 'Content-Type:application/xml' \
	        -T $variableXml $uri
	
	rm -f $variableXml
}

function getPackage() {
	curl -s -X GET \
		--user ${REPO_USER}:${REPO_PASSWORD} \
		-L ${PACKAGE_URL} \
			-o $packageName
}

function failExit() {
	local status=$1;shift
	local message="$@"
	if [ $status -ne 0 ]; then
		_error "$message"
		exit 1
	fi
}

function writeHostEntry() {
	sudo echo "$@" >> $HOSTFILE
	return $?
}

function hostEntryExists() {
	local hostname=$1
	sudo grep -q $hostname $HOSTFILE
	echo $?
}

declare -a hostlist=(192.168.220.88@api.demo-rm.servicemesh.com 192.168.220.88@repo.demo-rm.servicemesh.com)
declare rebootNetwork=$FALSE

<#noparse>
function updateHostfile() {
#@ --------------------------------------------------------
#@ Iterate over host list, check if each entry exists
#@ in $HOSTFILE.  If not - create the entry.
#@ --------------------------------------------------------
	for entry in ${hostlist[@]}; do
		local hostname=$(echo ${entry} | cut -d'@' -f2)
		if [ $(hostEntryExists ${hostname}) -eq $TRUE ]; then
			_info "Host entry exists for : $hostname"
		else
			local record=$(echo $entry | tr '@' '\t')
			_info "Writing host entry : $record"
			if ! writeHostEntry ${record}; then
				msg="Failed to write host entry [FAILURE]"
				_error "$msg"
				setDeployerStatus FAILURE "$msg"
				exit 1
			fi
			sudo rebootNetwork=$TRUE
		fi
	done
}
</#noparse>

# -----------------------------------------------------------------------------
# Assert all of the required Agility variables are set
# -----------------------------------------------------------------------------
validateRequiredVariables

# -----------------------------------------------------------------------------
# Ensure we are able to resolve the repository-server hostname
# -----------------------------------------------------------------------------
#updateHostfile

### Reboot network interface if needed (must be done if we added any hosts)
[ $rebootNetwork -eq $TRUE ] && sudo /etc/init.d/network restart

# -----------------------------------------------------------------------------
# Download package and verify retrieval
# -----------------------------------------------------------------------------
### Get package name from url
packageName=$(basename ${PACKAGE_URL})

### Retrieve package from RM repository
getPackage ${PACKAGE_URL}

### Make sure the download succeeded
if [ ! -e $packageName ]; then
	msg="Failed to retrieve package : $packageName."
	_error "$msg"
	setDeployerStatus FAILURE "$msg"
	exit 1
fi

<#noparse>
# ReleaseManager names the package {appName}-{buildNumber}.war' 
# Strip off the '-{buildNumber}'
originalPackageName=$packageName
packageName=${packageName%%-*}.war
</#noparse>

# -----------------------------------------------------------------------------
# Install the package
# -----------------------------------------------------------------------------
### Shutdown tomcat if it's running
if ps -ef | grep -q [t]omcat; then
	sudo $CATALINA_HOME/bin/shutdown.sh
fi

<#noparse>
### Cleanup old package and app directory.
sudo rm -rf $CATALINA_HOME/webapps/${packageName%%.*}
sudo rm -f $CATALINA_HOME/webapps/$packageName
</#noparse>

### Deploy package and restart app server.
sudo mv $originalPackageName $CATALINA_HOME/webapps/$packageName
sudo nohup $CATALINA_HOME/bin/startup.sh 0<&-1>/dev/null 2>&1 &


### Wait for it...
sleep 5

# -----------------------------------------------------------------------------
# Make sure tomcat is back, report status, and exit.
# -----------------------------------------------------------------------------
if ps -ef | grep [t]omcat; then
	msg="'$packageName' has been deployed. [SUCCESS]"
	success "$msg"
else
	msg="Failed starting Tomcat. [FAILURE]"
	failure "$msg"
fi
exit $status
