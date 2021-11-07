#!/bin/bash

if [[ -d "./test/" ]]
then
    v . -cc gcc -o test/valk -prod
else 
    mkdir test
    v . -cc gcc -o test/valk -prod
fi