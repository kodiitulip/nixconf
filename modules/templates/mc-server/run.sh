#!/usr/bin/env sh
trap 'kill -TERM $PID' TERM INT

# Start server
# NOTE: server starting command here!!!
# java -Xms4G -Xmx4G -jar <server-file.jar> --nogui & # FABRIC starter
# java @user_jvm_args.txt @libraries/path/to/unix_args.txt nogui "$@" # (NEO)FORGE starter

# Remember server process ID, wait for it to quit, then reset the trap
PID=$!
wait $PID
trap - TERM INT
wait $PID
