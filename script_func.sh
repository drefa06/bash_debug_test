func_name()
{
    echo "init local param1"
    local param1=2    #init local param1
    echo "init global PARAM2"
    PARAM2=3          #modif global PARAM2 with local value

    echo "init global PARAM3"
    PARAM3=$(($1+$param1))	#modif global PARAM3 with input param $1 + local param1

    echo "param1=$param1"          #print out local param1
    return $(($param1*2)) #return content of param1*2
}

echo "Before func_name"
param1=1
PARAM2=2
echo "PARAM1 = $param1"
echo "PARAM2 = $PARAM2"

echo "### Test 1 ### Exec func_name as sub-shell"
PARAM4=`func_name 3` #called as sub-shell, do not change global var
echo "$PARAM4"
PARAM4=`echo "$PARAM4" | grep "param1=" | cut -d= -f2` #called as sub-shell, do not change global var
PARAM5=$?
echo "PARAM1 = $param1 => OK"
echo "PARAM2 = $PARAM2 => NOK, should have been modified in func_name"
echo "PARAM3 = $PARAM3 => NOK, should have been init in func_name"
echo "PARAM4 = $PARAM4 => OK, init directly from func_name"
echo "PARAM5 = $PARAM5 => OK"

echo "### Test 2 ### Call func_name"
func_name 3 > func_name.tmp 2>&1
PARAM5=$?
PARAM4=`cat func_name.tmp | grep "param1=" | cut -d= -f2`
more func_name.tmp
echo "PARAM1 = $param1 => OK"
echo "PARAM2 = $PARAM2 => OK"
echo "PARAM3 = $PARAM3 => OK"
echo "PARAM4 = $PARAM4 => OK but need post treatment of func_name.tmp to get result"
echo "PARAM5 = $PARAM5 => OK"
rm -f func_name.tmp
