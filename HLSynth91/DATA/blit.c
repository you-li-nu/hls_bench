
BLITTER DESCRIPTION
--------------------

The description is divided in five files:
	Makefile
	blitter.h
	blitter.c
	blitsup.c
	initreg
which can be obtained by cutting the remainder in the right way.
The file blitter.c contains the behavioural description of the
bitblitter. The file blitsup.c contains several support functions
which make it possible to simulate the behaviour of the description by
running the C program. An additional file with a sample input 
is given in the file:
	initreg
After running the makefile the simulation can be run by the
command:
	blitter < initreg

[=*=*=*=*=*=*=*=*=*=*  CUT HERE :  BEGINING OF  Makefile =*=*=*=*=*=*]

OBJECTS= blitter.o \
         blitsup.o

CFLAGS = -DSIMULATION

INCLUDES = blitter.h

blitter: $(OBJECTS)
	cc -g $(OBJECTS) -o blitter



[=*=*=*=*=*=*=*=*=*=*= CUT HERE :  BEGINING OF  blitter.h =*=*=*=*=*=*]


/*********************************************************************

Name/Version     : BLITTER/1.0

Language         : C
Operating system : UNIX/BSD4.2
Host machine     : APOLLO DOMAIN 3000

Author           : L. Stok
Creation date    : July 1988

File		     : blitter.h

(c) Copyright Eindhoven University of Technology 1988,
    Group Automatic System Design (ES).

*********************************************************************/

#include <stdio.h>

#define TRUE       1
#define FALSE      0

typedef struct _PORT
{
	short fildes;
	short size;    /* byte count !!*/
} PORT;


typedef unsigned short   WORD;
typedef unsigned char    UBYTE;
typedef unsigned long    ADDRESS;

#define MIN(a,b)         (((a)<(b))?(a):(b))
#define MAX(a,b)         (((a)>(b))?(a):(b))
#define BIT(i,a)         (((a) >> (i)) & 1)
#define SHIFT(a,b,n,d) (WORD)(d) ? \
              ((((((long) (a) << 16) | (b)) << (n)) >> 16) & 0xFFFF) : \
              ((((((long) (b) << 16) | (a)) >> (n)) & 0xFFFF))

#define MASK(i)          ((1) << (i))

/* Reading shift values from the control registers, rest is extracted using BIT */
#define SH(a)            (((a) >> 12) & 0xf)
#define USEA             11
#define USEB             10
#define USEC              9
#define USED              8
#define EFE               4
#define IFE               3
#define FCI               2
#define DESC              1
#define LINE              0

/* Reading sizes from size register */
#define WIDTH(a)         ((a) & 0x3f)
#define HEIGHT(a)        (((a) >> 6) & 0x3ff)

/* On input addresses written in two parts: bits 1-15 (LOW) , 16-18 (HIGH) */
#define PUTLOW(a,d)      ((a) = ((a) & ~0x7fff) | (((d) >> 1) & 0x7fff ))
#define PUTHIGH(a,d)     ((a) = ((a) &  0x7fff) | (((d) & 0x7 ) << 15))

/* Addresses are written to two address ports: reg (1-8) and ram (9-17) */
#define REG_ADDR(a)      ((a) & 0xff )
#define RAM_ADDR(a)      (((a) >> 8) & 0x1ff )

#define A          0
#define B          1
#define C          2
#define D          3

#define BLTCON0    0x40  /* 64*/
#define BLTCON1    0x42  /* 66*/

#define BLTAFWM    0x44  /* 68*/

#define BLTALWM    0x46  /* 70*/

#define BLTAPTH    0x50  /* 80*/
#define BLTAPTL    0x52  /* 82*/

#define BLTBPTH    0x4c  /* 76*/
#define BLTBPTL    0x4e  /* 78*/

#define BLTCPTH    0x48  /* 72*/
#define BLTCPTL    0x4a  /* 74*/

#define BLTDPTH    0x54  /* 84*/
#define BLTDPTL    0x56  /* 86*/

#define BLTAMOD    0x64  /*100*/
#define BLTBMOD    0x62  /* 98*/
#define BLTCMOD    0x60  /* 96*/
#define BLTDMOD    0x66  /*102*/

#define BLTADAT    0x74  /*116*/
#define BLTBDAT    0x72  /*114*/
#define BLTCDAT    0x70  /*112*/
#define BLTDDAT    0x0   /* 0 */
                           
#define BLTSIZE    0x58  /*88*/
                                
#ifdef SIMULATION
/* defining the width and the height of the screen */
#define SCR_W           4     /* byte count !! */
#define SCR_H          20
#define MEM_SIZE       SCR_W*SCR_H
#endif
                                                                            

