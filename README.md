## systemmonitor.sh ##
This script is an exercise in BASH for a mini-course by Rebrain. 
It is used to monitor system resources and relies mainly on Linux built-in tools (parsing system files and utilities like "ip").
sysstat package is also used, its presence is being checked in the beginning of the script.

### How-to ###
Run "bash systemmonitor.sh [OPTIONS] [ARGUMENTS]" (without quotes)

Run "bash systemmonitor.sh -h" or "bash systemmonitor.sh --help" for Help.
Or just try to run the script without any options/arguments or with unsupported arguments.


### Key BASH features used ###

1. User-defined functions
2. AWK scripts
3. Arrays
4. Input validation using **getopt** function
5. WHILE, CASE, FOR, FOR IN and IF contructs
