/* This code implements the Debaucles 4-Coefficient Wavelet filter to */
/* vector a[1..n] containing complex numbers. A[i] contains the real  */
/* and A[i+100] contains the imaginary. This algorithm is used in     */
/* image compression. */

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


#define MAX 100



main()
{
  int i, j, filter;
  float wksp[MAX+MAX], a[MAX], C0, C1, C2, C3;

  if (filter == 0) {
    for (i=0,j=0; j<(MAX-3)/2; j+=2, i++) {
      wksp[i] = C0*a[j] + C1*a[j+1] + C2*a[j+2] + C3*a[j+3];
      wksp[i+100] = C3*a[j] - C2*a[j+1] + C1*a[j+2] - C0*a[j+3];
    }
  }
  else {
    /* transpose */
    for (i=0,j=0; j<(MAX-3)/2; j+=2, i++) {
      wksp[i] = C0*a[j+2] + C1*a[j+3] + C2*a[j+4] + C3*a[j+5];
      wksp[i+100] = C3*a[j+2] - C2*a[j+3] + C1*a[j+4] - C0*a[j+5];
    }
  }

}  /* main */
