#!/bin/bash

#########################################################################
test_1()
{
    echo_info "#########################################################################"
    echo_info "### TEST 1: ./script_final.sh"
    ./script_final.sh > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"
    else test_result="NOK"
    fi
    echo_log "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'At least one argument is needed'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo_log "  reason: At least one argument is needed => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'usage:'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo_log "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo_log "  PostProcess => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""
}
#########################################################################
test_2()
{
    echo_info "#########################################################################"
    echo_info "### TEST 2: ./script_final.sh -h"
    ./script_final.sh -h > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ -z "`cat $TST_ERRFILE | grep 'At least one argument is needed'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  reason: None => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'usage:'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_3()
{
    echo_info "#########################################################################"
    echo_info "### TEST 3: ./script_final.sh --help"
    ./script_final.sh -h > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ -z "`cat $TST_ERRFILE | grep 'At least one argument is needed'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  reason: None => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'usage:'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_4()
{
    echo_info "#########################################################################"
    echo_info "### TEST 4: ./script_final.sh -x"
    ./script_final.sh -x > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'getopt : option invalide -- '`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  reason: bad option => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'usage:'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_5()
{
    echo_info "#########################################################################"
    echo_info "### TEST 5: ./script_final.sh --version"
    ./script_final.sh --version > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'version:'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  version print => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_6()
{
    echo_info "#########################################################################"
    echo_info "### TEST 6: ./script_final.sh -l test.log"
    ./script_final.sh -l test.log > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'At least one argument is needed'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  reason: Argument missing => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'usage:'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}

#########################################################################
test_7()
{
    echo_info "#########################################################################"
    echo_info "### TEST 7: ./script_final.sh -l test.log gen_err_1"
    ./script_final.sh -l test.log gen_err_1 > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_err_1'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_err_1 => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### ERROR ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f test.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "


    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_8()
{
    echo_info "#########################################################################"
    echo_info "### TEST 8: ./script_final.sh gen_err_2"
    ./script_final.sh gen_err_2 > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 2 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_err_2'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_err_2 => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### ERROR ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_final.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "


    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_9()
{
    echo_info "#########################################################################"
    echo_info "### TEST 9: ./script_final.sh gen_err_3 gen_err_4"
    ./script_final.sh gen_err_3 gen_err_4> $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 2 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_err_3'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_err_3 => $result"
    result="NOK"
    if [ -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_err_4'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  NOT EXECUTE: gen_err_4 => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### ERROR ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_final.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "


    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

} 
#########################################################################
test_10()
{
    echo_info "#########################################################################"
    echo_info "### TEST 10: ./script_final.sh gen_good_1 gen_err_4 gen_err_1"
    ./script_final.sh gen_good_1 gen_err_4 gen_err_1> $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_good_1 => $result"
    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_err_4'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_err_4 => $result"
    result="NOK"
    if [ -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_err_1'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  NOT EXECUTE: gen_err_1 => $result"

    result="NOK"
    if [ -z "`cat $TST_ERRFILE | grep '### ERROR ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_final.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "


    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_11()
{
    echo_info "#########################################################################"
    echo_info "### TEST 11: ./script_final.sh  gen_good_1 gen_err_1"
    echo_info "###          CTRL+C during process"
    ./generate_ctrl_c.sh script_final.sh 3 &
    ./script_final.sh gen_good_1 gen_err_1 > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 3 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  NOT EXECUTE: gen_good_1 => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### ABORT ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  AbortProcess => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_final.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_12()
{
    echo_info "#########################################################################"
    echo_info "### TEST 12: ./script_final.sh  gen_good_1 gen_err_1"
    echo_info "###          CTRL+C during process"
    ./generate_ctrl_c.sh script_final.sh 8 &
    ./script_final.sh gen_good_1 gen_err_1 > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 3 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_good_1 => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### ABORT ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  AbortProcess => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_final.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_13()
{
    echo_info "#########################################################################"
    echo_info "### TEST 13: ./script_final.sh  gen_good_1 gen_err_1"
    echo_info "###          CTRL+C during process"
    ./generate_ctrl_c.sh script_final.sh 12 &
    ./script_final.sh gen_good_1 gen_err_1 > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 3 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_good_1 => $result"
    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: gen_err_1'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  EXECUTE: gen_err_1 => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### ABORT ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  AbortProcess => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_final.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_14()
{
    echo_info "#########################################################################"
    echo_info "### TEST 14: ./script_final.sh acme"
    ./script_final.sh acme > $TST_ERRFILE 2>&1
    rc=$?

    test_result="OK"

    result="NOK"
    if [ $rc -eq 127 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep 'EXECUTE: acme'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  NOT EXECUTE: acme => $result"

    result="NOK"
    if [ -z "`cat $TST_ERRFILE | grep '### ERROR ###'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $TST_ERRFILE | grep '### EXIT ### DONE BYE'`" ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_final.log ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  logfile exist => $result "

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}

#########################################################################
#From this point, all following test will know functions of script_final.sh
source script_final.sh --source

#########################################################################
test_15()
{
    echo_info "#########################################################################"
    echo_info "### TEST 15: inside function gen_err_1"

    test_result="OK"

    #Need to init global variable used in function to test and other function that can be used by this function execution
    ME=script_final
    LOGFILE=script_final.log

    #1st: Call the function like a subshell, check if no script error happen, with input var if needed
    TST_call gen_err_1
    rc=$?

    #Analyse the result code and global variable modified if needed
    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    #May be need to reinit some elements before next test

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}

#########################################################################
test_16()
{
    echo_info "#########################################################################"
    echo_info "### TEST 16: inside function gen_good_1"

    test_result="OK"

    #Need to init global variable used in function to test and other function that can be used by this function execution
    ME=script_final
    LOGFILE=script_final.log

    #1st: Call the function like a subshell, check if no script error happen, with input var if needed
    TST_call gen_good_1
    rc=$?

    #Analyse the result code and global variable modified if needed
    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    #May be need to reinit some elements before next test

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_17()
{
    echo_info "#########################################################################"
    echo_info "### TEST 17: inside function gen_err_2"

    test_result="OK"

    #Need to init global variable used in function to test and other function that can be used by this function execution
    ME=script_final
    LOGFILE=script_final.log

    #1st: Call the function like a subshell, check if no script error happen, with input var if needed
    TST_call gen_err_2
    rc=$?

    #Analyse the result code and global variable modified if needed
    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    #May be need to reinit some elements before next test

    if [ "$test_result"=="OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_18()
{
    echo_info "#########################################################################"
    echo_info "### TEST 18: inside function gen_err_3"

    test_result="OK"

    #Need to init global variable used in function to test and other function that can be used by this function execution
    ME=script_final
    LOGFILE=script_final.log

    #1st: Call the function like a subshell, check if no script error happen, with input var if needed
    TST_call gen_err_3
    rc=$?

    #Analyse the result code and global variable modified if needed
    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    #May be need to reinit some elements before next test

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
#########################################################################
test_19()
{
    echo_info "#########################################################################"
    echo_info "### TEST 19: inside function gen_err_4"

    test_result="OK"

    #Need to init global variable used in function to test and other function that can be used by this function execution
    ME=script_final
    LOGFILE=script_final.log

    #1st: Call the function like a subshell, check if no script error happen, with input var if needed
    TST_call gen_err_4
    rc=$?

    #Analyse the result code and global variable modified if needed
    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"
    else test_result="NOK"
    fi
    echo "  return code: $rc => $result"

    #May be need to reinit some elements before next test

    if [ "$test_result" == "OK" ]; then echo_info "TEST => [OK]"
    else echo_error "TEST => [NOK]"
    fi

    echo_log ""

}
###################################################################################
TST_call()
{
    func_name=$1
    shift
    func_args="$@"
    eval ${func_name} "${func_args}" 2> ${func_name}.err
    rc=$?
    if [ -f ${func_name}.err -a "`cat ${func_name}.err`" != "" ]; then
        echo_error "### ERROR ### in function ${func_name}"
        echo_error "### ERROR ### `cat ${func_name}.err`"
        rm -f ${func_name}.err
        return 1
    fi
    
    return $rc
}

###################################################################################
function TST_AbortProcess()
{
    echo_error "### ABORT ### Process aborted"
    echo_error "### ABORT ### During: $2 $3"
    echo_error "### ABORT ### exit 3"
    exit 3
}

###################################################################################
function TST_PostProcess()
{
    if [ -f $2.err ] && [ "`cat $2.err`" != "" ]; then
        echo_error "### ERROR ### in function $2"
        echo_error "### ERROR ### `cat $2.err`"
        rm -f $2.err
    fi 

    echo_info "### EXIT ### Cleaning Process before exit"
}

###################################################################################
###################################################################################
### 
###                                 MAIN
### 
###################################################################################
source lib/utils.sh    #include utils tools

trap 'TST_PostProcess $? ${FUNCNAME[0]:+${FUNCNAME[0]}}' EXIT #trap exit
trap 'TST_AbortProcess $? ${BASH_SOURCE}:${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' SIGINT SIGTERM SIGKILL


TST_ME=$(basename -- "$0")

LOGFILE="${ME%.*}.log"  #default logfile name   => modified by -l|--log <log_file>
if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi
TST_ERRFILE="${TST_ME%.*}.err"
if [ -f ${TST_ERRFILE} ]; then rm -f ${TST_ERRFILE}; fi

TST_LIST=`cat $TST_ME | grep '^test_[0-9]*()' | cut -d\( -f1`
declare -a TST_ARGS=( "" )



if [ ${#@} -lt 1 ]; then
    TST_ARGS=( "${TST_LIST[@]}" )
else
    TST_ARGS=( "$@" )
fi

for tst_name in ${TST_ARGS[@]}; do
    eval $tst_name
done


