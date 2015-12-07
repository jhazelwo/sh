#!/bin/sh
# 
# to use:
# . include/fun

# 
thisExec=`basename $0`
thisProc="${thisExec}[$$]"
thisHost="`hostname | head -1 | cut -d\. -f1`"


# Show arbit message like a logger would.
yo(){ echo "`date` `hostname` $@";}


# Wait $2 seconds for $1 to exist.
wait_for_path() {
    amount=$2
    test -z "$amount" && amount=60
    end="$(($(date '+%s')+${amount}))"
    while [ ! -e $1 ]; do
        test "`date '+%s'`" -gt "${end}" && { echo timeout; exit 9; }
        sleep 1;
    done
}

# Wait $2 seconds for $1 to exist as directory.
wait_for_dir() {
    amount=$2
    test -z "$amount" && amount=60
    end="$(($(date '+%s')+${amount}))"
    while [ ! -d $1 ]; do
        test "`date '+%s'`" -gt "${end}" && { echo timeout; exit 9; }
        sleep 1;
    done
}

# Wait $2 seconds for $1 to exist as file.
wait_for_file() {
    amount=$2
    test -z "$amount" && amount=60
    end="$(($(date '+%s')+${amount}))"
    while [ ! -f $1 ]; do
        test "`date '+%s'`" -gt "${end}" && { echo timeout; exit 9; }
        sleep 1;
    done
}


thisExec=`basename $0`
thisProc="${thisExec}[$$]"
thisHost="`hostname | head -1 | cut -d\. -f1`"