[=*=*=*=*=*=*=*=*=*=*= CUT HERE :  BEGINING OF  blitter.c =*=*=*=*=*=*=*=*=*]


/*********************************************************************

Name/Version     : BLITTER/1.0

Language         : C
Operating system : UNIX/BSD4.2
Host machine     : APOLLO DOMAIN 3000

Author           : L. Stok
Creation date    : July 1988

File		     : blitter.c

(c) Copyright Eindhoven University of Technology 1988,
    Group Automatic System Design (ES).

*********************************************************************/

#include "blitter.h"

/*------------------------ SIMULATION SECTION --------------------------------*/
#ifdef SIMULATION

extern PORT *port ();
extern unsigned int get();
extern void put();
extern WORD getword();
extern void putword();
extern void show_word ();
extern void loadmem ();

#endif

/*------------------------ FUNCTIONS ----------------------------------------*/

void write_register();
void blit();
WORD logop();
void get_data();
void put_data();

/*------------------------ BLITTER REGISTERS --------------------------------*/
/* (see Appendix-A page 2-4)                                                 */

WORD bltcon0 = 0;                /* control register 0 */
WORD bltcon1 = 0;                /* control register 1 */
WORD bltsize = 0;                /* size of window, if written starts blit */

ADDRESS bltCpt = 0;              /* high/low source C pointer */
ADDRESS bltBpt = 0;              /* high/low source B pointer */
ADDRESS bltApt = 0;              /* high/low source A pointer */
ADDRESS bltDpt = 0;              /* high/low destination D pointer */

WORD  bltAfwm = 0;
WORD  bltAlwm = 0;               /* first/last word masks for A  */
WORD  bltCmod = 0;
WORD  bltBmod = 0;
WORD  bltAmod = 0;               /* modulo's for C; B, and A respectively */
WORD  bltDmod = 0;               /* modulo for destination D */
WORD  bltAdat = 0;
WORD  bltBdat = 0;
WORD  bltCdat = 0;               /* source data registers */
WORD  bltDdat = 0;               /* destination data register */

/*------------------------ SCREEN MEMORY ------------------------------------*/
WORD  mem[ MEM_SIZE-1 ];


/*------------------------ AUXILIARY REGISTERS ------------------------------*/
/* (see Blitter schema fig 6-15, page 196)                                   */

WORD  bltAold; /* source data registers */
WORD  bltBold; 
WORD  bltCold; 

/*------------------------ I/O PORTS ----------------------------------------*/
/* (see Appendix-C page C-2)                                                 */

PORT *reg_addr_port;      /* R/W port: R register address; W part RAM address*/
PORT *ram_addr_port;      /* W port:   rest RAM address                      */
PORT *data_bus;           /* R/W port: data reading and writing              */
PORT *data_bus_req;       /* W port:   request for data bus                  */
PORT *dma_req;            /* R port:   acknowledge from DMA controller       */
PORT *ram_write;          /* W port:   selects read/write from/to RAM        */
PORT *chip_select;        /* R port:   register read enable                  */
PORT *interrupt;          /* W port:   interrupt when blit completed         */
	 
 
/*------------------------ MAIN ROUTINE --------------------------------------*/

main()
{
  UBYTE reg_address;
  WORD  data;

  /* these should be declarations actually */
  reg_addr_port = port( 8 );
  ram_addr_port = port( 10 );
  data_bus      = port( 16 );
  data_bus_req  = port( 1 );
  dma_req       = port( 1 );
  ram_write     = port( 1 );
  chip_select   = port( 1 );
  interrupt     = port( 1 );

#ifdef SIMULATION
  /* initialisation of the screen memory */
  loadmem();
#endif	

  while (TRUE)
    {
      reg_address = get( reg_addr_port,"reg_addr_port" );
      if ( BIT( 6,reg_address))
	{
	  data = get( data_bus,"data_bus");
	  write_register( reg_address, data );
	  if (reg_address == BLTSIZE)
	    {
	      blit();
	      put( interrupt , 1,"interrupt");
	    }
	}
    }
}
/*------------------------ WRITING A REGISTER -------------------------------*/

void write_register( addr, data )

