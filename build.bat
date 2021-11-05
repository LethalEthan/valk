@echo off
if exist .\test (
    v . -cc gcc -o .\test\valk -os windows
) else (
    mkdir test
    v . -cc gcc -o .\test\valk -os windows
)