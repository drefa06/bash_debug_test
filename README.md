# Bash script with error management, debug and test.

## Purpose

When you create a bash script, depending of the length and complexity of the script, 
the debug/test/error management may be considered differently.

The following examples shows differents cases from a basic script to a more complex one.

## Basic script


Most of case you need to create a bash script that execute some operations. In this example, I only do some basic tests that contains script issues.

For this basic case, the sript is short so the best solution is to print out the lines during execution with xTrace.
2 solutions:
 - Add set -x / set +x in the script, around the part to debug. it print only the lines uncapsulated by set -x/+x.
 - launch the script with bash -x <script_name>. It print all the lines executed of the script.

script_basic.sh
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
Execution : ```$ bash script_basic.sh```
will print only detailed lines of part encapsulated by set -x / set +x

```
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

Now remove the set -x / set +x and launch script with -x option
Execution : ```$ bash -x script_basic.sh```
Will print ALL lines execution details.


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
care that:
 - a local variable must be initialised with "local" keyword.
 - a local variable to function stays local even if you use the same name outside the function
 - a global variable is not modified by a function if called as a sub-shell => see Test1 part in the following
 - a global variable is modified by a function if simply called => see Test2 part in the following
 - return value is a facultative command, get it with foo=$?, default is 0 for OK and 1 for NOK

script_func.sh
```
my_func()
{
    echo "START my_func"
    echo "my_func:input $1"
    echo "init local param1"
    local param1=2         #init local param1
    echo "param1=$param1"  #print out local param1

    echo "init global PARAM2"
    PARAM2=3               #modif global PARAM2 with local value
    echo "PARAM2=$PARAM2"  #print out local PARAM2

    echo "init global PARAM3=1st input + param1"
    PARAM3=$(($1+$param1)) #modif global PARAM3 with input param $1 + local param1
    echo "PARAM3=$PARAM3"

    echo "END my_func"
    echo "my_func:return $(($param1*2))"
    return $(($param1*2))  #return content of param1*2
}

echo "Before my_func execution"
param1=1
PARAM2=2
echo "param1 = $param1"
echo "PARAM2 = $PARAM2"

echo ""
echo "### Test 1 ### Exec 'my_func 3' as sub-shell"
echo "PARAM4 is set with all echo line"
PARAM4=`my_func 3` #called as sub-shell, do not change global var
PARAM5=$?
PARAM6=`echo "$PARAM4" | grep "param1=" | cut -d= -f2`
echo ""
echo "After my_func execution"
#called as sub-shell, do not change global var
echo "param1 = $param1 => shall be same as before"
echo "PARAM2 = $PARAM2 => shall be same as before"
echo "PARAM3 = $PARAM3 => shall not be set"
echo "PARAM4 = '$PARAM4' => shall be all echo from my_func"
echo "PARAM5 = $PARAM5 => shall be returned code, default 0 for OK, 1 for NOK or specific return value, it's the case here"
echo "PARAM6 = $PARAM6 => set with post treatment on PARAM4"

echo ""
echo "### Test 2 ### Call my_func as script and put result in a result file"
PARAM4=""
my_func 3 > my_func.tmp 2>&1
PARAM5=$?
PARAM6=`cat my_func.tmp | grep "param1=" | cut -d= -f2`

echo "'my_func 3' result file"
more my_func.tmp
echo "After my_func execution"
echo "param1 = $param1 => shall be same as before"
echo "PARAM2 = $PARAM2 => shall be modified by my_func"
echo "PARAM3 = $PARAM3 => shall be set by my_func"
echo "PARAM4 = $PARAM4 => shall not be set"
echo "PARAM5 = $PARAM5 => shall be returned code"
echo "PARAM6 = $PARAM6 => set with post treatment on my_func.tmp"
rm -f my_func.tmp

echo ""
echo "CONCLUSION: BE CAREFULL on local/Global param modif or not in function and how to call/execute the function"
```

Execution:

```
$ bash script_func.sh
Before my_func execution
param1 = 1
PARAM2 = 2

### Test 1 ### Exec 'my_func 3' as sub-shell
PARAM4 is set with all echo line

After my_func execution
param1 = 1 => shall be same as before
PARAM2 = 2 => shall be same as before
PARAM3 =  => shall not be set
PARAM4 = 'START my_func
my_func:input 3
init local param1
param1=2
init global PARAM2
PARAM2=3
init global PARAM3=1st input + param1
PARAM3=5
END my_func
my_func:return 4' => shall be all echo from my_func
PARAM5 = 4 => shall be returned code, default 0 for OK, 1 for NOK or specific return value, it's the case here
PARAM6 = 2 => set with post treatment on PARAM4

