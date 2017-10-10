#!/bin/bash

echo "#########################################################################"
echo "### TEST 1"
echo "### ./script_parse_args_1.sh"
echo "### Expected: At least one argument is needed + usage"
bash ./script_parse_args_1.sh
echo "#########################################################################"
echo "### TEST 2" 
echo "### ./script_parse_args_1.sh -h"
echo "### Expected: usage printed"
bash ./script_parse_args_1.sh -h
echo "#########################################################################"
echo "### TEST 3"
echo "### ./script_parse_args_1.sh --help"
echo "### Expected: usage printed"
bash ./script_parse_args_1.sh --help
echo "#########################################################################"
echo "### TEST 4"
echo "### ./script_parse_args_1.sh -h -v"
echo "### Expected: usage printed"
bash ./script_parse_args_1.sh -h -v
echo "#########################################################################"
echo "### TEST 5"
echo "### ./script_parse_args_1.sh -h -x"
echo "### Expected: getopt : option invalide -- 'x'"
bash ./script_parse_args_1.sh -h -x
echo "#########################################################################"
echo "### TEST 6"
echo "### ./script_parse_args_1.sh -h foo"
echo "### Expected: usage printed"
bash ./script_parse_args_1.sh -h foo
echo "#########################################################################"
echo "### TEST 7"
echo "### ./script_parse_args_1.sh -v"
echo "### Expected: <version> number is printed"
bash ./script_parse_args_1.sh -v
echo "#########################################################################"
echo "### TEST 8"
echo "### ./script_parse_args_1.sh --version"
echo "### Expected: <version> number is printed"
bash ./script_parse_args_1.sh --version
echo "#########################################################################"
echo "### TEST 9"
echo "### ./script_parse_args_1.sh -v -h"
echo "### Expected: <version> number is printed"
bash ./script_parse_args_1.sh -v -h
echo "#########################################################################"
echo "### TEST 10"
echo "### ./script_parse_args_1.sh -v -x"
echo "### Expected: getopt : option invalide -- 'x'"
bash ./script_parse_args_1.sh -v -x
echo "#########################################################################"
echo "### TEST 11"
echo "### ./script_parse_args_1.sh -x"
echo "### Expected: getopt : option invalide -- 'x'"
bash ./script_parse_args_1.sh -x
echo "#########################################################################"
echo "### TEST 12"
echo "### ./script_parse_args_1.sh -l"
echo "### Expected: message missing argument for -l option"
bash ./script_parse_args_1.sh -l
echo "#########################################################################"
echo "### TEST 13"
echo "### ./script_parse_args_1.sh --log"
echo "### Expected: message missing argument for -l option"
bash ./script_parse_args_1.sh --log
echo "#########################################################################"
echo "### TEST 14"
echo "### ./script_parse_args_1.sh -l test.log"
echo "### Expected: At least one argument is needed + usage printed"
bash ./script_parse_args_1.sh -l test.log
echo "#########################################################################"
echo "### TEST 15"
echo "### ./script_parse_args_1.sh --log test.log"
echo "### Expected: At least one argument is needed +  usage printed"
bash ./script_parse_args_1.sh --log test.log
echo "#########################################################################"
echo "### TEST 16"
echo "### ./script_parse_args_1.sh -l test.log foo bar"
echo "### Expected: Exection success"
bash ./script_parse_args_1.sh -l test.log foo bar
echo "#########################################################################"
echo "### TEST 17"
echo "### ./script_parse_args_1.sh foo bar"
echo "### Expected: Exection success"
bash ./script_parse_args_1.sh foo bar
echo "#########################################################################"

