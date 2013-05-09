#!/bin/bash

# Settings
LOCKDIR="$OPENSHIFT_DATA_DIR/lock"
LOCKFILE="$LOCKDIR/ttrss.pid"
UPDATE="$OPENSHIFT_REPO_DIR/php/update.php"
chmod +x $UPDATE

if [ ! -d $LOCKDIR ]; then
    mkdir $LOCKDIR
fi

if [ -e $LOCKFILE ]; then
    echo "PID file exists!"
    PID=$(eval echo -e `<$LOCKFILE`)

    if [ -e "/proc/$PID" ]; then
        echo "The process is active!"
        
        if ls "/proc/$PID"; then
            exit 2
        else
            echo "Killing process."
            killall update.php
        fi
    fi
fi

echo "Starting update.php"

# Start update.php
/usr/bin/php $UPDATE -daemon >/dev/null 2>&1 &

# Create lockfile
echo $! > $LOCKFILE
