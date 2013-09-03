#!/bin/bash

ROOT_DIR=$(dirname `pwd`)

BIN_DIR=$ROOT_DIR/bin

_file=$1
echo $_file
php $BIN_DIR/markdown/parse.php $_file 
echo 

