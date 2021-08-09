#!/bin/bash

function_help ()
{
   # Function to display Help
   echo
   echo "This is a script to have most common system monitoring tools under one umbrella."
   echo "Please ensure that sysstat and ifstat packages are installed"
   echo "Syntax: systemmonitor [OPTION] [ARGUMENT]"
   echo "Only 1 [OPTION] or a combination [OPTION] [ARGUMENT] is allowed. The exception is -o | --output"
   echo
   echo "Options list:"
   echo
   echo "   -h | --help        Help"
   echo "   -p | --proc        /etc/proc information; extra arguments available"
   echo "               ci - show CPU info"
   echo "               cv - show CPU vendor"
   echo "               mi - show Memory info"
   echo "               mt - show Total Memory"
   echo "               sw - show Swap"
   echo "               up - show Uptime"
   echo "               vr - show Version"   
   echo "   -c | --cpu         CPU moninoting; extra arguments available"
   echo "               cp - show TOP"
   echo "               io - show I/O"
   echo "   -m | --memory      Memory moniroting; extra arguments available"
   echo "               mf - show Free Memory"
   echo "               mu - show Memory and CPU for the current user"
   echo "   -d | --disks       Disks and filesystem monitoring; extra arguments available"
   echo "               bk - show Block devices"
   echo "               fs - show File Systems"
   echo "   -n | --network     Network monitoring; extra arguments available"
   echo "               ip - show brief IPv4 configuration"
   echo "               rt - show IP routing table"
   echo "               is - show network interfaces utilization"
   echo "   -l | --loadaverage LoadAverage"
   echo "   -k | --kill PID    Kill a process with provided PID"
   echo "   -o | --output      Saves script output to ./sysmon.log"
   echo "   -a | --auth        Searches for system authentication failures in /var/log/ files"
   echo
   exit
}

function_checkpackage () {
# Function to check if sysstat and ifstat are installed in the system.
VAR_SYSSTAT=$(apt-cache policy sysstat | awk 'NR==2 {print $0}')
VAR_IFSTAT=$(apt-cache policy ifstat | awk 'NR==2 {print $0}')
#NR - specify line number
#grep -q - returns only exit code, without actual ouptut
if echo $VAR_SYSSTAT | grep -q none
then
        echo "Install sysstat first"
        exit
fi

if echo $VAR_IFSTAT | grep -q none
then
        echo "Install ifstat first"
        exit
fi
}

function_checkpackage


# Code to validate and normalize input options; it does not validate arguments, but validates option.
PARSED_ARGUMENTS=$(getopt -a -n systemmonitor -o hloac:d:m:n:p:k: --long help,l,loadaverage,auth,output,cpu:,proc:,memory:,disks:,network:,kill: -- "$@")
# '-a' - make no difference between '-' and '--'; '-n systemmonitor' - generate errors on behalf of 'systemmonitor', not 'getopt'; '$@' - all arguments entered
VALID_ARGUMENTS=$?
# '$?' - exit status of the previous operation
if [ "$VALID_ARGUMENTS" != "0" ]; then
  function_help
fi
eval set -- $PARSED_ARGUMENTS
# "set" command removes formatting (quotes, commas, etc. if present)
# "eval" command makes the script to re-read input arguments from the variable;


VAR_HELP=0
VAR_CPU=0
VAR_DISKS=0
VAR_LOADAVERAGE=0
VAR_MEMORY=0
VAR_NETWORK=0
VAR_PROC=0
VAR_OUTPUT=0
VAR_KILL=0
VAR_AUTH=0


# Code to parse input options and arguments and assign them to variables that would be used later.
while :
do
  case "$1" in
    -k | --kill)    kill -9 $2; VAR_KILL=1; break; echo "Process $2 killed, no more options allowed, KILL can't be combined with other tools" ;;
    -o | --output)  VAR_OUTPUT=1    ; shift   ;;
    # after parsing every parameter we remove it from the input stack using "shift" command and the next parameter becomes $1;
    # for parameters where there is only option, no arguments, we just store 1 in case it exists;
    -h | --help)    VAR_HELP=1      ; shift  ;;
    -a | --auth)    VAR_AUTH=1      ; shift  ;;
    -l | --loadaverage) VAR_LOADAVERAGE=1 ; shift;;
    -c | --cpu)     VAR_CPU=$2      ; shift 2;;
    # for parameters that consist of 2 parts (option and argument) we store the second value $2 (the argument) and use "shift 2" to remove both parts from the stack;
    -d | --disks)   VAR_DISKS="$2"  ; shift 2;;
    -m | --memory)  VAR_MEMORY=$2   ; shift 2;;
    -n | --network) VAR_NETWORK=$2  ; shift 2;;
    -p | --proc)    VAR_PROC=$2     ; shift 2;;
    # "--" is end of the arguments; we need to break and exit the loop.
    --) shift; break ;;
    # If invalid options (but not their arguments!) were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unsupported option: $1 - see Help."
       function_help ;;
  esac
done


