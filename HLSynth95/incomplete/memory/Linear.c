/* This code implements a general linear recurrence solver. */

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


main()
{
    long argument , k , l , i, kb5i;
    double sa[101], sb[101], b5[101], stb5;

    kb5i = 0;
    for ( l=1 ; l<=1000 ; l++ ) {
        for ( k=0 ; k<101 ; k++ ) {
            b5[k+kb5i] = sa[k] + stb5*sb[k];
            stb5 = b5[k+kb5i] - stb5;
        }
        for ( i=1 ; i<=101 ; i++ ) {
            k = 101 - i ;
            b5[k+kb5i] = sa[k] + stb5*sb[k];
            stb5 = b5[k+kb5i] - stb5;
        }
    }
}
