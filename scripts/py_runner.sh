#!/usr/bin/env bash

"""Run multiple python scripts in parallel."""

# Bash strict mode.
set -euo pipefail
IFS=$"\n\t"

# Add the name of the scripts here.
ARGS=("this" "antigravity")

# Maximum 32 processes will be spun up simultaneously.
max_processes="32"

# Find the length of the ARGS array.
args_length="${#ARGS[@]}"

# The effective processes is calculated by taking `min(args_length, max_process)`.
effective_processes="$(( args_length < max_processes  ? args_length : max_processes ))"

# Run the command
echo "$effective_processes processes are being used to run the scripts..\n"
echo "${ARGS[@]}" | xargs -n 1 -P $effective_processes -t python3.9 -m