UBYTE addr;
WORD  data;
{
	switch (addr)
	{
	case BLTCON0: bltcon0 = data; break;
	case BLTCON1: bltcon1 = data; break;
	case BLTSIZE: bltsize = data; break;

	case BLTAFWM: bltAfwm = data; break;
	case BLTALWM: bltAlwm = data; break;

	case BLTAPTL: PUTLOW(  bltApt, data ); break;
	case BLTAPTH: PUTHIGH( bltApt, data ); break;
	case BLTBPTL: PUTLOW(  bltBpt, data ); break;
	case BLTBPTH: PUTHIGH( bltBpt, data ); break;
	case BLTCPTL: PUTLOW(  bltCpt, data ); break;
	case BLTCPTH: PUTHIGH( bltCpt, data ); break;
	case BLTDPTL: PUTLOW(  bltDpt, data ); break;
	case BLTDPTH: PUTHIGH( bltDpt, data ); break;

	case BLTAMOD: bltAmod = data >> 1; break;
	case BLTBMOD: bltBmod = data >> 1; break;
	case BLTCMOD: bltCmod = data >> 1; break;
	case BLTDMOD: bltDmod = data >> 1; break;

	case BLTADAT: bltAdat = data; break;
	case BLTBDAT: bltBdat = data; break;
	case BLTCDAT: bltCdat = data; break;
	case BLTDDAT: bltDdat = data; break;
	}
}

/*------------------------ ACTUAL BLITTING ----------------------------------*/

void blit()
{
  WORD logop();
  int i, j, fco;

  for ( i = HEIGHT( bltsize ); i>0 ; i-- )
    {
      bltAdat = 0;		/* reset registers at the start of a      */
      bltBdat = 0;		/* new line.                              */
      bltCdat = 0;
      fco = BIT( FCI, bltcon1 ); /* reset the fill carry bit   */
      get_data();
      bltAdat = bltAdat & bltAfwm;

      for ( j = WIDTH( bltsize ) - 2; j>0 ; j-- )
	{
	  get_data();
	  bltDdat = logop( SHIFT( bltAold, bltAdat,
				 SH( bltcon0), BIT( DESC , bltcon1 ) ),
			  SHIFT( bltBold, bltBdat, SH( bltcon1 ),
				BIT( DESC, bltcon1 ) ), bltCold, fco );
	  put_data();
	}

      if (WIDTH( bltsize ) > 1)
	{
	  get_data();
	  bltAdat = bltAdat & bltAlwm;
	  bltDdat = logop( SHIFT( bltAold, bltAdat,
				 SH( bltcon0 ), BIT( DESC , bltcon1 ) ),
			  SHIFT( bltBold, bltBdat, SH( bltcon1 ),
				BIT( DESC, bltcon1 ) ), bltCold, fco );
	  put_data();
	}
      else
	bltAdat = bltAdat & bltAlwm;
      bltDdat = logop( SHIFT ( bltAdat, 0, 
			      SH (bltcon0), BIT( DESC, bltcon1 ) ), 
		      SHIFT( bltBdat, 0, SH( bltcon1 ), 
			    BIT( DESC, bltcon1 ) ), bltCdat, fco );
      put_data();
      if (BIT( DESC, bltcon1 ))
	{
	  bltApt -= bltAmod;
	  bltBpt -= bltBmod;
	  bltCpt -= bltCmod;
	  bltDpt -= bltDmod;
	}
      else
	{
	  bltApt += bltAmod;
	  bltBpt += bltBmod;
	  bltCpt += bltCmod;
	  bltDpt += bltDmod;
	}
    }
}

/*------------------------ LOGIC OPERATION ----------------------------------*/

WORD logop( Adata, Bdata, Cdata, fco )

WORD Adata, Bdata, Cdata;
{
  WORD ddat;
  int  j;

  ddat = ( (BIT( 7, bltcon0 ) *  Adata &  Bdata &  Cdata ) |
	  (BIT( 6, bltcon0 ) *  Adata &  Bdata & ~Cdata ) |
	  (BIT( 5, bltcon0 ) *  Adata & ~Bdata &  Cdata ) |
	  (BIT( 4, bltcon0 ) *  Adata & ~Bdata & ~Cdata ) |
	  (BIT( 3, bltcon0 ) * ~Adata &  Bdata &  Cdata ) |
	  (BIT( 2, bltcon0 ) * ~Adata &  Bdata & ~Cdata ) |
	  (BIT( 1, bltcon0 ) * ~Adata & ~Bdata &  Cdata ) |
	  (BIT( 0, bltcon0 ) * ~Adata & ~Bdata & ~Cdata ));
  if( BIT( IFE, bltcon1 ) | ( BIT( EFE, bltcon1 )))
    for( j=0; j<16; j++ )
      {
	fco = fco ^ BIT( j, ddat );
	if BIT( EFE, bltcon1 )
	  {
	    if ( fco == 1 )
	      ddat = ddat | MASK( j );
	    else
	      ddat = ddat & ~MASK( j );
	  }
	if BIT( IFE, bltcon1 )
	  {
	    if ( fco | BIT( j, ddat ))
	      ddat = ddat | MASK( j );
	    else
	      ddat = ddat & ~MASK( j );
	  }

      } 
  return( ddat );
}

