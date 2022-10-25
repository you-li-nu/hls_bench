#!/bin/csh -xvf
xsc function.c 
xvlog -svlog file.sv
xelab work.m -sv_lib dpi -R
