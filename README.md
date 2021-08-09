## systemmonitor.sh ##
Thus script is a learning task for BASH course by Rebrain. 
It is used to monitor system resources and relies mainly on Linux built-in tools (parsing system files and utilities like "ip").
sysstat package is also used, its presence is being checked in the beginning of the script.

### How-to ###
Run "bash systemmonitor.sh [OPTIONS] [ARGUMENTS]" (without quotes)

Run "bash systemmonitor.sh -h" or "bash systemmonitor.sh --help" for Help.
Or just try to run the script without any options/arguments or with unsupported arguments.


### Help ###

This is a script to have most common system monitoring tools under one umbrella.
Please ensure that sysstat and ifstat packages are installed
Syntax: systemmonitor [OPTION] [ARGUMENT]
Only 1 [OPTION] or a combination [OPTION] [ARGUMENT] is allowed. The exception is -o | --output

Options list:

   -h | --help        Help
   -p | --proc        /etc/proc information; extra arguments available
               ci - show CPU info
               cv - show CPU vendor
               mi - show Memory info
               mt - show Total Memory
               sw - show Swap
               up - show Uptime
               vr - show Version
   -c | --cpu         CPU moninoting; extra arguments available
               cp - show TOP
               io - show I/O
   -m | --memory      Memory moniroting; extra arguments available
               mf - show Free Memory
               mu - show Memory and CPU for the current user
   -d | --disks       Disks and filesystem monitoring; extra arguments available
               bk - show Block devices
               fs - show File Systems
   -n | --network     Network monitoring; extra arguments available
               ip - show brief IPv4 configuration
               rt - show IP routing table
   -l | --loadaverage LoadAverage
   -k | --kill PID    Kill a process with provided PID
   -o | --output      Saves script output to ./sysmon.log
   -a | --auth        Searches for system authentication failures in /var/log/ files

### Key BASH features used ###

1. User-defined functions
2. AWK scripts
3. Arrays
4. Input validation using **getopt** function
5. WHILE, CASE, FOR, FOR IN and IF contructs
