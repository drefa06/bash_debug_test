#!/bin/bash

###################################################################################
## 
###################################################################################
usage()
{
    echo "usage: script_evo_1.sh [OPTION] <arg1> [<arg2> ... [<argN>]]"
    echo ""
    echo "[OPTION]"
    echo "    -h | --help:                Print this usage"
    echo "    -v | --version:             Print version"
    echo "    -l | --logfile <filename>:  Logfile to use"
    echo "    -d | --debug <debug_level>: Debug level traces"
    echo "                                0 = no debug"
    echo "                                1 = echo_debug traces only"
    echo "                                2 = echo_debug + set -x traces"
    echo ""
}

###################################################################################
parse_args()
{
    TEMP=`getopt -o hl:vd: --long help,logfile:,version,debug: -- "$@"`

    if [ $? != 0 ] ; then echo_error "Terminating..." >&2 ; exit 1 ; fi

    eval set -- "$TEMP"

    while true ; do
        case "$1" in
            -h|--help)
                usage; exit 0;  shift;;
            -v|--version)
                echo "version: $VERSION"; exit 0; shift;;
            -l|--logfile)
                LOGFILE=$2;  shift 2;;
            -d|--debug) 
                DEBUG_LEVEL=$2; shift 2;;
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

    if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi #remove new log file if exist
    #We can start to log now

    echo_debug "DONE parse_args"
    echo_log "Analyse input argument"
    echo_log "   Logfile:        ${LOGFILE}"
    echo_log "   Debug Level:    ${DEBUG_LEVEL}"
    echo_log "   Mandatory args: ${ARGS_MANDATORY[@]}"

}

###################################################################################
gen_err_1()
{
    echo_debug "gen_err_1: START"

    echo_log "gen_err_1: Do something before"
    sleep 1

    value1="bar baz"
    value2="bar"
    
    if [ $value1 == $value2 ]; then
        echo_log "$value1==$value2"
    else
        echo_log "$value1!=$value2"
    fi

    echo_log "gen_err_1: Do something after"
    sleep 2

    echo_info "gen_err_1: No Error, continue script"
    echo_debug "gen_err_1: END"

}
###################################################################################
gen_good_1()
{
    echo_debug "gen_good_1: START"

    echo_log "gen_good_1: Do something before"
    sleep 2

    value1="bar"
    value2="bar"

    if [ $value1 == $value2 ]; then
        echo_log "$value1==$value2"
    else
        echo_log "$value1!=$value2"
    fi

    echo_log "gen_good_1: Do something after"
    sleep 3

    echo_info "gen_good_1: No Error, continue script"
    echo_debug "gen_good_1: END"

}
###################################################################################
gen_err_2()
{
    echo_debug "gen_err_2: START"

    echo_log "gen_err_2: Do something before"
    sleep 1

    value1="bar baz"
    value2="bar"

    if [ $value1 == $value2]; then
        echo_log "$value1==$value2"
    else
        echo_log "$value1!=$value2"
    fi

    echo_log "gen_err_2: Do something after"
    sleep 3

    echo_info "gen_err_2: No Error, continue script"
    echo_debug "gen_err_2: END"
}

###################################################################################
gen_err_3()
{
    echo_debug "gen_err_3: START"

    echo "gen_err_3: Do something before"
    sleep 3

    echo "Generate an error"
    echo hello | grep $foo


    echo "gen_err_3: Do something after"
    sleep 1

    echo_info "gen_err_3: No Error, continue script"
    echo_debug "gen_err_3: END"
}

###################################################################################
gen_err_4()
{
    echo_debug "gen_err_4: START"

    echo_log "gen_err_4: Do something before"
    sleep 2

    more $foo


    echo_log "gen_err_4: Do something after"
    sleep 2

    echo_info "gen_err_4: No Error, continue script"
    echo_debug "gen_err_4: END"
}


###################################################################################
echo_duration()
{
    local duration=$1

    ((duration/=1000,usec=duration%1000,duration/=1000, msec=duration%1000))
    hms=`date -u -d @${duration/1000000000} +"%T"`
    printf "duration = %s.%03d%03d\n" $hms $msec $usec | tee -a ${LOGFILE}

}


###################################################################################
call()
{
    func_name=$1
    shift
    func_args="$@"
    eval ${func_name} "${func_args}" 2> ${func_name}.err
    rc=$?
    if [ -f ${func_name}.err -a "`cat ${func_name}.err`" != "" ]; then
        echo_error "### ERROR ### `cat ${func_name}.err`"
        rm -f ${func_name}.err
        exit 1
    fi
    
    return $rc
}

