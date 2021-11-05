#!/bin/bash

if [[ -d "./test/" ]]
then
    v . -cc gcc -o test/valk
else 
    mkdir test
    v . -cc gcc -o test/valk
fi