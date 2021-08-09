#!/bin/bash
  
for file in /var/log/*
do
        grep 'authentication failure' $file
done