### Test 2 ### Call my_func as script and put result in a result file
'my_func 3' result file
START my_func
my_func:input 3
init local param1
param1=2
init global PARAM2
PARAM2=3
init global PARAM3=1st input + param1
PARAM3=5
END my_func
my_func:return 4
After my_func execution
param1 = 1 => shall be same as before
PARAM2 = 3 => shall be modified by my_func
PARAM3 = 5 => shall be set by my_func
PARAM4 =  => shall not be set
PARAM5 = 4 => shall be returned code
PARAM6 = 2 => set with post treatment on my_func.tmp

CONCLUSION: BE CAREFULL on local/Global param modif or not in function and how to call/execute the function
```

## Argument parsing

Argument parsing is very usefull for more explicit and structured script.

I usually create 2 specific functions for argument parsing: parse_args and usage.
For my script, I always put 2 basic options: help and version, and a logfile output option (with default value)

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
- some functions that do operation with an error => gen_err_1, gen_err_2, gen_err_3, gen_err_4
- a function that print formatted duration from an input value in ns

The script will do:
- enter 1 or more operation to execute
- put this operation in a tmp file
- execute each operation found in tmp file
- at the end remove tmp file.

The goal is:
- to check the content of logfile even if we change its name
- to check if the error put in operation are detected
- to see what happen if we do a ctrl+c some time
- how to create a reliable test file for each functions

#### logfile

Add a new option (-l|--logfile <filename>) to parse_args and update usage
launch ./script_evo_1.sh gen_err_1
=> will log in default file ./script_evo_1.log
launch ./script_evo_1.sh -l script_evo_1_logfile.log gen_err_1
=> will log in file ./script_evo_1_logfile.log

Compare both file to check that content is the same

It is common to use your own logfile instead of stdout or default logfile
One classic usage is a script scrip_1.sh that call scrip_2.sh and you need to have all log in same file instead of 2 separated files
in this case, let scrip_1.sh default log but call scrip_2.sh with option -l <script1 default logfile>


#### Error in function, how to detect it

let's try: ./script_evo_1.sh gen_err_1
Do not ctr+c this time
```
Analyse input argument
    Logfile:        script_evo_1.log
    Mandatory args: gen_err_1 
LOGFILE=script_evo_1.log
MANDATORY=gen_err_1 
duration = 00:00:00.016336
SLEEP 5 => if you want to test Ctrl+C ... please do it at least one

