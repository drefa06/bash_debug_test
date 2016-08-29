#!/bin/bash
set -e

echo "### Test1 ###"
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

echo "### Test2 ###"
    value1="bar baz"
    value2="bar"
    echo "test gen_err_2: if [ $value1 == $value2] #missing space before ]"
    if [ $value1 == $value2]; then
        echo "$value1==$value2"
    else
        echo "$value1!=$value2"
    fi
    echo "gen_err_2: No Error, continue script"

