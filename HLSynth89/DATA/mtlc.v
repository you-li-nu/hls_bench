
/*--------- Traffic light controller --------------*/
MODULE MTLC (HICAR:IN,SIDECAR:IN,HILI:OUT,SIDELI:OUT);

EXTERNAL MTLC;
 DCL HICAR    BIT(1),  /* Car on highway    */
     SIDECAR  BIT(1),  /* Car on sideroad   */
     HILI     BIT(2),  /* Light on highway  */
     SIDELI   BIT(2);  /* Light on sideroad */

INTERNAL MTLC;
 DCL GREEN    BIT(2),  /* Constant */
     YELLOW   BIT(2),  /* Constant */
     RED      BIT(2);  /* Constant */

BODY MTLC;

   MODULE TIMER(STOP:IN, CAR:IN);
    EXTERNAL TIMER;
      DCL STOP BIT(8), CAR BIT(1);
    INTERNAL TIMER;
      DCL I    BIT(8);
    BODY TIMER;
      I:=0;
      DO UNTIL (I=STOP)|(^CAR) LOOP I:=I+1; ENDDO;
   END TIMER;

 GREEN:=1; YELLOW:=2; RED:=0;

 DO INFINITE LOOP
  SIDELI:=RED;HILI:=GREEN;
  DO UNTIL SIDECAR LOOP /*wait*/; ENDDO;
  TIMER (0,HICAR);
  HILI:=YELLOW;

  HILI:=RED; SIDELI:=GREEN;
  DO UNTIL HICAR   LOOP /*wait*/; ENDDO;
  TIMER(128,SIDECAR);
  SIDELI:=YELLOW;
 ENDDO;

END MTLC;


