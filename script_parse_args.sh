usage_general()
{
    echo "usage: script.sh [-h|--help] [--version] <sub_command> [sub_command OPTION] [<arg1> [<arg2> ... [<argN>]]]"
    echo ""
    echo "[OPTION]"
    echo "    -h | --help:  Print this usage"
    echo "    --version:    Print version"
    echo ""
    echo "script.sh help <sub_command> to print help for each <sub_command>"
    echo ""
    echo "<sub_command>"
    echo "    help:      Print this usage"
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
                usage_general; shift; exit 0;;
        --version)
                echo "version: $VERSION"; shift; exit 0;;
        help)
                if [ $# -eq 1 ]; then usage_general
                elif [ "$2" == "execute" ]; then usage_execute
                elif [ "$2" == "status" ]; then usage_status
                else echo "Invalid Sub Command: $2"
                fi
                exit 0;;

        execute)
                shift; parse_args_execute "$@";;
        status)
                shift; parse_args_status "$@";;

        \? )
                echo "Invalid Option: -$OPTARG" 1>&2;;
        --) shift ; break ;;
        *) echo "Sub Command is mandatory" ; exit 1 ;;
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
        usage_execute;
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
VERSION="0.1"
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
    echo "STATUS COMMAND"
elif [ "${SUB_COMMAND}" == "execute" ]; then
    echo "EXECUTE COMMAND"
fi
