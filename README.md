# Bash script with error management, debug and test.

## Purpose

When you create a bash script, depending of the length and complexity of the script, 
the debug/test/error management may be considered differently.

The following examples shows differents cases from a basic script to a more complex one.

## Basic script

see script_basic.sh

Most of case you need to create a bash script that execute some operations. In this example, I only do some basic tests that contains script issues.

For this basic case, the sript is short so the best solution is to print out the lines during execution with xTrace.
2 solutions:
 - Add set -x / set +x in the script, around the part to debug. it print only the lines uncapsulated by set -x/+x.
 - launch the script with bash -x <script_name>. It print all the lines executed of the script.

Example 1 with script_basic.sh
```
#!/bin/bash

echo "Test1"
set -x
    value1="bar baz"
    value2="bar"
    echo "test gen_err_1: if [ $value1 == $value2 ] #too much arguments"
    if [ $value1 == $value2 ]; then
        echo "$value1==$value2"
    else
        echo "$value1!=$value2"
    fi
    echo "gen_err_1: No Error, continue script"
set +x

    value1="bar baz"
    value2="bar"
    echo "test gen_err_2: if [ $value1 == $value2] #missing space before ]"
    if [ $value1 == $value2]; then
        echo "$value1==$value2"
    else
        echo "$value1!=$value2"
    fi
    echo "gen_err_2: No Error, continue script"
```

Execution: print only detailed lines of part encapsulated by set -x / set +x

```
> bash ./script_basic.sh
### Test1 ###
+ value1='bar baz'
+ value2=bar
+ echo 'test gen_err_1: if [ bar baz == bar ] #too much arguments'
test gen_err_1: if [ bar baz == bar ] #too much arguments
+ '[' bar baz == bar ']'
./script_basic_basic.sh: ligne 8 : [: trop d'arguments
+ echo 'bar baz!=bar'
bar baz!=bar
+ echo 'gen_err_1: No Error, continue script'
gen_err_1: No Error, continue script
+ set +x
### Test2 ###
test gen_err_2: if [ bar baz == bar] #missing space before ]
./script_basic_basic.sh: ligne 20 : [: « ] » manquant
bar baz!=bar
gen_err_2: No Error, continue script

```

example 2: remove the set -x / set +x and launch script like
Execution type2: print all lines with detail

```
> bash -x ./script_basic.sh
+ set -e
+ echo '### Test1 ###'
### Test1 ###
+ set -x
+ value1='bar baz'
+ value2=bar
+ echo 'test gen_err_1: if [ bar baz == bar ] #too much arguments'
test gen_err_1: if [ bar baz == bar ] #too much arguments
+ '[' bar baz == bar ']'
./script_basic_basic.sh: ligne 9 : [: trop d'arguments
+ echo 'bar baz!=bar'
bar baz!=bar
+ echo 'gen_err_1: No Error, continue script'
gen_err_1: No Error, continue script
+ echo '### Test2 ###'
### Test2 ###
+ value1='bar baz'
+ value2=bar
+ echo 'test gen_err_2: if [ bar baz == bar] #missing space before ]'
test gen_err_2: if [ bar baz == bar] #missing space before ]
+ '[' bar baz == 'bar]'
./script_basic_basic.sh: ligne 20 : [: « ] » manquant
+ echo 'bar baz!=bar'
bar baz!=bar
+ echo 'gen_err_2: No Error, continue script'
gen_err_2: No Error, continue script
```

## Basic with functions and input argument

When your script size increase to more than 100 lines or is enhanced with some functions and/or input argument management, 
it can be interresting to have a test scripts to be executed regularly and enhanced to follow modif under script.

For debug I suggest to continue using set -x / set +x as previously around part to test and to redirect output to file for analysis.

### About functions
Creating functions permit to recall same parts or simply split the script in blocks but be carrefull on:
- How you call the function
- local/global parameter

In the following we will treat this cases and also introduce the input argument parsing.

#### General function
let's create a function that accept 1 input parameter, use local and global parameter (and modify them), print a value and return an other value.

```
func_name()
{
    local param1=2
    PARAM2=3
    PARAM3=$1

    PARAM3=$(($PARAM3+$param1))

    echo $param1
    return $(($param1*2))
}

param1=1
PARAM2=2

PARAM4=`func_name 3` #called as sub-shell, do not change global var
PARAM5=$?
echo "PARAM1 = $param1"
echo "PARAM2 = $PARAM2"
echo "PARAM3 = $PARAM3"
echo "PARAM4 = $PARAM4"
echo "PARAM5 = $PARAM5"

func_name 3 > func_name.log 2>&1  #executed directly but redirect result and errors under file that must be analysed later
PARAM4=`cat func_name.log`
PARAM5=$?
echo "PARAM1 = $param1"
echo "PARAM2 = $PARAM2"
echo "PARAM3 = $PARAM3"
echo "PARAM4 = $PARAM4"
```

Execution:

```
$ bash script_func.sh
### Test 1 ###
PARAM1 = 1 # Same as before calling, param1 in func is local
PARAM2 = 2 # Not changed because func is called as sub-shell => all var in func are local
PARAM3 =   # Empty because not init before calling and func is
PARAM4 = 2 # is the echo result of func... be carrefull if more than 1 echo
PARAM5 = 4 # is the return, 0 by default if no error, 1 by default if error, $param1 * 2 in our case
### Test 2 ###
2          # The echo $param1
PARAM1 = 1 # Same as before calling, param1 in func is local
PARAM2 = 3 # Changed because global and func called in shell as source
PARAM3 = 5 # global var now modified
PARAM4 = 2 # is the $param1 printed in file func_name.log
PARAM5 = 4 # is the returned $param1*2
```

