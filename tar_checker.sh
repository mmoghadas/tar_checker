#!/bin/bash

file1=$1
file2=$2

tmp=/tmp/tar_checker

rm -rf $tmp/{1,2};mkdir $tmp/{1,2}

tar zxf $file1 -C $tmp/1
tar zxf $file2 -C $tmp/2

diff -rq $tmp/1 $tmp/2