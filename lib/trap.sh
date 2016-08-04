lib_name='trap'
lib_version=20121026

stderr_log="/dev/shm/stderr.log"

#
# TO BE SOURCED ONLY ONCE:
#
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

if test "${g_libs[$lib_name]+_}"; then
    return 0
else
    if test ${#g_libs[@]} == 0; then
        declare -A g_libs
    fi
    g_libs[$lib_name]=$lib_version
fi


#
# MAIN CODE:
#
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

exec 2>"$stderr_log"


###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
#
# FUNCTION: EXIT_HANDLER
#
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

function exit_handler ()
{
set +x
    local error_code="$1"
    local error_message='unknown'
    #
    # Put all line found in stderr_log (if exist) in array
    # - if error_code is not 0, last entry is a Fatal Error (exit_code=1), all other are non fatal error (exit_code=2)
    # ------------------------------------------------------------------
    #
    local stderr_array
    local nb_stderr_array=0
    declare -a stderr_array=()
    if test -f "$stderr_log"; then
        stderr=$( tail -n 1 "$stderr_log" )
        SAVE_IFS=$IFS
        IFS=$'\n'
        stderr_array=($(cat "$stderr_log"))
        nb_stderr_array=${#stderr_array[@]}
        IFS=$SAVE_IFS
        #rm "$stderr_log"
    else
        return $error_code
    fi

    local exit_code=0
    for ((i=0;i<${nb_stderr_array};i++)); do
        if [ $error_code -eq 0 ]; then 
            echo_warning "NON FATAL ERROR FOUND in ${stderr_array[$i]}"
            exit_code=2
        elif [ $error_code -ne 0 -a $i -lt $((nb_stderr_array-1)) ]; then
            echo_warning "NON FATAL ERROR FOUND in ${stderr_array[$i]}"
            exit_code=2
        else
            echo_error "FATAL ERROR FOUND in ${stderr_array[$i]}"
            exit_code=1
        fi

    done

    echo_log "EXIT CODE: $exit_code"

    PostProcess

    exit "$exit_code"
}
trap 'exit_handler $?' EXIT                                                  # ! ! ! TRAP EXIT ! ! !

err_report() {
    local error_code="$1"
    echo_error "$2: line $3 : function= $4: Unknown Error" >> $stderr_log
}
trap 'err_report $? ${BASH_SOURCE} ${LINENO} ${FUNCNAME[0]:+${FUNCNAME[0]}}' ERR

source lib/utils.sh


return 0
