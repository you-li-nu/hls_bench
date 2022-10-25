call set install_root=<Vivado Installation Root>

call set PATH=%install_root%/lib/win64.o;%install_root%/tps/mingw/6.2.0/win64.o/nt/x86_64-w64-mingw32/lib

call %install_root%\bin\xelab work.counter_verilog -prj counter.prj -dll -s counter

call "%install_root%\tps\mingw\6.2.0\win64.o\nt\bin\g++.exe" -I%install_root%\data\xsim\include\ -O3 -c -o xsi_loader.o xsi_loader.cpp

call "%install_root%\tps\mingw\6.2.0\win64.o\nt\bin\g++.exe" -I%install_root%\data\xsim\include\ -O3 -c -o testbench.o testbench.cpp

call "%install_root%\tps\mingw\6.2.0\win64.o\nt\bin\g++.exe" -o run_xsim testbench.o xsi_loader.o

call run_xsim

