#!/bin/bash

echo "#########################################################################"
echo "### TEST 1"
echo "### ./script_parse_args.sh"
echo "### Expected: Sub Command is Mandatory"
bash ./script_parse_args.sh
echo "#########################################################################"
echo "### TEST 2" 
echo "### ./script_parse_args.sh -h"
echo "### Expected: usage printed"
bash ./script_parse_args.sh -h
echo "#########################################################################"
echo "### TEST 3"
echo "### ./script_parse_args.sh --help"
echo "### Expected: usage printed"
bash ./script_parse_args.sh --help
echo "#########################################################################"
echo "### TEST 4"
echo "### ./script_parse_args.sh -h -v"
echo "### Expected: usage printed"
bash ./script_parse_args.sh -h -v
echo "#########################################################################"
echo "### TEST 5"
echo "### ./script_parse_args.sh -h -x"
echo "### Expected: usage printed"
bash ./script_parse_args.sh -h -x
echo "#########################################################################"
echo "### TEST 6"
echo "### ./script_parse_args.sh -v"
echo "### Expected: Sub Command is mandatory"
bash ./script_parse_args.sh -v
echo "#########################################################################"
echo "### TEST 7"
echo "### ./script_parse_args.sh --version"
echo "### Expected: version: <ver> printed"
bash ./script_parse_args.sh --version
echo "#########################################################################"
echo "### TEST 8"
echo "### ./script_parse_args.sh -x"
echo "### Expected: Sub Command is mandatory"
bash ./script_parse_args.sh -x
echo "#########################################################################"
echo "### TEST 9"
echo "### ./script_parse_args.sh help"
echo "### Expected: usage printed"
bash ./script_parse_args.sh help
echo "#########################################################################"
echo "### TEST 10"
echo "### ./script_parse_args.sh help execute"
echo "### Expected: execute usage printed"
bash ./script_parse_args.sh help execute
echo "#########################################################################"
echo "### TEST 11"
echo "### ./script_parse_args.sh help status"
echo "### Expected: status usage printed"
bash ./script_parse_args.sh help status
echo "#########################################################################"
echo "### TEST 12"
echo "### ./script_parse_args.sh help foo"
echo "### Expected: Invalid Sub Command: foo"
bash ./script_parse_args.sh help foo
echo "#########################################################################"
echo "### TEST 13"
echo "### ./script_parse_args.sh execute -h"
echo "### Expected: execute usage printed"
bash ./script_parse_args.sh execute -h
echo "#########################################################################"
echo "### TEST 14"
echo "### ./script_parse_args.sh execute --help"
echo "### Expected: execute usage printed"
bash ./script_parse_args.sh execute --help
echo "#########################################################################"
echo "### TEST 15"
echo "### ./script_parse_args.sh execute -l"
echo "### Expected: message missing argument for -l option"
bash ./script_parse_args.sh execute -l
echo "#########################################################################"
echo "### TEST 16"
echo "### ./script_parse_args.sh execute --log"
echo "### Expected: message missing argument for -l option"
bash ./script_parse_args.sh execute --log
echo "#########################################################################"
echo "### TEST 17"
echo "### ./script_parse_args.sh execute -l test.log"
echo "### Expected: At least one argument is needed + execute usage printed"
bash ./script_parse_args.sh execute -l test.log
echo "#########################################################################"
echo "### TEST 18"
echo "### ./script_parse_args.sh execute --log test.log"
echo "### Expected: At least one argument is needed + execute usage printed"
bash ./script_parse_args.sh execute --log test.log
echo "#########################################################################"
echo "### TEST 19"
echo "### ./script_parse_args.sh execute -x"
echo "### Expected: Invalid option x"
bash ./script_parse_args.sh execute -x
echo "#########################################################################"
echo "### TEST 20"
echo "### ./script_parse_args.sh execute foo"
echo "### Expected: ends with EXECUTE COMMAND"
bash ./script_parse_args.sh execute foo
echo "#########################################################################"
echo "### TEST 21"
echo "### ./script_parse_args.sh execute -l test.log foo bar"
echo "### Expected: ends with EXECUTE COMMAND"
bash ./script_parse_args.sh execute -l test.log foo bar
echo "#########################################################################"
echo "### TEST 22"
echo "### ./script_parse_args.sh status -h"
echo "### Expected: status usage printed"
bash ./script_parse_args.sh status -h
echo "#########################################################################"
echo "### TEST 23"
echo "### ./script_parse_args.sh status --help"
echo "### Expected: status usage printed"
bash ./script_parse_args.sh status --help
echo "#########################################################################"
echo "### TEST 24"
echo "### ./script_parse_args.sh status -x"
echo "### Expected: Invalid option x"
bash ./script_parse_args.sh status -x
echo "#########################################################################"
echo "### TEST 25"
echo "### ./script_parse_args.sh status foo"
echo "### Expected: ends with STATUS COMMAND"
bash ./script_parse_args.sh status foo
echo "#########################################################################"
echo "### TEST 26"
echo "### ./script_parse_args.sh status"
echo "### Expected: ends with STATUS COMMAND"
bash ./script_parse_args.sh status
