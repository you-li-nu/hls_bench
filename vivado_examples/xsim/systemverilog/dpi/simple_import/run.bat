call set install_root=<Vivado Installation Root>

call %install_root%\bin\xsc function.c 

call %install_root%\bin\xvlog -svlog file.sv

call %install_root%\bin\xelab work.m -sv_lib dpi -R

