#!/bin/bash
# Entrypoint script for bindfs container

# If no arguments provided, show help
if [ "$#" -eq 0 ]; then
    exec bindfs --help
fi

# Run bindfs with foreground flag and any passed arguments
exec bindfs -f "$@"
