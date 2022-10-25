/* This is a Successive Over-Relaxation (SOR) algorithm found in the */
/* Numerical Recipies in C book, page 869. It is used in evaluating  */
/* partial differential equations.

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


#define N 100


main()
{
  float a[N][N], b[N][N], c[N][N], d[N][N], e[N][N], f[N][N];
  float omega, resid, u[N][N];
  int j, l;

  for (j=2; j<N; j++)
    for (l=1; l<N; l+=2) {
      resid = a[j][l]*u[j+1][l] +
	      b[j][l]*u[j-1][l] +
	      c[j][l]*u[j][l+1] +
	      d[j][l]*u[j][l-1] +
	      e[j][l]*u[j][l]   -
	      f[j][l];
      u[j][l] -= omega*resid/e[j][l];
    }
}  /* main */
