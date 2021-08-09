#!/bin/bash
  
#this script demonstrates use of "eval set" combination
#let's imagine we have a script with many input arguments ($1, $2, $3, etc.)
#for example, the user entered "bash SCRIPT_NAME.sh one two three four"

items=
# 'items' is just a string
for i in "$@"
# expression "$@" means ALL input, entered by the user
do
    items="$items \"$i\""
    # on each step we add one more input argument to the string
    # backslashes (\) are used just to add quotes ("") to values entered by the user
    # if we follow the example described in the top, on the first step "one" (exactly with quotes) would be written into 'items' variable
    # on the second step 'times' will have "one" "two" inside (exactly with quotes)
done

eval set -- $items

# "set" command removes formatting (qoutes in our case)
# "eval" command makes the script to re-read input arguments from the variable;
# like if we entered all arguments again, but taken from 'items' variable
# after that script's "$@" variable is filled with arguments from 'items' variable

for i in $@
do
    echo $i
    #we don't care about 'items' variable, we work with '$@'
    #like we have restarted the script with arguments "normalized" (unnecessary formatting removed)
done