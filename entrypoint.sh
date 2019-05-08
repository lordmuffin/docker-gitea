#!/usr/bin/env bash

set -e -x

pid=0

# SIGUSR1-Handler
my_handler() {
    echo "my_handler"
}

# SIGTERM-Handler
term_handler() {
    echo "term_handler"
    if [ $pid -ne 0 ]; then
        kill -SIGTERM "$pid"
        wait "$pid"
    fi
    cd /data/backups
    /work/gitea dump -c /work/tmp/gitea/conf/app.ini
    exit 143; # 128 + 15 -- SIGTERM
}

# SIGINT-Handler
int_handler() {
    echo "int_handler"
    if [ $pid -ne 0 ]; then
        kill -SIGINT "$pid"
        wait "$pid"
    fi
    cd /data/backups
    /work/gitea dump -c /work/tmp/gitea/conf/app.ini
    exit 143; # 128 + 15 -- SIGTERM
}

# Setup Handlers
# On callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM
trap 'kill ${!}; int_handler' SIGINT

# run application
./gitea web &
pid="$!"

# wait forever
while true
do
    tail -f /dev/null & wait ${!}
done