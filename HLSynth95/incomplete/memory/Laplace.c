/* This code implements a Laplace algorithm to perform edge enhancement */
/* of northerly directional edges in an image. */

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


main()
{
  int i, j;
  int image1[MAX][MAX], image2[MAX][MAX];

  for (i=0; i<MAX; i++) {
    for (j=0; j<MAX; j++) {
      image2[i][j] = image1[i-1][j-1] +
		     -2 * image1[i][j-1] +
		     image1[i+1][j-1] +
		     -2 * image1[i-1][j] +
		     4 * image1[i][j] +
		     -2 * image1[i+1][j] +
		     image1[i-1][j+1] +
		     -2 * image1[i][j+1] +
		     image1[i+1][j+1];
    }
  }
}  /* main */

