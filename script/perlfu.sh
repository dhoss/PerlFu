#!/bin/bash

# This is a handy initscript for controlling PSGI applications using
# plackup

### BEGIN INIT INFO
# Provides:          <%= name %>
# Required-Start:    $all
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: <%= name %> server
# Description:       Start up plack daemon for the site <%= name %>
### END INIT INFO

. /lib/lsb/init-functions
. /home/dhoss/perl5/perlbrew/etc/bashrc


# variables from puppet definition
NAME=perlfu
BASEDIR=$1 #/home/devin/web-devel/PerlFu
PORT=4500
PSGI="$BASEDIR/script/perlfu_web.psgi"
WORKERS=4
MODULE=PerlFu::Web
SERVER=computron
USER=dhoss
GROUP=dhoss

# start_server startup errors go here
DAEMONLOG="$BASEDIR/server_starter.log"

# user:group to run as
CHUSER="$USER:$GROUP"

# pidfile location
STATUSDIR=/tmp
PIDFILE=$STATUSDIR/${NAME}.pid
STATUSFILE=$STATUSDIR/${NAME}.status

# app libs, assume in $BASEDIR/lib
LIBDIR="$BASEDIR/lib"

# daemon command
DAEMON=/home/dhoss/perl5/perlbrew/perls/perl-5.12.1/bin/start_server
DAEMONARGS="--port=$PORT --pid-file $PIDFILE --status-file $STATUSFILE --interval=2 --log-file $DAEMONLOG"
SERVERARGS="starman --workers=$WORKERS --app $PSGI -I$LIBDIR"

# s-s-d command-line
SSD="/sbin/start-stop-daemon --pidfile $PIDFILE --chdir $BASEDIR --startas $DAEMON -c $CHUSER -v"


############ CHECK LOGFILE PERMISSIONS

# check log permissions
unset LOGWRITEOK

# parent directory writable?
if [ $EUID = 0 ]; then
    # run permissions tests as $USER:$GROUP
    su -l $USER -c 'test -w "$DAEMONLOG"' && LOGWRITEOK=1
    su -l $USER -c 'test \! -e "$DAEMONLOG" && test -w $BASEDIR' && LOGWRITEOK=1
else
    # test as current user
    [[ -w "$DAEMONLOG" || ( ! -e "$DAEMONLOG" && -w "$BASEDIR" ) ]] && LOGWRITEOK=1
fi

if [ -z "$LOGWRITEOK" ]; then
    log_failure_msg "Write access to the logfile $DAEMONLOG is required"
    exit 4
fi


############


check_running() {
    [ -s $PIDFILE ] && kill -0 $(cat $PIDFILE) >/dev/null 2>&1
}

hup() {
    $DAEMON $DAEMONARGS --restart
}
 
check_compile() {
    if ( cd $BASEDIR ; perl -Ilib -M$MODULE -ce1 ) ; then
        return 1
    else
        return 0
    fi
}

_start() {
    log_action_begin_msg "start_server arguments" "$DAEMONARGS"
    echo
    log_action_cont_msg "$SERVER arguments" "$SERVERARGS"
    log_action_end_msg 0
    echo "CMD LINE $SSD --start --background -- $DAEMONARGS -- $SERVERARGS"
    $SSD --start --background -- $DAEMONARGS -- $SERVERARGS || return 1

    log_success_msg "Backgrounded $NAME superserver. Log is at $DAEMONLOG"
    return 0
}


start() {
    if check_running; then
        log_failure_msg "already running"
        exit 0
    fi

    rm -f $PIDFILE 2>/dev/null

    _start
    RET=$?
    log_end_msg $RET
    return $RET
}

stop() {
    log_action_begin_msg "Stopping $NAME" $DAEMON

    $SSD --stop --oknodo

    RET=$?
    log_action_end_msg $RET
    return $RET
}

restart() {
    if ! check_running; then
        log_failure_msg "not running"
        return 0
    fi

    log_action_begin_msg "Checking syntax for $MODULE"

    if check_compile ; then
        log_action_cont_msg "Error detected; not restarting."
        log_action_end_msg 1
        return 1
    fi

    log_action_cont_msg "Sending HUP"

    if hup; then
        log_action_end_msg 0
        return 0
    else
        log_action_end_msg 1
        return 1
    fi
}

# need to update to return proper LSB status
status() {
    if check_running; then
        log_info_msg "$NAME: running"
        echo
        return 0
    else
        log_info_msg "$NAME: not running"
        echo
        return 3
    fi
}


############


# See how we were called.
case "$2" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart|force-reload)
        restart
        ;;
    *)
        echo $"Usage: $0 {start|status|stop|restart}"
        exit 5
esac
