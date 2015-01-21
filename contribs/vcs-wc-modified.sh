#!/bin/sh

# Use autorevision to determine if the working copy of the repo has been modified
# since the last commit.

OPT=$1

usage()
{
    echo
    echo "   Usage: $(basename $0) [-h | --help]"
    echo
    exit -1
}

[ "$1" = "-h" ] || [ "$1" = "--help" ] && usage

[ $(autorevision -s VCS_WC_MODIFIED) -eq 1 ]
