/* This code applies a low-pass filter to an image stored in array a. */
/* Low-pass filters accentuate low frequencies in an image---that is, */
/* the resulting image has lower changes between neighboring color values */
/* This code has been parameterized for arbitrary coefficients */


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


#define	MAX	100
 
 main ()
 {
   int i, j;
   float c0, c1, c2, c3, c4, c5, c6, c7, c8;
   float a[MAX][MAX];
 
   for (i=0; i<MAX; i++) {
     for (j=0; j<MAX; j++) {
        a[i][j] = c0 * a[i-1][j-1] + c1 * a[i-1][j] + c2 * a[i-1][j+1] +
                  c3 * a[i][j-1]   + c4 * a[i][j]   + c5 * a[i][j+1]   +
                  c6 * a[i+1][j-1] + c7 * a[i+1][j] + c8 * a[i+1][j+1];
     }
   }
 }
 

