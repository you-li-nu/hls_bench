
/*----------------------------------------------------------------------*/
/*									*/
/*			JACOBIAN.C		     Frank Park		*/
/*						     November 2, 1992	*/
/*									*/
/*----------------------------------------------------------------------*/
/*
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax          Yes		Preeti R. Panda    25 Jan 95    cc      
--  Functionality   ?              
*/
#include <stdio.h>
#include "math.h"

/*----------------------------------------------------------------------*/
/*									*/
/*  	    		  Definitions					*/
/*									*/
/*----------------------------------------------------------------------*/

#define PI	 3.14159265
#define ZERO	 1.0e-5   		    /* Floating point precision */

#define	Sqr(x)		(double) ((x) * (x))
#define	fsqrt(x)	(double) (sqrt((double)(x)))
#define	fsin(x)		(double) ( sin((double)(x)))
#define	fcos(x)		(double) ( cos((double)(x)))
#define	facos(x)	(double) (acos((double)(x)))

/*----------------------------------------------------------------------*/
/*									*/
/*  	    		Data Structures					*/
/*									*/
/*----------------------------------------------------------------------*/


/*  Elements of the Lie Group SE(3)  */

typedef struct {
	double   *p;		/* position vector p[1..3] */
	double  **R;		/* rotation matrix R[1..3][1..3] */
} SE3;


/*  Elements of the Lie algebra se(3)  */

typedef struct {
	double  *w;		/* rotational velocity w[1..3]  */
	double  *v;		/* translational velocity v[1..3] */
} se3;

/*----------------------------------------------------------------------*/
/*									*/
/*		Memory Allocation Routines  	    			*/
/*									*/
/*----------------------------------------------------------------------*/

/* Error message handler */

void NRerror(error_text)
char error_text[];
{
	fprintf(stderr,"Run-time error ... \n");
	fprintf(stderr,"%s\n", error_text);
	fprintf(stderr,"... Now exiting to system ... \n");
	exit(1);
}


/* Allocate data structure of type se3. */

se3 *Allocate_se3()
{
	se3 *g;

	g = (se3 *) calloc(1, sizeof(se3));
	g->w = (double *) calloc(3, sizeof(double));
	g->w -= 1;
	g->v = (double *) calloc(3, sizeof(double));
	g->v -= 1;
	if (!g->w || !g->v) 
	    NRerror("Allocation failure in Allocate_se3()");
	return(g);
}


/* Allocate data structure of type SE3. */

SE3 *Allocate_SE3()
{
	SE3 *G;
	int  i;

	G = (SE3 *) calloc(1, sizeof(SE3));
	G->p = (double *) calloc(3, sizeof(double));
	G->p -= 1;
	if (!G->p) NRerror("Allocation failure in Allocate_SE3()");

	G->R = (double **) calloc(3, sizeof(double *));

	if (!G->R) NRerror("Allocation failure 1 in Allocate_SE3()");
	G->R -= 1;

	for (i  = 1; i <= 3; i++) {
	    G->R[i] = (double *) calloc(3, sizeof(double));
	    if (!(G->R[i])) 
	        NRerror("Allocation failure 2 in Allocate_SE3()");
	    G->R[i] -= 1;
	}
	return(G);
}


/* De-allocate memory for data structure of type se3. */
/* CURRENTLY NOT USED */

void 	Free_se3(g)
se3    *g;
{
	cfree((char*) (g->w+1));
	cfree((char*) (g->v+1));
	cfree((char*) g);
}


/* De-allocate memory for data structure of type SE3. */
/* CURRENTLY NOT USED */

void	Free_SE3(G)
SE3    *G;
{
	int i;

	cfree((char*) (G->p+1));
	for (i  = 3; i >= 1; i--) cfree((char*) (G->R[i]+1));
	cfree((char*) (G->R+1));
	cfree((char*) G);
}

/*----------------------------------------------------------------------*/
/*									*/
/*  Exp() computes the exponential of an element g of type se3.		*/
/*  The result is an element G of type SE3.				*/
/*									*/
/*----------------------------------------------------------------------*/

