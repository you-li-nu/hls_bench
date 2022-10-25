open run.out
logtime -e run.out

 monitor -n Smon  active  *E/*/*'sig
 monitor -n Smon  active  *E/*'sig
 monitor -n Vmon  write  *E/*/*/*'var
 monitor -n Vmon  read  *E/*/*/*'var

list > run.out
run 700  > run.out
quit
