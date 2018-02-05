#!/bin/sh

for file_name in `cat list.txt`; do
  cp $file_name cis/
done