void Exp(g, G)
se3 *g;
SE3 *G;
{
	int	i, j;
	double  sqr_w1, sqr_w2, sqr_w3, c1, c2, c3;
	double	nw, sqr_nw, sin_nw, cos_nw;
	double  ww_11, ww_12, ww_13, ww_22, ww_23, ww_33;
	double  P11, P12, P13, P21, P22, P23, P31, P32, P33;

	/* Check if angle of rotation is zero. */
	sqr_w1	=  Sqr(g->w[1]);
	sqr_w2	=  Sqr(g->w[2]);
	sqr_w3	=  Sqr(g->w[3]);
	sqr_nw 	=  sqr_w1 + sqr_w2 + sqr_w3; 
	nw	=  fsqrt(sqr_nw);
	if (nw <= ZERO)
	    for (i = 1; i <= 3; i++) 
		{
	 	 G->p[i] = g->v[i];
	         for (j = 1; j <= 3; j++)
		      G->R[i][j] = (i==j) ? 1.0 : 0.0;
		}
	else
	   {
	    sin_nw	=  fsin(nw);
	    cos_nw	=  fcos(nw);
	    c1    	=  sin_nw / nw;
	    c2          =  (1.0-cos_nw) / sqr_nw;
	    c3		=  (nw - sin_nw) / (sqr_nw*nw);
	    ww_11	= -(sqr_w3+sqr_w2);
	    ww_22	= -(sqr_w3+sqr_w1);
	    ww_33	= -(sqr_w2+sqr_w1);
	    ww_12	=  g->w[1]*g->w[2];
	    ww_13	=  g->w[1]*g->w[3];
	    ww_23	=  g->w[2]*g->w[3];

	    G->R[1][1] 	=  1.0	      + c2*ww_11;
	    G->R[2][2] 	=  1.0	      + c2*ww_22;
	    G->R[3][3] 	=  1.0	      + c2*ww_33;
	    G->R[1][2] 	= -c1*g->w[3] + c2*ww_12;
	    G->R[2][1] 	=  c1*g->w[3] + c2*ww_12;
	    G->R[1][3] 	=  c1*g->w[2] + c2*ww_13;
	    G->R[3][1]  = -c1*g->w[2] + c2*ww_13;
	    G->R[2][3]  = -c1*g->w[1] + c2*ww_23;
	    G->R[3][2] 	=  c1*g->w[1] + c2*ww_23;

	    P11		=  1.0 	      + c3*ww_11;
	    P22		=  1.0 	      + c3*ww_22;
	    P33		=  1.0 	      + c3*ww_33;
	    P12 	= -c2*g->w[3] + c3*ww_12;
	    P21 	=  c2*g->w[3] + c3*ww_12;
	    P13 	=  c2*g->w[2] + c3*ww_13;
	    P31 	= -c2*g->w[2] + c3*ww_13;
	    P23 	= -c2*g->w[1] + c3*ww_23;
	    P32 	=  c2*g->w[1] + c3*ww_23;

	    G->p[1]	=  P11*g->v[1] + P12*g->v[2] + P13*g->v[3];
	    G->p[2]	=  P21*g->v[1] + P22*g->v[2] + P23*g->v[3];
	    G->p[3]	=  P31*g->v[1] + P32*g->v[2] + P33*g->v[3];
	   }
}
/*----------------------------------------------------------------------*/
/*									*/
/*    SE3_Mult() computes the product of two SE3 matrices.		*/
/*									*/
/*----------------------------------------------------------------------*/

