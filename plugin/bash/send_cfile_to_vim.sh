#!/bin/bash
set -e
SUMMARY=`tail -n 1 $3`
VIM_MESSAGE="echoh WarningMsg|echom \"TMX Finished. $SUMMARY\"|echoh None"
CFILE="cg $3"
$1 --servername $2 --remote-send ":$VIM_MESSAGE|$CFILE<CR>"
