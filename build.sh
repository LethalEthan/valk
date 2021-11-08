#!/bin/bash

if [[ -d "./test/" ]]
then
    v . -cc gcc -o test/valk -prod -show-timings -gc boehm
else 
    mkdir test
    v . -cc gcc -o test/valk -prod -show-timings -gc boehm
fi