void  SE3_Mult(X, Y, Z)
SE3  *X, *Y, *Z;
{
   Z->R[1][1] =     X->R[1][1]*Y->R[1][1] 
		  + X->R[1][2]*Y->R[2][1]
		  + X->R[1][3]*Y->R[3][1];
   Z->R[1][2] =     X->R[1][1]*Y->R[1][2] 
		  + X->R[1][2]*Y->R[2][2]
		  + X->R[1][3]*Y->R[3][2];
   Z->R[1][3] =     X->R[1][1]*Y->R[1][3] 
		  + X->R[1][2]*Y->R[2][3]
		  + X->R[1][3]*Y->R[3][3];
   Z->R[2][1] =     X->R[2][1]*Y->R[1][1] 
		  + X->R[2][2]*Y->R[2][1]
		  + X->R[2][3]*Y->R[3][1];
   Z->R[2][2] =     X->R[2][1]*Y->R[1][2] 
		  + X->R[2][2]*Y->R[2][2]
		  + X->R[2][3]*Y->R[3][2];
   Z->R[2][3] =     X->R[2][1]*Y->R[1][3] 
		  + X->R[2][2]*Y->R[2][3]
		  + X->R[2][3]*Y->R[3][3];
   Z->R[3][1] =     X->R[3][1]*Y->R[1][1] 
		  + X->R[3][2]*Y->R[2][1]
		  + X->R[3][3]*Y->R[3][1];
   Z->R[3][2] =     X->R[3][1]*Y->R[1][2] 
		  + X->R[3][2]*Y->R[2][2]
		  + X->R[3][3]*Y->R[3][2];
   Z->R[3][3] =     X->R[3][1]*Y->R[1][3]
		  + X->R[3][2]*Y->R[2][3]
		  + X->R[3][3]*Y->R[3][3];
   Z->p[1]	=   X->R[1][1]*Y->p[1] + X->R[1][2]*Y->p[2]
		  + X->R[1][3]*Y->p[3] + X->p[1]; 
   Z->p[2]	=   X->R[2][1]*Y->p[1] + X->R[2][2]*Y->p[2]
		  + X->R[2][3]*Y->p[3] + X->p[2];
   Z->p[3]	=   X->R[3][1]*Y->p[1] + X->R[3][2]*Y->p[2]
		  + X->R[3][3]*Y->p[3] + X->p[3];
}
/*----------------------------------------------------------------------*/
/*									*/
/*  Ad_G() computes the product of the three matrices G X G^(-1), 	*/
/*  where G is an element of SE(3), and X an element of se(3).  The	*/
/*  product Y is then an element of se(3).				*/
/*									*/
/*----------------------------------------------------------------------*/

void 	 Ad_G(G, X, Y)
SE3	*G;
se3	*X, *Y;
{
   Y->w[1] =  G->R[1][1]*X->w[1]
	    + G->R[1][2]*X->w[2]
	    + G->R[1][3]*X->w[3];
   Y->w[2] =  G->R[2][1]*X->w[1]
	    + G->R[2][2]*X->w[2]
	    + G->R[2][3]*X->w[3];
   Y->w[3] =  G->R[3][1]*X->w[1]
	    + G->R[3][2]*X->w[2]
	    + G->R[3][3]*X->w[3];

   Y->v[1] =  G->R[1][1]*X->v[1] 
	    + G->R[1][2]*X->v[2] 
	    + G->R[1][3]*X->v[3]
	    + G->p[2]*Y->w[3] - G->p[3]*Y->w[2]; 

   Y->v[2] =  G->R[2][1]*X->v[1]
	    + G->R[2][2]*X->v[2]
	    + G->R[2][3]*X->v[3]
	    + G->p[3]*Y->w[1] - G->p[1]*Y->w[3]; 

   Y->v[3] =  G->R[3][1]*X->v[1]
	    + G->R[3][2]*X->v[2]
	    + G->R[3][3]*X->v[3]
	    + G->p[1]*Y->w[2] - G->p[2]*Y->w[1]; 
}
/*----------------------------------------------------------------------*/
/*									*/
/*  Jacobian() comutes the Jacobian of the forward kinematic map. 	*/
/*  x[1..n] is the vector of joint variables, and the Jacobian matrix	*/
/*  is an array of se3 structures, J[1..n].				*/
/*									*/
/*----------------------------------------------------------------------*/

