#!/bin/sh - source'd

abspath() {
    pushd . > /dev/null
    if [ -d "$1" ]; then
        cd "$1";
        dirs -l +0;
    else
        cd "`dirname \"$1\"`";
        cur_dir=`dirs -l +0`;
        if [ "$cur_dir" == "/" ]; then
            echo "$cur_dir`basename \"$1\"`";
        else
            echo "$cur_dir/`basename \"$1\"`";
        fi
    fi
    popd > /dev/null;
}

run_as_superuser() {
    cmd="$1"
    shift 1
    if [ ! $EUID == 0 ]
    then
        echo "Superuser priviledges required to $*."
        sudo -E $cmd || exit 1
    fi

}

export os=`uname`
export SCRIPTDIR="`dirname "$0"`/"
