#!/bin/bash
set -e

#########################################################################
test_1()
{
    echo "#########################################################################"
    echo "### TEST 1: ./script_evo_5.sh"
    ./script_evo_5.sh > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'At least one argument is needed'`" ]; then result="OK"; fi
    echo "  reason: At least one argument is needed => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'usage:'`" ]; then result="OK"; fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    echo ""
}
#########################################################################
test_2()
{
    echo "#########################################################################"
    echo "### TEST 2: ./script_evo_5.sh -h"
    ./script_evo_5.sh -h > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ -z "`cat $SCRIPT_ERR | grep 'At least one argument is needed'`" ]; then result="OK"; fi
    echo "  reason: None => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'usage:'`" ]; then result="OK"; fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    echo ""
}
#########################################################################
test_3()
{
    echo "#########################################################################"
    echo "### TEST 3: ./script_evo_5.sh --help"
    ./script_evo_5.sh -h > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ -z "`cat $SCRIPT_ERR | grep 'At least one argument is needed'`" ]; then result="OK"; fi
    echo "  reason: None => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'usage:'`" ]; then result="OK"; fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    echo ""
}
#########################################################################
test_4()
{
    echo "#########################################################################"
    echo "### TEST 4: ./script_evo_5.sh -x"
    ./script_evo_5.sh -x > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'getopt : option invalide -- '`" ]; then result="OK"; fi
    echo "  reason: bad option => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'usage:'`" ]; then result="OK"; fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    echo ""
}
#########################################################################
test_5()
{
    echo "#########################################################################"
    echo "### TEST 5: ./script_evo_5.sh --version"
    ./script_evo_5.sh --version > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 0 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'version:'`" ]; then result="OK"; fi
    echo "  version print => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    echo ""
}
#########################################################################
test_6()
{
    echo "#########################################################################"
    echo "### TEST 6: ./script_evo_5.sh -l test.log"
    ./script_evo_5.sh -l test.log > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'At least one argument is needed'`" ]; then result="OK"; fi
    echo "  reason: Argument missing => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'usage:'`" ]; then result="OK"; fi
    echo "  usage print => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    echo ""
}

