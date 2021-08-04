#!/bin/bash/
zzgrep ()
{
        mkdir ./temp
        tar -xf $1 -C ./temp
        find ./temp -name "$2"
        echo $2
        rm -r ./temp
}