/*------------------------ READING MEMORY -----------------------------------*/


void get_data()
{
  bltAold = bltAdat;
  bltBold = bltBdat;
  bltCold = bltCdat;
  if (BIT( USEA, bltcon0 )) 
    bltAdat = getword( bltApt );
  if (BIT( USEB, bltcon0 )) 
    bltBdat = getword( bltBpt );
  if (BIT( USEC, bltcon0 )) 
    bltCdat = getword( bltCpt );
  if (BIT( DESC, bltcon1 ))
    { bltApt--; bltBpt--; bltCpt--; }
  else
    { bltApt++; bltBpt++; bltCpt++; }
}

/*------------------------ WRITING MEMORY -----------------------------------*/

void put_data()
{
  if (BIT( USED, bltcon0 ))
    putword(bltDpt, bltDdat);
  if (BIT( DESC, bltcon1 ))
    bltDpt--;
  else
    bltDpt++;
}



[=*=*=*=*=*=*=*=*=*=*=* CUT HERE :  BEGINING OF  blitsup.c =*=*=*=*=*=*=*=*=*=*]

/*********************************************************************

Name/Version     : BLITTER/1.0

Language         : C
Operating system : UNIX/BSD4.2
Host machine     : APOLLO DOMAIN 3000

Author           : L. Stok
Creation date    : July 1988

File		     : blitsup.c

(c) Copyright Eindhoven University of Technology 1988,
    Group Automatic System Design (ES).

*********************************************************************/

#include "blitter.h" 

/*------------------------ FUNCTIONS-----------------------------------------*/

void show_word ();

/*------------------------ SCREEN MEMORY ------------------------------------*/
extern WORD mem[];

/*------------------------ INITIALISING PORT --------------------------------*/

PORT *port( size )
int size;
{
        char *calloc();
        PORT *newport;

	if (newport = (PORT *) calloc( 1, sizeof( PORT )))
	{
		newport->size    = (size+7)/8;
		newport->fildes  = 0;
		return( newport );
	}
	printf( "Cannot allocate port: size = %d\n", size );
	exit(1);
    return(NULL);
}

/*------------------------ GET ----------------------------------------------*/

unsigned int get( port , name )
PORT *port;
char *name;
{
	unsigned int data;
	printf( "-->%15s" , name );
	scanf( "%u" , &data );
	printf( "  %u\n" , data );  
	return( data );
}

/*------------------------ PUT ----------------------------------------------*/

void put( port, data , name )
PORT *port;
int  data;
char *name;
{
    printf( "<--%15s %u\n" , name , data );
}         


/*--------------------------  GETWORD   -------------------------------------*/

WORD getword( addr )
     
ADDRESS addr;
{

  show_word(mem[addr]);
  printf("getword %d\n",addr);                             
  return( mem[ addr ] );
}

/*--------------------------  PUTWORD   -------------------------------------*/

void putword( addr, data )
     
ADDRESS addr;
WORD    data;
{
  /* writing in memory is done in the array mem         */
  mem[ addr ] = data;                                 
  show_word(mem[addr]);
  printf("putword %d\n",addr);     

}

/*--------------------------AUXILLARY ROUTINES------------------------------*/

void show_word ( data )
     WORD data;
{                  
  int i;
  for (i = 0; i<= 15 ;i++)
    if(BIT(i,data)) 
      printf( " 1 "); 
    else 
      printf(" 0 ");
}

void loadmem ()
{
  int  i,k ;

  for (i=0;i< MEM_SIZE;i++)
    {
      scanf("%d",&k); 
      mem[i] = k;
    } 
} 

[*=*=*=*=*=*=*=*=*=*   CUT HERE :  BEGINING OF  initreg   *=*=*=*=*=*=*=*]

0 65535 0 0 1 0 0 0 0 0
0 65535 0 0 1 0 0 0 0 0
0 65535 0 0 1 0 0 0 0 0
0 65535 0 0 1 0 0 0 0 0
0 65535 0 0 1 0 0 0 0 0
0 65535 0 0 1 0 0 0 0 0
0 65535 0 0 1 0 0 0 0 0
0 65535 0 0 1 0 0 0 0 0


64 6416 
66 0 
68 65535 
70 65535
80 0 
82 12
76 0 
78 0
72 0 
74 0
84 0 
86 40
100 3 
98 3 
96 3 
102 3
88 132