void	  Jacobian(n, x, A, J)
int	  n;
float	 *x;
se3	**A, **J;
{
   int    i, j;
   SE3	 *G, *exp_g;
   se3	 *g;

   g     = Allocate_se3();
   exp_g = Allocate_SE3();
   G     = Allocate_SE3();

   for (i=1; i<=3; i++)		/* Initialize G to identity */
       {	
	G->p[i] = 0.0;
        for (j=1; j<=3; j++)
	     G->R[i][j] = (i == j) ? 1.0 : 0.0; 
       }

   for (i=1; i<=3; i++)		   /* first column of J */
       {
	J[1]->w[i] = A[1]->w[i];
	J[1]->v[i] = A[1]->v[i];
       }

   for (i=2; i<=n; i++)
       {
	g->w[1]  = A[i]->w[1] * x[i];
	g->w[2]  = A[i]->w[2] * x[i];
	g->w[3]  = A[i]->w[3] * x[i];
	g->v[1]  = A[i]->v[1] * x[i];
	g->v[2]  = A[i]->v[2] * x[i];
	g->v[3]  = A[i]->v[3] * x[i];
	Exp(g, exp_g);
	SE3_Mult(G, exp_g, G);
	Ad_G(G, A[i], J[i]);
       }
}
/*----------------------------------------------------------------------*/
/*									*/
/*  As an example, we compute the jacobian of a sample 7-link 		*/
/*  manipulator.  The robot parameters are ialn (inner arm length)	*/
/*  and oaln (outer arm length).					*/
/*									*/
/*----------------------------------------------------------------------*/

main()
{
   int     i, n=7;
   float   ialn=12.576, oaln=15.765, x[8];
   se3   **A, **J;

   /* Set up an array of se3 structures A[1..n], J[1..n] */
   A = (se3 **) calloc(n, sizeof(se3 *)); A -= 1;
   J = (se3 **) calloc(n, sizeof(se3 *)); J -= 1;
   for (i=1; i<=n; i++) {
	A[i] = Allocate_se3();
	J[i] = Allocate_se3();
       }

   /* Set the A[i] matrices in the POE formula */
   A[1]->w[1] =  0.0;
   A[1]->w[2] =  0.0;
   A[1]->w[3] = -1.0;
   A[1]->v[1] =  0.0;
   A[1]->v[2] =  0.0;
   A[1]->v[3] =  0.0;

   A[2]->w[1] =  0.0;
   A[2]->w[2] =  1.0;
   A[2]->w[3] =  0.0;
   A[2]->v[1] =  ialn+oaln;
   A[2]->v[2] =  0.0;
   A[2]->v[3] =  0.0;

   A[3]->w[1] =  0.0;
   A[3]->w[2] =  0.0;
   A[3]->w[3] =  1.0;
   A[3]->v[1] =  0.0;
   A[3]->v[2] =  0.0;
   A[3]->v[3] =  0.0;

   A[4]->w[1] =  0.0;
   A[4]->w[2] =  1.0;
   A[4]->w[3] =  0.0;
   A[4]->v[1] =  oaln;
   A[4]->v[2] =  0.0;
   A[4]->v[3] =  0.0;

   A[5]->w[1] =  0.0;
   A[5]->w[2] =  0.0;
   A[5]->w[3] =  1.0;
   A[5]->v[1] =  0.0;
   A[5]->v[2] =  0.0;
   A[5]->v[3] =  0.0;

   A[6]->w[1] =  0.0;
   A[6]->w[2] =  1.0;
   A[6]->w[3] =  0.0;
   A[6]->v[1] =  0.0;
   A[6]->v[2] =  0.0;
   A[6]->v[3] =  0.0;

   A[7]->w[1] =  0.0;
   A[7]->w[2] =  0.0;
   A[7]->w[3] =  1.0;
   A[7]->v[1] =  0.0;
   A[7]->v[2] =  0.0;
   A[7]->v[3] =  0.0;

   /* Generate a set of arbitrary joint values, in radians */
   x[1] = 1.4;
   x[2] = 2.234;
   x[3] = 1.485;
   x[4] = 1.239;
   x[5] = 0.954;
   x[6] = 1.843;
   x[7] = 0.231;

   /* Find the Jacobian */
   Jacobian(n, x, A, J);

   /*  Display results */
   printf("The Jacobian matrix (transposed):\n ");
   for (i=1; i<=n; i++) 
   	printf("%4.3f  %4.3f  %4.3f  %4.3f  %4.3f  %4.3f\n", 
	 J[i]->w[1], J[i]->w[2], J[i]->w[3],
	   J[i]->v[1], J[i]->v[2], J[i]->v[3]);
}


