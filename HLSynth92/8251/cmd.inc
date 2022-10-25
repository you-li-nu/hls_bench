monitor -n Smon  active  E/*'sig
monitor -n Vmon  read  E/*'var
monitor -n Vmon  write  E/*'var

open run.out
logtime -e run.out

list > run.out
run 70000 > run.out

quit






