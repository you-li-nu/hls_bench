#!/bin/csh -xvf
xvlog -sv file.sv
xelab TOP -dpiheader dpi.h
xsc function.c 
xelab TOP -sv_lib dpi -R
