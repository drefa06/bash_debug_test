#!/bin/bash
set -e

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
    echo ""
}

###################################################################################
parse_args()
{
    TEMP=`getopt -o hl:v --long help,logfile:version -- "$@"`

    if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

    eval set -- "$TEMP"

    while true ; do
        case "$1" in
            -h|--help)
                usage; exit 0;  shift;;
            -v|--version)
                echo "version: $VERSION"; exit 0; shift;;
            -l|--logfile)
                LOGFILE=$2;  shift 2;;
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

    if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi #remove new log file if exist
    #We can start to log now

    echo "Analyse input argument" | tee -a ${LOGFILE}
    echo "    Logfile:        ${LOGFILE}" | tee -a ${LOGFILE}
    echo "    Mandatory args: ${ARGS_MANDATORY[@]}" | tee -a ${LOGFILE}


}

###################################################################################
gen_err_1()
{
    echo "gen_err_1: START" >> ${LOGFILE} # log only
    value1="bar baz"
    value2="bar"
    echo "test gen_err_1: if [ $value1 == $value2 ] #too much arguments"
    if [ $value1 == $value2 ]; then
        echo "$value1==$value2"
    else
        echo "$value1!=$value2"
    fi
    echo "gen_err_1: No Error, continue script" | tee -a ${LOGFILE} #log and screen
    echo "gen_err_1: END" >> ${LOGFILE}

}

###################################################################################
gen_err_2()
{
    echo "gen_err_2: START" >> ${LOGFILE}
    value1="bar baz"
    value2="bar"
    echo "test gen_err_2: if [ $value1 == $value2] #missing space before ]"
    if [ $value1 == $value2]; then
        echo "$value1==$value2"
    else
        echo "$value1!=$value2"
    fi
    echo "gen_err_2: No Error, continue script" | tee -a ${LOGFILE}
    echo "gen_err_2: END" >> ${LOGFILE}
}

###################################################################################
gen_err_3()
{
    echo "gen_err_3: START" >> ${LOGFILE}
    echo "Generate an error"
    echo hello | grep $foo
    echo "gen_err_3: No Error, continue script" | tee -a ${LOGFILE}
    echo "gen_err_3: END" >> ${LOGFILE}
}

###################################################################################
gen_err_4()
{
    echo "gen_err_4: START" >> ${LOGFILE}
    more $foo
    echo "gen_err_4: No Error, continue script" | tee -a ${LOGFILE}
    echo "gen_err_4: END" >> ${LOGFILE}
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
        echo "### ERROR ### `cat ${func_name}.err`"
        rm -f ${func_name}.err
        exit 1
    fi
    
    return $rc
}

###################################################################################
function PostProcess()
{
    echo "### EXIT ### Cleaning Process before exit"
    #Add here what you need to be sure after exiting the script
    rm -f ${ME%.*}.tmp ${ME%.*}.err
    echo "### EXIT ### DONE BYE"
}

###################################################################################
###################################################################################
### 
###                                 MAIN
### 
###################################################################################
#create a tmp file.
trap 'PostProcess $?' EXIT #trap exit

VERSION="0.1"

ME=$(basename -- "$0")

TMP_FILE="${ME%.*}.tmp"
start_time=$(date +%s%N)
echo "INPUT_ARG=$@" >> ${TMP_FILE}

#Starts script with input argument analysis
LOGFILE="${ME%.*}.log"  #default logfile name   => modified by -l|--log <log_file>
ERRFILE="${ME%.*}.err"
if [ -f ${ERRFILE} ]; then rm -f ${ERRFILE}; fi

declare -a ARGS_MANDATORY=( "" )  #init non-option argument

##############################################################################
#Parse input argument
parse_args "$@"
##############################################################################

echo "parse_args Done" > ${LOGFILE}

#Put some element in tmp file
echo "LOGFILE=${LOGFILE}" | tee -a ${TMP_FILE} | tee -a ${LOGFILE}
echo "MANDATORY=${ARGS_MANDATORY[@]}" | tee -a ${TMP_FILE} | tee -a ${LOGFILE}
duration=$(($(date +%s%N)-${start_time}))
echo_duration $duration

#starts to proceed script
echo "SLEEP 5 => if you want to test Ctrl+C ... please do it at least one" | tee -a ${LOGFILE}
sleep 5

start_time=$(date +%s%N)

echo ""
#Call and execute functions in ARGS_MANDATORY
# =>1/ either by direct call of ${ARGS_MANDATORY[@]}
#      for err_type in `echo ${ARGS_MANDATORY[@]}`; do
# =>2/ nor by getting them from our tmp file... our solution
for err_type in `cat ${TMP_FILE} | grep "MANDATORY=" | awk -F= '{ print $2 }'`; do
    ARGS_MANDATORY=( ${ARGS_MANDATORY[@]/${err_type}/} )
    echo "EXECUTE: ${err_type}" | tee -a ${LOGFILE}

    if [ "${err_type}" == "gen_err_1" ]; then 
        call ${err_type} #exit 1 if any error found 
    else
        eval ${err_type} 2>> $ERRFILE #continue script until the end
    fi

    echo "sleep 5 => if you want to test Ctrl+C ... just for fun, but let the script finish at least once" | tee -a ${LOGFILE}
    sleep 5

    echo ""
done
duration=$(($(date +%s%N)-${start_time}))
echo_duration $duration | tee -a ${TMP_FILE}

echo "End Execution, SLEEP 5sec more before ending"
sleep 5

#print then remove tmp file before exit
echo "Content of ${TMP_FILE}:"
cat ${TMP_FILE}
echo "Remove ${TMP_FILE}" | tee -a ${LOGFILE}
rm -f ${TMP_FILE}

#exit 2 for any error that do not stop script
if [ `cat $ERRFILE | wc -l` -ne 0 ]; then
    echo "Non Critical error found during execution:"
    cat $ERRFILE
    exit 2
else
    echo "WELL DONE, BYE" | tee -a ${LOGFILE}
fi