#echo "VAR_HELP         $VAR_HELP"
#echo "VAR_CPU          $VAR_CPU"
#echo "VAR_DISKS        $VAR_DISKS"
#echo "VAR_LOADAVERAGE  $VAR_LOADAVERAGE"
#echo "VAR_MEMORY       $VAR_MEMORY"
#echo "VAR_NETWORK      $VAR_NETWORK"
#echo "VAR_PROC         $VAR_PROC"
#echo "VAR_OUTPUT       $VAR_OUTPUT"
#echo "VAR_KILL         $VAR_KILL"
#echo "VAR_AUTH         $VAR_AUTH"


# For all options that can't be combined with others (everything except -o | --output and -k | --kill) we create an array to check if the user entered >1 options
# This will be used later in the end of the script
ARRAY_STANDALONE_OPTIONS=($VAR_HELP $VAR_CPU $VAR_DISKS $VAR_LOADAVERAGE $VAR_MEMORY $VAR_NETWORK $VAR_PROC $VAR_AUTH)
ARRAY_LENGTH=${#ARRAY_STANDALONE_OPTIONS[*]}
VAR_OPTIONS_COUNTER=0
for (( i=0; i<$ARRAY_LENGTH; i++))
do
        a=${ARRAY_STANDALONE_OPTIONS[i]}
        # used another variable "a" since BASH did not allow to reference array element directly in IF statement
        if [[ $a == 0 ]]
        then
        VAR_OPTIONS_COUNTER=$((VAR_OPTIONS_COUNTER + 1))
        fi
done


function_monitor () {
# Function that runs monitoring tools
if [[ $VAR_CPU == cp ]]
then
        echo "System utilization:"
        top
elif [[ $VAR_CPU == io ]]
then
        echo "System I/O:"
        iostat
elif [[ $VAR_MEMORY == mf ]]
then
        echo "Free memory:"
        free -mh
elif [[ $VAR_MEMORY == mu ]]
then
        echo "Memory and CPU by the current user:"
        htop -u $(whoami)
elif [[ $VAR_DISKS == bk ]]
then
        echo "Block devices:"
        lsblk
elif [[ $VAR_DISKS == fs ]]
then
        echo "File systems:"
        df -h
elif [[ $VAR_NETWORK == ip ]]
then
        echo "Brief network interface IPv4 configuration:"
        ip a | grep 'lo\|enp\|ether\|inet[[:space:]]'
elif [[ $VAR_NETWORK == rt ]]
then
        echo "Routing table:"
        ip route
elif [[ $VAR_NETWORK == is ]]
then
        echo "Network interfaces utilization:"
        ifstat -a
elif [[ $VAR_LOADAVERAGE == 1 ]]
then
        cat /proc/loadavg | awk '{printf "1 minute Load Average = "} {print $1}  {printf "5 minutes Load Average = "} {print $2}  {printf "15 minutes Load Average = "} {print $3}'
elif [[ $VAR_PROC == ci ]]
then
        echo "/proc CPU info:"
        cat /proc/cpuinfo
elif [[ $VAR_PROC == cv ]]
then
        echo "/proc CPU Vendor info:"
        grep vendor /proc/cpuinfo
elif [[ $VAR_PROC == mi ]]
then
        echo "/proc Memory info:"
        cat /proc/meminfo
elif [[ $VAR_PROC == mt ]]
then
        echo "/proc Total Memory info:"
        grep MemTotal /proc/meminfo
elif [[ $VAR_PROC == sw ]]
then
        echo "/proc Total Swap info:"
        grep SwapTotal /proc/meminfo
elif [[ $VAR_PROC == up ]]
then
        echo "/proc Uptime human-readable info (Days:Hours:Minutes:Seconds:"
        awk '{printf("%d:%02d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60),($1%60))}' /proc/uptime
elif [[ $VAR_PROC == vr ]]
then
        echo "/proc Linux version info:"
        cat /proc/version
elif [[ $VAR_AUTH == 1 ]]
then
        for file in /var/log/*
        do
                grep 'authentication failure' $file
        done
elif [[ $VAR_KILL == 1 ]]
then
        echo
        # Although KILL is executed earlier (directly when parsing input options), this ELIF is needed to avoid error message under the last ELSE ("Unsupported option ...").
else
        echo "Unsupported option - please see Help."
        function_help
fi
}
# end of monitoring function


# A way to make sure that only 1 option was entered (for it we created the array called ARRAY_STANDALONE_OPTIONS ealier)
# If VAR_OUTPUT is <6, then more than 1 option was entered (except OUTPUT)
if [[ $VAR_OPTIONS_COUNTER -ge 7 ]]
then
        if [[ $VAR_OUTPUT == 0 ]]
        #A way to make output to the file ./sysmon.log
        then
        function_monitor
        elif [[ $VAR_OUTPUT == 1 ]]
        then
        function_monitor | tee -a ./sysmon.log
        fi
elif [[ $VAR_OPTIONS_COUNTER -le 6 ]]
then
        echo "Too many options - please see Help."
        function_help
fi

