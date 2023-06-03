#!/bin/bash

# Generates library.json file from makefile
# Syntax:
# libgen <makefile>

BLANK_JSON=$(cat blank.json)

# Force this to use the local pico-sdk
PICO_SDK_PATH=./pico-sdk

# Get the output, split it into lines, get everything that looks like a path
PATHS=$(make lib -n -f RP2040.Makefile | sed 's/ /\n/g' | grep -F ./ | sort | uniq)

# Get all include paths. Add commas to the end (PIO expects a list.)
INC=$(echo "$PATHS" | grep -F 'I.' | sed '$!s/$/,/')

SRC=$(echo "$PATHS" | grep '\.[cS]$' | sed 's/.*/+<&>/')

BLANK_JSON=${BLANK_JSON}

echo { \"name\": \"ChibiOS\", \"version\": \"21\", \"build\": { \"includeDir\": \".\", \"flags\": [ -Iinclude, -Wl,--defsym=__process_stack_size__=0x400, -Wl,--defsym=__main_stack_size__=0x200, -DCRT0_EXTRA_CORES_NUMBER=1, $INC ] \"srcDir\": \".\", \"srcFilter\" : $SRC, } } |  sed 's/ /\n/g' > library.json
