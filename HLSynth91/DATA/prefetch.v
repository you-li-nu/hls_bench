
/*-------------Simple instruction prefetch unit -----------------*/

MODULE FETCH  (BRANCHPC:IN, BRANCH:IN, IBUS:IN, IRE:IN,
               PCT:OUT, IRT:OUT, IA:OUT);
EXTERNAL FETCH;
   DCL BRANCHPC BIT(32),  /* New PC */
       BRANCH BIT(1),   /* Use new PC 1=> NPC, 0 = NPC */
       IBUS   BIT(32),  /* Instruction Bus   */
       IRE    BIT(1);   /* Instruction ready */
   DCL PCT    BIT(32),  /* PC */
       IRT    BIT(32),  /* Instruction register */
       IA     BIT(32);  /* Instruction address, PIN */
INTERNAL FETCH;
   DCL pc     BIT(32),    /* PC for this unit,     t+1  */
       ir     BIT(32),    /* Instruction register, t    */
       oldpc  BIT(32);    /* PC for output,        t    */

BODY   FETCH;
 DO INFINITE LOOP
   PCT := oldpc; IA := pc; IRT := ir;
   WHEN (IRE || BRANCH)
     CASE 2;           /* 10 */
     CASE 0;           /* 00 */
       DO UNTIL IRE LOOP  ENDDO;
     CASE 1,3;         /* X1 */
       pc  := BRANCHPC;
       IA  := pc;
       DO UNTIL IRE LOOP  ENDDO;
   ENDCASE;
   ir   := IBUS;
   oldpc:= pc;
   pc   := pc+4;
 ENDDO;
END FETCH;