#########################################################################
test_7()
{
    echo "#########################################################################"
    echo "### TEST 7: ./script_evo_5.sh -l test.log gen_err_1"
    ./script_evo_5.sh -l test.log gen_err_1 > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_err_1'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_err_1 => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### ERROR ###'`" ]; then result="OK"; fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f test.log ]; then result="OK"; fi
    echo "  logfile exist => $result "


    echo ""
}
#########################################################################
test_8()
{
    echo "#########################################################################"
    echo "### TEST 8: ./script_evo_5.sh gen_err_2"
    ./script_evo_5.sh gen_err_2 > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 2 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_err_2'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_err_2 => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### ERROR ###'`" ]; then result="OK"; fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_evo_5.log ]; then result="OK"; fi
    echo "  logfile exist => $result "


    echo ""
}
#########################################################################
test_9()
{
    echo "#########################################################################"
    echo "### TEST 9: ./script_evo_5.sh gen_err_3 gen_err_4"
    ./script_evo_5.sh gen_err_3 gen_err_4> $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 2 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_err_3'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_err_3 => $result"
    result="NOK"
    if [ -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_err_4'`" ]; then result="OK"; fi
    echo "  NOT EXECUTE: gen_err_4 => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### ERROR ###'`" ]; then result="OK"; fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_evo_5.log ]; then result="OK"; fi
    echo "  logfile exist => $result "


    echo ""
} 
#########################################################################
test_10()
{
    echo "#########################################################################"
    echo "### TEST 10: ./script_evo_5.sh gen_good_1 gen_err_4 gen_err_1"
    ./script_evo_5.sh gen_good_1 gen_err_4 gen_err_1> $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 1 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_good_1 => $result"
    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_err_4'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_err_4 => $result"
    result="NOK"
    if [ -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_err_1'`" ]; then result="OK"; fi
    echo "  NOT EXECUTE: gen_err_1 => $result"

    result="NOK"
    if [ -z "`cat $SCRIPT_ERR | grep '### ERROR ###'`" ]; then result="OK"; fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_evo_5.log ]; then result="OK"; fi
    echo "  logfile exist => $result "


    echo ""
}
#########################################################################
test_11()
{
    echo "#########################################################################"
    echo "### TEST 11: ./script_evo_5.sh  gen_good_1 gen_err_1"
    echo "###          CTRL+C during process"
    ./generate_ctrl_c.sh script_evo_5.sh 3 &
    ./script_evo_5.sh gen_good_1 gen_err_1 > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 3 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"; fi
    echo "  NOT EXECUTE: gen_good_1 => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### ABORT ###'`" ]; then result="OK"; fi
    echo "  AbortProcess => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_evo_5.log ]; then result="OK"; fi
    echo "  logfile exist => $result "

    echo ""
}
#########################################################################
test_12()
{
    echo "#########################################################################"
    echo "### TEST 12: ./script_evo_5.sh  gen_good_1 gen_err_1"
    echo "###          CTRL+C during process"
    ./generate_ctrl_c.sh script_evo_5.sh 8 &
    ./script_evo_5.sh gen_good_1 gen_err_1 > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 3 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_good_1 => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### ABORT ###'`" ]; then result="OK"; fi
    echo "  AbortProcess => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_evo_5.log ]; then result="OK"; fi
    echo "  logfile exist => $result "

    echo ""
}
#########################################################################
test_13()
{
    echo "#########################################################################"
    echo "### TEST 13: ./script_evo_5.sh  gen_good_1 gen_err_1"
    echo "###          CTRL+C during process"
    ./generate_ctrl_c.sh script_evo_5.sh 12 &
    ./script_evo_5.sh gen_good_1 gen_err_1 > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 3 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_good_1'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_good_1 => $result"
    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: gen_err_1'`" ]; then result="OK"; fi
    echo "  EXECUTE: gen_err_1 => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### ABORT ###'`" ]; then result="OK"; fi
    echo "  AbortProcess => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_evo_5.log ]; then result="OK"; fi
    echo "  logfile exist => $result "

    echo ""
}
#########################################################################
test_14()
{
    echo "#########################################################################"
    echo "### TEST 14: ./script_evo_5.sh acme"
    ./script_evo_5.sh acme > $SCRIPT_ERR 2>&1
    rc=$?

    result="NOK"
    if [ $rc -eq 127 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep 'EXECUTE: acme'`" ]; then result="OK"; fi
    echo "  NOT EXECUTE: acme => $result"

    result="NOK"
    if [ -z "`cat $SCRIPT_ERR | grep '### ERROR ###'`" ]; then result="OK"; fi
    echo "  Error found => $result "

    result="NOK"
    if [ ! -z "`cat $SCRIPT_ERR | grep '### EXIT ### DONE BYE'`" ]; then result="OK"; fi
    echo "  PostProcess => $result "

    result="NOK"
    if [ -f script_evo_5.log ]; then result="OK"; fi
    echo "  logfile exist => $result "

    echo ""
}
#########################################################################
test_15()
{
    echo "#########################################################################"
    echo "### TEST 15: inside function gen_err_1"

    #From this point, all following test will know functions of script_evo_5.sh
    source script_evo_5.sh --source

    #Need to init global variable used in function to test and other function that can be used by this function execution
    ME=script_evo_5
    LOGFILE=script_evo_5.log

    #1st: Call the function like a subshell, check if no script error happen, with input var if needed
    eval gen_err_1 > $SCRIPT_ERR 2>&1
    rc=$?

    cat $SCRIPT_ERR

    #Analyse the result code and global variable modified if needed
    result="NOK"
    if [ $rc -ne 0 ]; then result="OK"; fi
    echo "  return code: $rc => $result"

    #May be need to reinit some elements before next test

    echo ""
}

###################################################################################
function TST_AbortProcess()
{
    echo "### ABORT ### Process aborted"
    echo "### ABORT ### During: $2 $3"
    echo "### ABORT ### exit 3"
    exit 3
}

###################################################################################
function TST_PostProcess()
{
    echo "### ERROR ### Script issue found" > $SCRIPT_ERR 2>&1
}

###################################################################################
###################################################################################
### 
###                                 MAIN
### 
###################################################################################
trap 'TST_PostProcess $?' EXIT #trap exit
trap 'TST_AbortProcess $? ${BASH_SOURCE}:${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' SIGINT SIGTERM SIGKILL

SCRIPT_ERR="script_evo_5_test.err"

TST_ME=$(basename -- "$0")
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


