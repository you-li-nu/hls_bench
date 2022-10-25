
/*------------ Programable 4-bit up and down counter ---------*/

MODULE COUNTER (COUNTIN:IN,UP:IN,COUNT:IN,
                COUNTOUT:OUT);

EXTERNAL COUNTER;
 DCL COUNTIN  BIT(4),/*programming input */
     UP       BIT(1),/*1=up,    0=down   */
     COUNT    BIT(1),/*1=count, 0=program*/
     COUNTOUT BIT(4);/*counter output    */
INTERNAL COUNTER;
 DCL I        BIT(4);/*counting variable */

BODY COUNTER;
 DO INFINITE LOOP
  COUNTOUT:=I;
  IF COUNT
   THEN IF UP THEN I:=I+1;
              ELSE I:=I-1;
        ENDIF;
   ELSE I:=COUNTIN;
  ENDIF;
 ENDDO;

END COUNTER;


