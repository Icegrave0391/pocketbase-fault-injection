#!/bin/bash

NUM_REQ=100
CLIENTS=1

# each large file is 4KB
LARGE_FILE_API="api/files/pbc_736711446/111111111111111/random_file_aer84tjsxa"
TOKEN=""

ab -n $NUM_REQ -c $CLIENTS localhost:8090/${LARGE_FILE_API}?token=$TOKEN