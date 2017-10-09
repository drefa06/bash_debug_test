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
