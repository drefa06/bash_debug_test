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
```bash
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
You can see the 2 errors:

./script_basic_basic.sh: ligne 8 : [: trop d'arguments

./script_basic_basic.sh: ligne 20 : [: « ] » manquant


You can also remove (or not) the set -x / set +x and launch script with -x option
 ```$ bash -x script_basic.sh```
But it will print ALL executed lines details.


## Functions and input argument

When your script size increase to more than around 100 lines or is enhanced with some functions and/or input argument management, 
it can be interresting to have a test scripts to be executed regularly and enhanced to follow modif under script.

For debug I suggest to continue using set -x / set +x as previously around part to test and to redirect output to file for analysis.

### About functions
Creating functions permit to recall same parts or simply split the script in blocks but be carrefull on:
- How you call the function
- local/global parameter

In the following we will treat this cases and also introduce the input argument parsing.

#### local and global variable in function

Let's create a function that accept 1 input parameter, use local and global parameter (and modify them), print a value and return an other value.
care that:
 - a local variable must be initialised with "local" keyword.
 - a local variable to function stays local even if you use the same name outside the function
 - a global variable is not modified by a function if called as a sub-shell => see Test1 part in the following
 - a global variable is modified by a function if simply called => see Test2 part in the following
 - return value is a facultative command, get it with foo=$?, default is 0 for OK and 1 for NOK

see script_func.sh

Following are the main part of the script
```bash
my_func() #function declaration
{

    echo "my_func:input $1" # echo input param 1

    local param1=2         #init local var param1

    PARAM2=3               #init or modif global var PARAM2 with value

    PARAM3=$(($1+$param1)) #init or modif global PARAM3 with input param $1 + local param1

    return $(($param1*2))  #return code is content of param1*2
}

param1=1
PARAM2=2

echo "### Case 1 ### Exec 'my_func 3' as sub-shell"
PARAM4=`my_func 3`   #called as sub-shell, do not change global var
PARAM5=$?            #get return code

echo "### Case 2 ### Call my_func as script and put result in a result file"
my_func 3 > my_func.tmp 2>&1
PARAM5=$?
```

Execution:

```
$ bash script_func.sh
Before my_func execution
param1 = 1
PARAM2 = 2

### Case 1 ### Exec 'my_func 3' as sub-shell
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

### Case 2 ### Call my_func as script and put result in a result file
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

#### Test script with function

modify script_func.sh

If you launch the script with bash -x script_func.sh, it will print all details sequentially.
You will not be able to identify where start or end the function.

Now if you put set -x / set +x in script, where you put them can have an influence:

- If you put a set -x in the function and no set +x.
For Case 1, it will print lines details following set -x and stops at end of function, because it is a sub-shell
For Case 2, it will print lines details following set -x and continue after end of function untill end of program

- If you put a set -x before Case 1 function call and a set +x in function.
It print lines details following set -x, call function as subshell with option -x set, so print lines detail of case1 until it see set +x, stop details and finish function. But outside, option -x is still set, so it continue to print details in main and reenter function in case 2. Function in case2 is called as part of the script itself, so when set +x is seen, it stops print details for all following including outside the function.

As conclusion, when you use function, I suggest you to put set -x / set +x at same level (in the function or out the function, not mixing the set) and if needed, adding an echo wheb starting and ending function.

#### General Argument parsing

Argument parsing is very usefull for more explicit and structured script.

I usually create 2 specific functions for argument parsing: parse_args and usage.
For my script, I always put 2 basic options: help and version, and also a logfile output option (with default value=<script name>.log)

see script_parse_args_1.sh

```bash
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

Ideally, we might test all cases:
- good option -h and --help
- good option -v and --version
- good option -h and -v mixed
- bad option -x, alone and mixed with previous one
- good option -l and --log without and with a filename
- mandatory args with and without -l option

You can do the tests by hand and play with set -x/set +x for debug but it might be quite interresting to create a test script.
The test script can be the list of all call and check by hand that everything is well executed.

see and launch ```script_parse_args_test_1.sh``` for example

#### Extended Argument parsing

For some specific case you can have 2 or more sub-command that need their own options.
For example, git status and git commit are 2 sub-command of git function that need specific help and execution.

In this case you can create a general parse_args and usage, and a parse_args/usage per sub-command.
You need also to create a function per sub-command.

Naturally, in this case the number of solution to test is more important. That's why I strongly recommand you to create a test script very soon, enhance and execute it each time you change something in the script.

see ```script_parse_args_2.sh``` and ```script_parse_args_test_2.sh``` (test file with more than 20 tests)


### Test and debug with functions

We will modify script_basic.sh in script_evo_1.sh with:
- argument parsing => create parse_args and usage function
- some functions that do operation with an error => gen_err_1, gen_err_2, gen_err_3, gen_err_4
- a function that print formatted duration from an input value in ns

We define that script will do:
- enter 1 or more operation gen_err_<val> to execute
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
One classic usage of this option is that your script call another script but you need to have all log in same file instead of 2 separated files (1 for each script).

#### How Error can be ignored.

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
# => gen_err_1: return code 0
# => gen_err_1: But error file content not empty !!!
# => gen_err_1: Content is: 
./script_evo_1.sh: ligne 69 : [: trop d'arguments
# => gen_err_1: Should have been detected as script syntax error and exit !!!
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
# => gen_err_2: return code 0
# => gen_err_2: But error file content not empty !!!
# => gen_err_2: Content is: 
./script_evo_1.sh: ligne 86 : [: « ] » manquant
# => gen_err_2: Should have been detected as script syntax error and exit !!!
```
Same problem