###################################################################################
function AbortProcess()
{
    echo_error "### ABORT ### Process aborted"
    echo_error "### ABORT ### During: $2 $3"
    echo_error "### ABORT ### exit 3"
    exit 3
}

###################################################################################
function PostProcess()
{
    echo_info "### EXIT ### Cleaning Process before exit"
    echo_info "### EXIT ### During: $2 $3"
    #Add here what you need to be sure after exiting the script
    rm -f ${ME%.*}.tmp ${ME%.*}.err
    echo_info "### EXIT ### DONE BYE"
}

###################################################################################
script()
{
    echo_debug "script: START"

    #starts to proceed script
    echo_warning "SLEEP 5 => if you want to test Ctrl+C ... please do it at least one"
    sleep 5

    start_time=$(date +%s%N)

    echo ""
    #Call and execute functions in ARGS_MANDATORY
    # =>1/ either by direct call of ${ARGS_MANDATORY[@]}
    #      for err_type in `echo ${ARGS_MANDATORY[@]}`; do
    # =>2/ nor by getting them from our tmp file... our solution
    for err_type in `cat ${TMP_FILE} | grep "MANDATORY=" | awk -F= '{ print $2 }'`; do
        ARGS_MANDATORY=( ${ARGS_MANDATORY[@]/${err_type}/} )
        echo_info "EXECUTE: ${err_type}"

        call ${err_type}

        #if [ "${err_type}" == "gen_err_1" ]; then 
        #    call ${err_type} #exit 1 if any error found 
        #else
        #    eval ${err_type} 2>> $ERRFILE #continue script until the end
        #fi

        echo_warning "sleep 5 => if you want to test Ctrl+C ... just for fun, but let the script finish at least once"
        sleep 5
    
        echo ""
    done
    duration=$(($(date +%s%N)-${start_time}))
    echo_duration $duration | tee -a ${TMP_FILE}

    echo "End Execution, SLEEP 5sec more before ending"
    sleep 5

    #print then remove tmp file before exit
    echo_log "Content of ${TMP_FILE}:"
    cat ${TMP_FILE}  | tee -a ${LOGFILE}
    echo_log "Remove ${TMP_FILE}"
    rm -f ${TMP_FILE}

    #exit 2 for any error that do not stop script
    if [ `cat $ERRFILE | wc -l` -ne 0 ]; then
        echo_warning "Non Critical error found during execution:"
        cat $ERRFILE | tee -a ${LOGFILE}
        echo_debug "script: exit 2"

        exit 2
    else
        echo_log "WELL DONE, BYE"
    fi

    echo_debug "script: END"

}

###################################################################################
main()
{
    VERSION="0.1"

    ME=$(basename -- "$0")

    TMP_FILE="${ME%.*}.tmp"
    start_time=$(date +%s%N)
    echo "INPUT_ARG=$@" >> ${TMP_FILE}

    #Starts script with input argument analysis
    LOGFILE="${ME%.*}.log"  #default logfile name   => modified by -l|--log <log_file>
    if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi
    ERRFILE="${ME%.*}.err"
    if [ -f ${ERRFILE} ]; then rm -f ${ERRFILE}; fi

    DEBUG_LEVEL=0         #default debug level    =>             -d|--debug <debug_level>
    DEBUG_EN="no"         #default debug log echo => is yes for DEBUG_LEVEL=1 or 2

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

    declare -a ARGS_MANDATORY=( "" )  #init non-option argument

    ##############################################################################
    #Parse input argument
    parse_args "$@"
    ##############################################################################

    echo_debug "parse_args Done"

    #Put some element in tmp file
    echo_log "LOGFILE=${LOGFILE}" | tee -a ${TMP_FILE}
    echo_log "MANDATORY=${ARGS_MANDATORY[@]}" | tee -a ${TMP_FILE}
    duration=$(($(date +%s%N)-${start_time}))
    echo_duration $duration

    script
}

###################################################################################
###################################################################################
### 
###                                 MAIN
### 
###################################################################################
#create a tmp file.
source lib/utils.sh    #include utils tools

if [ "`echo $@ | grep '\-\-source'`" == "" ]; then # For usual execution
    set -e

    trap 'PostProcess $? ${BASH_SOURCE}:${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' EXIT #trap exit
    trap 'AbortProcess $? ${BASH_SOURCE}:${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' SIGINT SIGTERM SIGKILL

    main "${@}"
fi