#### argument parsing
I usually create 2 specific functions for argument parsing: parse_args and usage.
For my script, I always put 2 basic options: help and version

```
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
LOGFILE="script.log"              #default logfile name   => modified by -l|--log <log_file>
declare -a ARGS_MANDATORY=( "" )  #init non-option arguments

parse_args "$@"

if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi #remove default log file if exist

echo "Parsed input argument"
echo "    Logfile:        ${LOGFILE}"
echo "    Mandatory args: ${ARGS_MANDATORY[@]}"

```

So here are the cases to test for input args:
- ./script_evo_1.sh          => No arg so error
- ./script_evo_1.sh -h
- ./script_evo_1.sh --help   => print usage, exit with error code = 0 
- ./script_evo_1.sh -v
- ./script_evo_1.sh --version   => print version, exit with error code = 0 
- ./script_evo_1.sh -l <log_file> <ARG1>
- ./script_evo_1.sh --logfile <log_file> <ARG1> => init log file with new value, remove it if exist and starts script
- ./script_evo_1.sh -z       => echo "Invalid Option: -z", exit with error code = 1
- ./script_evo_1.sh <ARG1> ... <ARGN>           => starts script with <ARG1> ... <ARGN>, default log file is used.


For some specific case you can have 2 or more sub-command that need their own options.
In this case you can create a general parse_args and its usage that list sub-command, and a parse_args/usage per sub-command.
You need also to create 1 function per sub-command.

```
usage_general()
{
    echo "usage: script.sh <sub_command> [sub_command OPTION] [<arg1> [<arg2> ... [<argN>]]]"
    echo "version = $VERSION"
    echo ""
    echo "script.sh help <sub_command> to print help for each <sub_command>"
    echo ""
    echo "<sub_command>"
    echo "    help:      Print this usage"
    echo "    help <sub_command>:      Print <sub_command> usage"
    echo "    execute:   Execute script"
    echo "    status:    give status"
    echo ""
}

usage_execute()
{
    echo "usage: script.sh execute [OPTION] <arg1> [<arg2> ... [<argN>]]"
    echo ""
    echo "[OPTION]"
    echo "    -h | --help:                Print this usage"
    echo "    -l | --logfile <filename>:  Logfile to use"
    echo ""
}

usage_status()
{
    echo "usage: script.sh status"
    echo ""
    echo "[OPTION]"
    echo "    -h | --help:                Print this usage"
    echo ""
}

parse_args_general()
{
    case "$1" in
        -h|--help) 
                usage_general; exit 0;  shift;;
        -v|--version) 
                echo $VERSION; exit 0;  shift;;
        help)
                if [ $# -eq 1 ]; then usage_general; exit 0;
                elif [ "$2" == "execute" ]; then usage_execute
                elif [ "$2" == "status" ]; then usage_status
                else echo "Invalid Sub Command: $2"
                fi
                shift;;
        execute)
                shift; parse_args_execute "$@";;
        status)
                shift; parse_args_status "$@";;

        \? )
                echo "Invalid Option: -$OPTARG" 1>&2;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac

    shift $((OPTIND-1))
}

parse_args_execute()
{
    SUB_COMMAND="execute"
    TEMP=`getopt -o hl: --long help,logfile: -- "$@"`

    if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

    eval set -- "$TEMP"

    while true ; do
        case "$1" in
            -h|--help)
                usage_execute; exit 0;  shift;;
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
parse_args_status()
{
    SUB_COMMAND="status"
    TEMP=`getopt -o h --long help -- "$@"`

    if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

    eval set -- "$TEMP"

    while true ; do
        case "$1" in
            -h|--help)
                usage_status; exit 0;  shift;;
            \? )
                echo "Invalid Option: -$OPTARG" 1>&2;;
            --) shift ; break ;;
            *) echo "Internal error!" ; exit 1 ;;
        esac
    done

    shift $((OPTIND-1))
}

#Starts script with input argument analysis
LOGFILE="script.log"          #default logfile name   => modified by -l|--log <log_file>
declare -a ARGS_MANDATORY=( "" )  #init non-option argument
SUB_COMMAND="general"

parse_args_general "$@"

if [ -f ${LOGFILE} ]; then rm -f ${LOGFILE}; fi #remove default log file if exist

echo "Parsed input argument"
echo "    Sub-command:    ${SUB_COMMAND}"
echo "    Logfile:        ${LOGFILE}"
echo "    Mandatory args: ${ARGS_MANDATORY[@]}"

if [ "${SUB_COMMAND}" == "status" ]; then
    get_status
elif [ "${SUB_COMMAND}" == "execute" ]; then
    execute_script
fi

```

Naturally, in this case the number of solution to test is more important. That's why I strongly recommand you to create a test script very soon, enhance and execute it each time you change something in the script.

see `script_parse_args.sh` and `script_parse_args_test.sh` (test file with more than 20 tests)


### Test and debug with functions

We will modify script_basic.sh in script_evo_1.sh with:
- argument parsing => create parse_args and usage function
- some functions that do operation => gen_err_1, gen_err_2, gen_err_3, gen_err_4
- a function that print formatted duration from an input value in ns


