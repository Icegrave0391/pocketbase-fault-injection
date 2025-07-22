#!/bin/bash

NUM_REQ=100
CLIENTS=1

# each small file is around 48 Bytes
SMALL_FILE_API="api/files/pbc_736711446/222222222222222/hello_umyvgmj01k.txt"
TOKEN=""

ab -n $NUM_REQ -c $CLIENTS localhost:8090/${SMALL_FILE_API}?token=$TOKEN