idem for gen_err_3 and gen_err_4
All of them should have generated a script issue and exit !

Conclusion: If you have a long script that do something like that, the best case is that your script generate an other error elsewhere but the source error is hard to find, the worst case is that you don't see anything wrong, but your result might not what you expect.

#### How to detect Script Error and Exit

First, have a look at return code when launching: ```bash -e ./script_evo_1.sh gen_err_<val>; echo $?```

Re-test your script:
- with gen_err_1 => same pb, return code=0
- with gen_err_2 => same pb, return code=0
- with gen_err_3 => exit with return code=2, OK
- with gen_err_4 => exit with return code=1, OK

So you need to add set -e at beginning of your script, it will enable the error detection

But We still have wrong detection for gen_err_1 and gen_err_2 !
You can have 2 ideas to solve this:
- Any error shall stop the script (usefull for long time script) and return error code 1
  For this case add a new function:
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

Modif are done in script_evo_2.sh.
Remove *.log and *.tmp before each try.
Try the 4 cases and note the last lines, return code and if script_evo_2.tmp exist

- with gen_err_1
  gen_err_1: No Error, continue script
  ### ERROR ### ./script_evo_2.sh: ligne 70 : [: trop d'arguments
  return code=1 => OK
  script_evo_2.tmp still exist.
- with gen_err_2
  Non Critical error found during execution:
  ./script_evo_2.sh: ligne 87 : [: « ] » manquant
  return code=2 => OK
  script_evo_2.tmp is removed.
- with gen_err_3
  Generate an error
  return code=2 => OK
  script_evo_2.tmp still exist.
- with gen_err_4
  No info given
  return code=1 => OK
  script_evo_2.tmp still exist.

All script error are detected.
But script_evo_2.tmp is not removed. This can be a real problem.


#### Trapping system

At script creation, we decide to put the functions to execute in a file script_evo_2.tmp and execute it.
Some error well detected will exit the script before removing script_evo_2.tmp.

try the following:
```./script_evo_2.sh gen_err_1```
follwed without removing script_evo_2.tmp by:
```./script_evo_2.sh gen_err_3```

What happen?
- First launch, it execute gen_err_1, detect it, exit and script_evo_2.tmp still exist
- Second launch, it execute gen_err_1 again.... and not gen_err_3.

There is 3 solutions to this problem:
- remove manually script_evo_2.tmp before each run.
  And if you forget it only once, just the day you need a good treatment, and script run for 30 minutes... with the wrong param !
- remove it automatically at beginning of each run.
  Works fine and is enough for many cases
- remove it automatically at the end either an error happen.
  This solution is done by a trapping of exit status. I like it.

To prevent this, add the function to your script:
```bash
function PostProcess()
{
    echo "### EXIT ### Cleaning Process before exit"
    #Add here all what you need to be done after exiting the script, removing file, cleaning dB, env var, etc...
    rm -f *.tmp *.err
    echo "### EXIT ### DONE BYE"
}
```

and at the beginning of script
```bash
trap 'PostProcess $?' EXIT #trap exit
```

The script will exit... with or without an error, i will exit, then it will call PostProcess function.

see script_evo_3.sh

- Try ```./script_evo_3.sh gen_err_1```
  Note the last line:
  ### EXIT ### Cleaning Process before exit
  ### EXIT ### DONE BYE
  no more script_evo_3.tmp and script_evo_3.err are ell deleted
- Try ```./script_evo_3.sh gen_err_2```
  gen_err_2 is well executed !

This trapping system can also be used to detect any other signal where you like to do a specific treatment. For ex, detect CTRL+C.
Before this, CTRL+C = SIGKILL call the classic Exit process. At this steps, it call PostProcess function before exit.
Now, you want to create a specific treatment that return an error code depending on event.
You add the trapping line at beginning of script:
```bash
trap 'AbortProcess $? ${BASH_SOURCE}:${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' SIGINT SIGTERM SIGKILL
```
SIGKILL = CTRL+C = kill -9
SIGTERM = kill -15
SIGINT = internal interuption

And add the new function AbortProcess:
```bash
function AbortProcess()
{
    rc=$1
    echo "### ABORT ### Process aborted"
    echo "### ABORT ### $2 $3"
    echo "### ABORT ### exit $rc"
    exit $rc
}
```
At CTRL+C, it will call AbortProcess, then at end, it do an Exit... that call  PostProcess...

see script_evo_4.sh

Try: ```./script_evo_4.sh gen_err_1; echo $?```
Type CTRL+C when asked, what happen?
```
SLEEP 5 => if you want to test Ctrl+C ... please do it at least one
^C### ABORT ### Process aborted
### ABORT ### During: ./script_evo_4.sh:1 main
### ABORT ### exit 130
### EXIT ### Cleaning Process before exit
### EXIT ### DONE BYE
130
```

You can see the ABORT and EXIT treatment well executed.


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









