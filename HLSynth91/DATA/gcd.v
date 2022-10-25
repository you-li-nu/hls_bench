
/*--------- Greatest common divisor --------------*/
MODULE GCD (XI:IN,YI:IN,RST:IN,OU:OUT);

EXTERNAL GCD;
 DCL XI  BIT(16),
     YI  BIT(16),
     RST BIT(1),
     OU  BIT(16);

INTERNAL GCD;
 DCL X   BIT(16),
     Y   BIT(16);

BODY GCD;

 DO INFINITE LOOP
  DO WHILE RST LOOP /* Wait */ ENDDO;
  X:=XI; Y:=YI;
  DO WHILE ^(X=Y)
   LOOP
    IF X<Y THEN Y:=Y-X; ELSE X:=X-Y; ENDIF;
   ENDDO;
  OU:=X;
 ENDDO;

END GCD;


