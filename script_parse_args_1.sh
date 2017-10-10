usage()
{
    echo "usage: script.sh [OPTION] <arg1> [<arg2> ... [<argN>]]"
    echo ""
    echo "[OPTION]"
    echo "    -h | --help:                Print this usage"
    echo "    -v | --version:             Print script version"
    echo "    -l | --logfile <filename>:  Logfile to use"
    echo ""
}

#!/bin/bash

parse_args()
{
    TEMP=`getopt -o hl:v --long help,logfile:,version -- "$@"`

    if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

    eval set -- "$TEMP"

    while true ; do
        case "$1" in
            -h|--help)
                usage; exit 0;  shift;;
            -v|--version)
                echo $VERSION; exit 0;  shift;;
            -l|--logfile)
                LOGFILE=$2;     shift 2;;
            \? )
                echo "Invalid Option: -$OPTARG" 1>&2;;
            --) shift ; break ;;
            *) echo "Internal error!" ; exit 1 ;;
        esac
    done

    shift $((OPTIND-1))

    #For at least 1 element in ARG_MANDATORY
    if [ ${#@} -lt 1 ]; then
        echo "At least one argument is needed"
        usage;
        exit 1
    fi

    ARGS_MANDATORY=( "$@" "${ARGS_MANDATORY[@]}" )
}

#Starts script with input argument analysis
VERSION="0.1"
LOGFILE="script_parse_args_1.log"              #default logfile name   => modified by -l|--log <log_file>
declare -a ARGS_MANDATORY=( "" )  #init non-option arguments

parse_args "$@"

if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi #remove default log file if exist

echo "Parsed input argument"
echo "    Logfile:        ${LOGFILE}"
echo "    Mandatory args: ${ARGS_MANDATORY[@]}"
