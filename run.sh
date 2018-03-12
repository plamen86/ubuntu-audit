#!/bin/bash
rm err.txt
rm out.txt
sudo bash ubuntu-audit.sh >out.txt 2>err.txt
pluma err.txt out.txt
