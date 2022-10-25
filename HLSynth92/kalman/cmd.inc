open run.out
logtime -e run.out

monitor -n Smon  active  *E/*'sig
monitor -n Vmon  write  *E/*'var
monitor -n Vmon  write  *E/*/O*'var
monitor -n Vmon  write  *'var
monitor -n Vmon  read  *E/*'var
monitor -n Vmon  read  *E/*/O*'var
monitor -n Vmon  read  *'var

list > run.out
run 1500  > run.out



quit