EXECUTE: gen_err_1
test gen_err_1: if [ bar baz == bar ] #too much arguments
bar baz!=bar
gen_err_1: No Error, continue script
=>gen_err_1: return code 0
=>gen_err_1: But error file content not empty !!!
=>gen_err_1: Content is: 
./script_evo_1.sh: ligne 69 : [: trop d'arguments
=>gen_err_1: Should have been detected as script syntax error and exit !!!
sleep 5 => if you want to test Ctrl+C ... just for fun, but let the script finish at least once

duration = 00:00:00.022712
End Execution, SLEEP 5sec more before ending
Content of script_evo_1.tmp:
INPUT_ARG=gen_err_1
LOGFILE=script_evo_1.log
MANDATORY=gen_err_1 
duration = 00:00:00.022712
Remove script_evo_1.tmp
BYE
```
As you can see, the script goes through the end unless an error happen !!!

Try it with gen_err_2:
```
EXECUTE: gen_err_2
test gen_err_2: if [ bar baz == bar] #missing space before ]
bar baz!=bar
gen_err_2: No Error, continue script
=>gen_err_2: return code 0
=>gen_err_2: But error file content not empty !!!
=>gen_err_2: Content is: 
./script_evo_1.sh: ligne 86 : [: « ] » manquant
=>gen_err_2: Should have been detected as script syntax error and exit !!!
```
Same problem

idem for gen_err_3 and gen_err_4
All of them should have generated a script issue and exit !

Conclusion: If you have a long script that do something like that, the best case is that your script generate an other error elsewhere, the worst case is that you don't see anything wrong...

Solution 1:
- Add a ```set -e``` at the beggining of your script
- Have a look at the return code by launching: ```./script_evo_1.sh gen_err_1; echo $?```

Re-test your script:
- ```./script_evo_1.sh gen_err_1; echo $?``` => same pb, return code=0
- ```./script_evo_1.sh gen_err_2; echo $?``` => same pb, return code=0
- ```./script_evo_1.sh gen_err_3; echo $?``` => exit with return code=2, OK
- ```./script_evo_1.sh gen_err_4; echo $?``` => exit with return code=1, OK

We still have wrong detection for gen_err_1 and gen_err_2 !
You can have 2 ideas to solve this:
- Any error shall stop the script (usefull for long time script) and return error code 1
  In this case add a new function:
```
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
```
  And call it like:
```
call <func_to_exec> "<func_arg_1> ... <func_arg_n>" 
```
- The script can continue but we must list them and exit with a non zero code (ex: 2)
  In this case, call the func like:
```
eval <func_to_exec> "<func_arg_1> ... <func_arg_n>" 2>> $ERRFILE
```
   And add following treatment at the end of script:
```
if [ `cat $ERRFILE | wc -l` -ne 0 ]; then
    echo "### Non Critical error found during execution ###"
    cat $ERRFILE
    rm -f $ERRFILE
    exit 2
else
    echo "WELL DONE, BYE" | tee -a ${LOGFILE}
fi
```

#### ctrl+c during execution

if you launch ./script_evo_1.sh it suggest you to do ctrl+c 2 times.let's try it..

launch ```./script_evo_1.sh gen_err_2; echo $?``` and do the ctrl+c when asked the 1st time,
do nothing and re-launch immediately the script and do the ctrl+c when asked the 2nd time.

and finally re launch a third time the script and let it go through the end.
The 3rd execution will print:
```
./script_evo_1.sh gen_err_2; echo "return code: $?"
Analyse input argument
    Logfile:        script_evo_1.log
    Mandatory args: gen_err_2 
LOGFILE=script_evo_1.log
MANDATORY=gen_err_2 
duration = 00:00:11.011905
SLEEP 5 => if you want to test Ctrl+C ... please do it at least one

EXECUTE: gen_err_2
test gen_err_2: if [ bar baz == bar] #missing space before ]
bar baz!=bar
gen_err_2: No Error, continue script
sleep 5 => if you want to test Ctrl+C ... just for fun, but let the script finish at least once

EXECUTE: gen_err_2
test gen_err_2: if [ bar baz == bar] #missing space before ]
bar baz!=bar
gen_err_2: No Error, continue script
sleep 5 => if you want to test Ctrl+C ... just for fun, but let the script finish at least once

EXECUTE: gen_err_2
test gen_err_2: if [ bar baz == bar] #missing space before ]
bar baz!=bar
gen_err_2: No Error, continue script
sleep 5 => if you want to test Ctrl+C ... just for fun, but let the script finish at least once

duration = 04:10:27.027320
End Execution, SLEEP 5sec more before ending
Content of script_evo_1.tmp:
INPUT_ARG=gen_err_2
LOGFILE=script_evo_1.log
MANDATORY=gen_err_2 
INPUT_ARG=gen_err_2
LOGFILE=script_evo_1.log
MANDATORY=gen_err_2 
INPUT_ARG=gen_err_2
LOGFILE=script_evo_1.log
MANDATORY=gen_err_2 
duration = 04:10:27.027320
Remove script_evo_1.tmp
Non Critical error found during execution:
./script_evo_1.sh: ligne 87 : [: « ] » manquant
./script_evo_1.sh: ligne 87 : [: « ] » manquant
./script_evo_1.sh: ligne 87 : [: « ] » manquant
return code: 2
```

You see it.... it execute 3 time gen_err_2 !!
You know it's because we did not remove script_evo_1.tmp after each run.
But sometimes, you can forgot a ressource to remove or reinit before each run, so how to prevent this ?

trapping EXIT ... because whatever happen, the script exit and so we can trap it to execute "PostProcess" commands.
trapping SIGINT SIGTERM SIGKILL to trap any external kill -9, kill -15 or internal ctrl+c

so I suggest to create following functions
```
function AbortProcess()
{
    rc=$1
    echo "### ABORT ### Process aborted"
    echo "### ABORT ### $2 $3"
    echo "### ABORT ### exit $rc"
    exit $rc
}

function PostProcess()
{
    echo "### EXIT ### Cleaning Process before exit"
    #Add here what you need to be sure after exiting the script
    rm -f *.tmp *.err
    echo "### EXIT ### DONE BYE"
}
```
and add the line at the beginning of the script:
trap 'AbortProcess $? ${BASH_SOURCE}:${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' SIGINT SIGTERM SIGKILL #trap any ctrl+c
trap 'PostProcess $?' EXIT #trap exit

#### test file

You can create a test file like explained before, but it is now interresting to test functions and action that trap script before full script.

To do that, the first command executed by test script shall be
```
source script_evo_1.sh
```
then you can now call any function from script_evo_1.sh

Example in script_evo_1_test.sh:
```
source script_evo_1.sh

echo "###  => return code: $?"
gen_err_1 
echo "###  => return code: $?"
```

This introduce a new problem. The main part of the script is composed of:
- parse input argument and init some variable called main.
- the script itself that do the job with those variables.
How to test them?
The answer is to split them in 2 functions
- script_evo_1() that do the job. The advantage is that this function can be called from another script as function (after source) instead of calling the full script.
- main() that contains the argument parsing part, init var and call function script_evo_1

something like









