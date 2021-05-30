#!/bin/bash

## Shamelessly borrowed from android's envsetup.sh.
function getrootdir
{
    local TOPFILE="build/Makefile"
    if [[ -n "$ROOTDIR" && -f "$ROOTDIR/$TOPFILE" ]]; then
        # The following circumlocution ensures we remove symlinks from ROOTDIR.
        (cd "${ROOTDIR}"; PWD= /bin/pwd)
    else
        if [[ -f "${TOPFILE}" ]]; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE="${PWD}"
            local R=
            while [ \( ! \( -f "${TOPFILE}" \) \) -a \( "${PWD}" != "/" \) ]; do
                \cd ..
                R=`PWD= /bin/pwd -P`
            done
            \cd "${HERE}"
            if [ -f "${R}/${TOPFILE}" ]; then
                echo "${R}"
            fi
        fi
    fi
}

export ROOTDIR="$(getrootdir)"
export OUT="${ROOTDIR}/out"

function m
{
    pushd "${ROOTDIR}" >/dev/null
    make "$@"
    popd >/dev/null
}

function j
{
    case "$1" in
        *)   cd "${ROOTDIR}/$1" ;;
    esac
}

function push
{
    git push v128 HEAD:refs/heads/master "$@"
}

function set-platform
{
    case "$1" in
        udoo)
            export PLATFORM=udoo
            ;;

        pi)
            export PLATFORM=pi
            ;;

        *)
            echo "Unknown platform [$1]."
            echo "Valid platforms are: udoo, pi"
            return 1
            ;;
    esac

    echo "PLATFORM set to [$PLATFORM]"
}

set-platform pi
