/* Red-black Gauss-Seidel relaxation method taken from */
/* Numerical Recipes in C, 2nd edition page 881        */

/* 
-- Submitted By: David Kolson (dkolson@ics.uci.edu) - 08 Dec 94
--
-- Verification Information:
--
--                  Verified     By whom?           Date         Simulator
--                  --------   ------------        --------     ------------
--  Syntax            yes     Preeti R. Panda      17 Jan 95         -
--  Functionality     yes     David Kolson             ?             -
*/

#include <stdio.h>

#define MAX 100
void relax(double **u, double **rhs, int n)
{

  int i, ipass, isw, j, jsw=1;
  double h, h2;

  h = 1.0/(n-1);
  h2 = h*h;
  for (ipass=1; ipass<=2; ipass++, jsw=3-jsw) {    /* Red and black sweeps */
    isw = jsw;
    for (j=2; j<n; j++, isw=3-isw)
      for (i=isw+1; i<n; i+=2)
	/* the Gauss-Seidel formula */
	u[i][j] = 0.25 * (u[i+1][j]+u[i-1][j]+u[i][j+1]+u[i][j-1]-h2*rhs[i][j]);
  }
}  /* relax */




main()
{
  double x[MAX], y[MAX];

  relax(x, y, MAX);
}  /* main */
