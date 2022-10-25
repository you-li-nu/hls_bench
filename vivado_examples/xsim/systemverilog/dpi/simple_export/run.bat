call set install_root=<Vivado Installation Root>

call %install_root%\bin\xvlog -sv file.sv

call %install_root%\bin\xelab TOP -dpiheader dpi.h

call %install_root%\bin\xsc function.c 

call %install_root%\bin\xelab TOP -sv_lib dpi -R

