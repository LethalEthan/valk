@echo off
if exist .\test (
    v . -cc gcc -o .\test\valk -os windows -prod -show-timings -gc boehm
) else (
    mkdir test
    v . -cc gcc -o .\test\valk -os windows -prod -show-timings -gc boehm
)