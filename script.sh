#!/bin/bash
set -e

###################################################################################
## 
###################################################################################
usage()
{
    echo "usage: script.sh [OPTION] <arg1> [<arg2> ... [<argN>]]"
    echo ""
    echo "[OPTION]"
    echo "    -h | --help:                Print this usage"
    echo "    -d | --debug <debug_level>: Debug level traces"
    echo "                                0 = no debug"
    echo "                                1 = echo_debug traces only"
    echo "                                2 = echo_debug + set -x traces"
    echo "    -l | --logfile <filename>:  Logfile to use"
    echo ""
}

###################################################################################
gen_err_1()
{
    value1="bar baz"
    value2="bar"
    echo_log "test gen_err_1: if [ $value1 == $value2 ] #too much arguments"
    if [ $value1 == $value2 ]; then
        echo_info "$value1==$value2"
    else
        echo_error "$value1!=$value2"
    fi
    echo_log "Not a trapped error, continue script"

}

###################################################################################
gen_err_2()
{
    value1="bar baz"
    value2="bar"
    echo_log "test gen_err_2: if [ $value1 == $value2] #missing space before ]"
    if [ $value1 == $value2]; then
        echo_info "$value1==$value2"
    else
        echo_error "$value1!=$value2"
    fi
    echo_log "Not a trapped error, continue script"
}

###################################################################################
gen_err_3()
{
    echo_log "Generate an error"
    echo hello | grep foo
    echo_log "No trap, continue"
}

###################################################################################
gen_err_4()
{
    echo_log "Generate an error"
    echo $foo
    echo_log "No trap, continue"
}

###################################################################################
parse_args(){
    ## Analyse input parameter
    TEMP=`getopt -o hd:l: --long help,debug:,logfile: -- "$@"`

    if [ $? != 0 ] ; then echo_error "Terminating..." >&2 ; exit 1 ; fi

    eval set -- "$TEMP"

    while true ; do
        case "$1" in
            -d|--debug) 
                DEBUG_LEVEL=$2; shift 2;;
            -h|--help) 
                usage; exit 0;  shift;;
            -l|--logfile) 
                LOGFILE=$2;     shift 2;;
            \? )
                echo_error "Invalid Option: -$OPTARG" 1>&2;;
            --) shift ; break ;;
            *) echo_error "Internal error!" ; exit 1 ;;
        esac
    done

    shift $((OPTIND-1))

    #For at least 1 element in ARG_MANDATORY
    if [ ${#@} -lt 1 ]; then 
        echo_error "At least one argument is needed"
        usage;
        exit 1
    fi

    ARGS_MANDATORY=( "$@" "${ARGS_MANDATORY[@]}" )
    
    echo_debug "DONE parse_args"
    echo_log "Analyse input argument"
    echo_log "Logfile:        ${LOGFILE}"
    echo_log "Debug Level:    ${DEBUG_LEVEL}"
    echo_log "Mandatory args: ${ARGS_MANDATORY[@]}"
}
###################################################################################
###################################################################################
### 
###                                 MAIN
### 
###################################################################################
script()
###################################################################################
{
    LOGFILE="script.log"  #default logfile name   => modified by -l|--log <log_file>
    DEBUG_LEVEL=0         #default debug level    =>             -d|--debug <debug_level>
    DEBUG_EN="yes"        #default debug log echo => is yes for DEBUG_LEVEL=1 or 2
    if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi #remove default log file if exist

    declare -a ARGS_MANDATORY=( "" )  #init non-option argument

    #Parse input argument
    parse_args "$@"

    if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi # For modified log file

    if [ $DEBUG_LEVEL -eq 0 ]; then
        #if debug level is 0 (-d0) xtrace=off
        set +x
        
    elif [ $DEBUG_LEVEL -eq 1 ]; then
        #if debug level is 1 (-d1) xtrace=off but debug log (echo_debug) is on
        DEBUG_EN="yes"
        set +x

    elif [ $DEBUG_LEVEL -ge 2 ]; then
        #if debug level is 2 (-d2) xtrace and debug log (echo_debug) are on
        DEBUG_EN="yes"
        #export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
        #exec 3>&2 2> $LOGFILE
        exec {BASH_XTRACEFD}>>"$LOGFILE"
        set -x
    fi

    #From this point, you can start to use echo_debug and see the result in logfile
    echo_debug "start your process"

    echo_log "sleep 5 => if you want to test Ctrl+C ..."
    sleep 5

    echo_log ""
    for err_type in `echo ${ARGS_MANDATORY[@]}`; do
        echo_debug "err_type = ${err_type}"
        ARGS_MANDATORY=( ${ARGS_MANDATORY[@]/${err_type}/} )
        echo_info "Execute ${err_type}"
        eval ${err_type}

        echo_log "sleep 5 => if you want to test Ctrl+C ..."
        sleep 5

        echo_log ""
    done

    exit 0
}

###################################################################################
function AbortProcess()
###################################################################################
# specific treatment for process abort
{
    echo_error "Process Aborted"
    exit 0
}

###################################################################################
function PostProcess()
###################################################################################
# cleaning before exit
{
    echo_info "Cleaning Process"
}

###################################################################################
### Script starts here
###################################################################################
source lib/utils.sh    #include utils tools
source lib/trap.sh     #include general traping solution

trap AbortProcess SIGINT SIGTERM SIGKILL #Call AbortProcess for a ctrl+C


script "$@"        #I used to call the 'main' script with same name of file
