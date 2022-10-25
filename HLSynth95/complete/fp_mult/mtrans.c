/*--------------------------------------------------------------------------

 Floating Point Multiplier Benchmark: Translator coded in ANSI C

 This translator read a "bits" format, detailed in the file "tvector.bits", and
     creates a VHDL test vector file

 Originally developed on June 9, 1993 by :
                                Bob McIlhenny
                                Univ. of Calif. , Irvine, CA 92717

 Modified on March 01, 1994 by: 
				Jesse Pan
				University of California, Irvine, CA 92717

--------------------------------------------------------------------------*/

/* Generation of test vectors */
#include <stdio.h>
#include <string.h>

#define INITIAL_COMMENT_LINES 26
#define NO_OF_PORTS 10
#define MAX_LINE_LENGTH 110

#define NAME_LINE1 INITIAL_COMMENT_LINES 
#define NAME_LINE2 INITIAL_COMMENT_LINES + 1
#define DIR_LINE INITIAL_COMMENT_LINES + 2
#define TYPE_LINE INITIAL_COMMENT_LINES + 3

main(argc,argv)

  int argc;
  char *argv[];

{

  FILE *infptr;
  FILE *outfptr;

  char *c;
  char *a;
  char *temp;

  char var[32];
  char line[MAX_LINE_LENGTH];

  int line_cnt;
  int field_cnt;
  int vec_cnt;
  int assert_cnt;
  int printed_vec_no;
  int instr_cnt;

  struct signal {
    char name[17];
    char port_type[4];
    char data_type[3];
  } ports[NO_OF_PORTS];

    /* Check arguments */

  if (argc != 3)
    {
      fprintf(stderr,"Usage: %s <vectorfile> <vhdlfile>\n", argv[0]);
      fflush(stderr);
      exit(1);
    }

  /* Open Files */

  infptr = fopen(argv[1], "r");  
  outfptr = fopen(argv[2], "w"); 

  printf ("Translating test vectors to VHDL format...\n");

  /* Title Header */
  fprintf(outfptr,"--------------------------------------------------------");
  fprintf(outfptr,"------------------\n\n");
  fprintf(outfptr,"-- SIMULATION TEST VECTORS FOR floating point multiplier algorithm\n\n");
  fprintf(outfptr,"-- THE MODELS WERE SIMULATED ON THE Synopsys (VERSION 3.0a)");
  fprintf(outfptr," SIMULATOR.\n\n");
  fprintf(outfptr,"--  Developed on Mar 4, 1994 by :\n");
  fprintf(outfptr,"--                                Jesse Pan,\n");
  fprintf(outfptr,"--                                CADLAB,\n");
  fprintf(outfptr,"--                                Univ. of Calif. ,");
  fprintf(outfptr," Irvine.\n\n");
  fprintf(outfptr,"--------------------------------------------------------");
  fprintf(outfptr,"------------------\n\n");

fprintf(outfptr,"use work.FPMULT_PKG.all;\n");

fprintf(outfptr,"entity atest is\n");
fprintf(outfptr,"end atest;\n\n");

fprintf(outfptr,"architecture test1 of atest is\n");
fprintf(outfptr,"\t component fmu\n");
fprintf(outfptr,"\t  port (\n");
fprintf(outfptr,"\t\tclk          : in bit;\n");
fprintf(outfptr,"\t\top1_sign     : in bit;\n");
fprintf(outfptr,"\t\top1_exp      : in exp;\n");
fprintf(outfptr,"\t\top1_mant     : in mantissa;\n");
fprintf(outfptr,"\t\top2_sign     : in bit;\n");
fprintf(outfptr,"\t\top2_exp      : in exp;\n");
fprintf(outfptr,"\t\top2_mant     : in mantissa;\n");
fprintf(outfptr,"\t\tres_sign     : out bit;\n");
fprintf(outfptr,"\t\tres_exp      : out exp;\n");
fprintf(outfptr,"\t\tres_mant     : out mantissa;\n");
fprintf(outfptr,"\t\toperation    : in op_type := idle;\n");
fprintf(outfptr,"\t\tflags        : out bit_vector(3 downto 0)\n");
fprintf(outfptr,"\t);\n");
fprintf(outfptr,"\tend component;\n\n");

fprintf(outfptr,"\t\tsignal clk       : bit;\n");
fprintf(outfptr,"\t\tsignal op1_sign  : bit;\n");
fprintf(outfptr,"\t\tsignal op1_exp   : exp;\n");
fprintf(outfptr,"\t\tsignal op1_mant  : mantissa;\n");
fprintf(outfptr,"\t\tsignal op2_sign  : bit;\n");
fprintf(outfptr,"\t\tsignal op2_exp   : exp;\n");
fprintf(outfptr,"\t\tsignal op2_mant  : mantissa;\n");
fprintf(outfptr,"\t\tsignal res_sign  : bit;\n");
fprintf(outfptr,"\t\tsignal res_exp   : exp;\n");
fprintf(outfptr,"\t\tsignal res_mant  : mantissa;\n");
fprintf(outfptr,"\t\tsignal operation : op_type := idle;\n");
fprintf(outfptr,"\t\tsignal flags     :bit_vector(3 downto 0);\n\n");

fprintf(outfptr,"for a1 : fmu use entity work.fmu(fmu_behavior);\n\n");

fprintf(outfptr,"begin\n\n");

fprintf(outfptr,"A1 : fmu\n");
fprintf(outfptr,"\tport map(\n");
fprintf(outfptr,"\t\tclk,\n");
fprintf(outfptr,"\t\top1_sign,\n");
fprintf(outfptr,"\t\top1_exp,\n");
fprintf(outfptr,"\t\top1_mant,\n");
fprintf(outfptr,"\t\top2_sign,\n");
fprintf(outfptr,"\t\top2_exp,\n");
fprintf(outfptr,"\t\top2_mant,\n");
fprintf(outfptr,"\t\tres_sign,\n");
fprintf(outfptr,"\t\tres_exp,\n");
fprintf(outfptr,"\t\tres_mant,\n");
fprintf(outfptr,"\t\toperation,\n");
fprintf(outfptr,"\t\tflags\n");
fprintf(outfptr,"\t);\n");

fprintf(outfptr,"process\n\n");

fprintf(outfptr,"begin\n\n");

fprintf(outfptr,"-- ** 0 Initialize  ******\n");
fprintf(outfptr,"clk <= '0';\n");
fprintf(outfptr,"wait for 0 ns;\n\n");
fprintf(outfptr,"clk <= '1'; -- Cycle No: 0\n");
fprintf(outfptr,"wait for 5 ns;\n");
fprintf(outfptr,"clk <= '0';\n");
fprintf(outfptr,"wait for 5 ns;\n\n");

  /* Initialize counters */
  line_cnt = 0;
  assert_cnt = 0;
  vec_cnt = 0;
  instr_cnt = 1;

  /* Start line-by-line processing */

  while((c =  fgets(line, MAX_LINE_LENGTH, infptr)) != NULL) /* while not EOF, get a line */
    {
      /* Ignore the first few comment lines */

      if((line_cnt < (INITIAL_COMMENT_LINES + 4) ) &&                       
	 (line_cnt >= INITIAL_COMMENT_LINES) )     
	{

	  /* Initialize port name(line0), port dir(line1), port type(line2) */

	  if (line_cnt != 12) field_cnt = 0;

	  /* Start processing each item in the line, separated by ":" */

	  while((a = strchr(line, ':')) != NULL) /*till you reach end of line*/
	    {
	      /* copy next item into "var". Make "line" point to */
	      /* the item after that.                            */

	      temp = a;          /* copy pointer to next ":" */
	      temp++;            /* take pointer to next location after ":" */
	      *a = '\0';         /* write "end of string" in place of ":" */
	      strcpy(var,line);  /* copy the portion before ":" into "var" */
	      strcpy(line,temp); /* copy the portion after ":" into "line" */

	      switch(line_cnt) {
	      case NAME_LINE1: case NAME_LINE2:
		strcpy(ports[field_cnt].name,var); /* port names */
                break;
	      case DIR_LINE:
		strcpy(ports[field_cnt].port_type,var); /* port dir */
		break;
	      case TYPE_LINE:
		strcpy(ports[field_cnt].data_type,var); /* port type */
                break;  
	      default:		
		break;
		}
	      field_cnt++;
	    }   
	}
      else if( line_cnt >= (INITIAL_COMMENT_LINES + 4) )
	{
	  /* Process the actual test vector lines */
          	  if(line[0] == '*')
	    {
	      /* If the line is a comment line, print it verbatim */

	      fprintf(outfptr,"-- %s",line);
	    }
	  else
	    {
	      /* Reset the boolean variable to show that vec_no */
	      /* has not yet been printed for this line         */

	      printed_vec_no = 0;
	      
	      /* Print some initial statements for each test vector */
	      fprintf(outfptr,"---------- %i ns -----------\n\n",
		      instr_cnt*10);      
	      fprintf(outfptr,"clk <= '1'; --\t Cycle No: %i\n\n",instr_cnt);
	      instr_cnt++;
	      field_cnt = 0;

	      /* Start processing each item in the line, separated by ":" */
	      /* Each item is a signal value (in or out) */
	      while((a = strchr(line, ':')) != NULL) 
		{
		  /* copy next item into "var". Make "line" point to */
		  /* the item after that.                            */

		  temp = a;          /* copy pointer to next : */
		  temp++;            /* take pointer to next location after : */
		  *a = '\0';         /* write "end of string" in place of : */
		  strcpy(var,line);  /* copy the portion before : into "var" */
		  strcpy(line,temp); /* copy the portion after : into "line") */
		  if (strcmp(ports[field_cnt].port_type,"in") == 0 )
		    {
		      /* If its an input port */
		      
		      if (var[0] != '-')
			{
			  /* If the item is NOT marked blank in this line */

			  fprintf(outfptr,"%s <= ",ports[field_cnt].name);
			  fprintf(outfptr,"%s",ports[field_cnt].data_type);
			  fprintf(outfptr,"%s",var);
			  fprintf(outfptr,"%s;\n",ports[field_cnt].data_type);
			}
		      
		      if (strcmp(ports[field_cnt+1].port_type,"out") == 0)
			{
			  fprintf(outfptr,"\nwait for 5 ns;\n");
			}
		    } 
		  else
		    {
		      /* If its an output port */
		      
		      if (var[0] != '-')
			{
			 /* If the item is NOT marked blank in this line */

			 fprintf(outfptr,"ASSERT (%s =",ports[field_cnt].name);
			 fprintf(outfptr," %s",ports[field_cnt].data_type);
			 fprintf(outfptr,"%s",var);
			 fprintf(outfptr,"%s)",ports[field_cnt].data_type);
			 fprintf(outfptr," REPORT ");
			 fprintf(outfptr,"\"Assert %i : < ",assert_cnt);
			 fprintf(outfptr,"%s /= ",ports[field_cnt].name);
		         fprintf(outfptr,"%s >\"",var);
			  
			  /* Vector Count is printed only when outputs are */
			  /* tested and that too only once for each vector */
		      
			  if(printed_vec_no == 0)
			    {
			      vec_cnt++;
			      printed_vec_no = 1;
			    }
			  fprintf(outfptr,"\n\tSEVERITY warning;\n");
			  assert_cnt++;
			}
		    }

		  field_cnt++;
		}
	      /* Print ending statements for test vector */
	     
              fprintf(outfptr,"clk <= '0';\n");
              fprintf(outfptr,"wait for 5 ns;\n\n");
            }
         }     
      line_cnt++;
    }

  fprintf(outfptr,"\nend process;\n");
  fprintf(outfptr,"end test1;\n");
 }
