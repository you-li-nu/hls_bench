
#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of shell archive."
# Contents:  traffic/traffic.hc traffic/traffic.pat traffic/traffic.mon
#   traffic/traffic.sif traffic/traffic.out.gold
# Wrapped by synthesis@sirius on Thu Jul 26 17:17:55 1990
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'traffic/traffic.hc' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'traffic/traffic.hc'\"
else
echo shar: Extracting \"'traffic/traffic.hc'\" \(1687 characters\)
sed "s/^X//" >'traffic/traffic.hc' <<'END_OF_FILE'
X/*
X *	Mead/Conway Traffic Light Controller
X *
X *	Hercules Synthesis System
X *	David Ku
X *	June 8, 1988
X */
X
X# define HIWAY_GREEN  0
X# define HIWAY_YELLOW 1
X# define FARM_GREEN   2
X# define FARM_YELLOW  3
X
X# define GREEN  1
X# define YELLOW 2
X# define RED    3
X
X# define TRUE  1
X# define FALSE 0
X
Xprocess traffic ( run, 
X	Cars, TimeoutL, TimeoutS, HiWayL, FarmL, StartTimer)
X	in port run;
X	in port Cars, TimeoutL, TimeoutS;
X	out port HiWayL[3], FarmL[3], StartTimer;
X{
X	boolean state[3];
X	boolean newstate[3], newHL[3], newFL[3], newST;
X	tag tags[2];
X	boolean a;
X
X
X	tags[0]: repeat {
X
X		boolean a;
X		
X		/* direct connections */
X		HiWayL = newHL;
X		FarmL = newFL;
X		StartTimer = newST; 
X
X		/* combinational logic to determine nextstate */
X
X		switch (state) {
X		case HIWAY_GREEN:
X			newHL = GREEN;
X			newFL = RED;
X
X			if (Cars & TimeoutL) {
X				newstate = HIWAY_YELLOW;
X				newST = TRUE;
X			} else {
X				newstate = HIWAY_GREEN;
X				newST = FALSE;
X			}
X			break;
X
X		case HIWAY_YELLOW:
X			newHL = YELLOW;
X			newFL = RED;
X
X			if ( TimeoutS ) {
X				newstate = FARM_GREEN;
X				newST = TRUE;
X			} else {
X				newstate = FARM_YELLOW;
X				newST = FALSE;
X			}
X			break;
X		case FARM_GREEN:
X			newHL = RED;
X			newFL = GREEN;
X
X			if ( ! Cars | TimeoutL ) {
X				newstate = FARM_YELLOW;
X				newST = TRUE;
X			} else {
X				newstate = FARM_GREEN;
X				newST = FALSE;
X			}
X			break;
X		case FARM_YELLOW:
X			newHL = RED;
X			newFL = YELLOW;
X			
X			if ( TimeoutS ) {
X				newstate = HIWAY_GREEN;
X				newST = TRUE;
X			} else {
X				newstate = FARM_YELLOW;
X				newST = FALSE;
X			}
X			break;			
X		};
X
X	/*
X		tags[1] : 
X		HiWayL = newHL;
X		FarmL = newFL;
X		StartTimer = newST; 
X	*/
X		state = newstate;
X	} until (!run);
X}
X
END_OF_FILE
if test 1687 -ne `wc -c <'traffic/traffic.hc'`; then
    echo shar: \"'traffic/traffic.hc'\" unpacked with wrong size!
fi
chmod +x 'traffic/traffic.hc'
# end of 'traffic/traffic.hc'
fi
if test -f 'traffic/traffic.pat' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'traffic/traffic.pat'\"
else
echo shar: Extracting \"'traffic/traffic.pat'\" \(785 characters\)
sed "s/^X//" >'traffic/traffic.pat' <<'END_OF_FILE'
X# traffic.pat
X#
X# traffic input patterns file
X# R. Gupta 7/23/90
X#
X.inputs EN RESET run[0:0] Cars[0:0] TimeoutL[0:0] TimeoutS[0:0] ;
X#
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 1 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 1 0 0 0 ;
X10 1 1 1 0 ;
X10 1 0 0 1 ;
X10 1 1 0 1 ;
X10 1 0 0 0 ;
X10 1 0 0 1 ;
X10 1 1 1 0 ;
X10 1 0 0 0 ;
X10 1 0 1 0 ;
X10 1 0 1 1 ;
X10 1 1 0 0 ;
X10 1 1 0 1 ;
X10 1 1 1 0 ;
X10 1 1 1 1 ;
X10 1 1 0 0 ;
X10 1 1 0 0 ;
X10 1 1 0 0 ;
X10 1 1 1 0 ;
X10 1 1 0 1 ;
X10 1 1 0 0 ;
X10 1 1 0 0 ;
X10 1 1 0 1 ;
X10 1 1 1 0 ;
X10 1 1 1 1 ;
X10 1 1 0 0 ;
X10 1 1 0 0 ;
X10 1 1 0 0 ;
X10 1 1 0 0 ;
X10 1 1 0 0 ;
X10 1 0 0 0 ;
X10 1 0 0 0 ;
X10 1 0 0 0 ;
X10 1 0 0 0 ;
X10 1 0 0 0 ;
X10 1 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
X10 0 0 0 0 ;
END_OF_FILE
if test 785 -ne `wc -c <'traffic/traffic.pat'`; then
    echo shar: \"'traffic/traffic.pat'\" unpacked with wrong size!
fi
# end of 'traffic/traffic.pat'
fi
if test -f 'traffic/traffic.mon' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'traffic/traffic.mon'\"
else
echo shar: Extracting \"'traffic/traffic.mon'\" \(196 characters\)
sed "s/^X//" >'traffic/traffic.mon' <<'END_OF_FILE'
Xrun[0:0]
XCars[0:0]
XTimeoutL[0:0]
XTimeoutS[0:0]
XStartTimer[0:0] 
XOCT HiWay HiWayL[0:0] HiWayL[1:1] HiWayL[2:2]
XOCT FarmL FarmL[0:0] FarmL[1:1] FarmL[2:2]
XOCT state state[0:0] state[1:1] state[2:2]
END_OF_FILE
if test 196 -ne `wc -c <'traffic/traffic.mon'`; then
    echo shar: \"'traffic/traffic.mon'\" unpacked with wrong size!
fi
# end of 'traffic/traffic.mon'
fi
if test -f 'traffic/traffic.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'traffic/traffic.sif'\"
else
echo shar: Extracting \"'traffic/traffic.sif'\" \(5057 characters\)
sed "s/^X//" >'traffic/traffic.sif' <<'END_OF_FILE'
X#
X#	Sif model traffic	Printed Tue Jul 24 15:06:06 1990
X#
X.model traffic sequencing process; 
X  .inputs port run port Cars port TimeoutL port TimeoutS 
X	;
X  .outputs port HiWayL[3] port FarmL[3] port StartTimer ;
X    #	Index 1
X    .polargraph 1 4;
X    .variable M1[3] X5 X4 X3 
X	X2 X1 T9 ;
X    .variable register newST register newFL[3] register newHL[3] register state[3] 
X	;
X    .variable tag tags[2] ;
X    #	4 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs 0b0 0b0 0b0 0b0 
X	0b0 0b0 0b0 0b0 
X	0b0 0b0 ;
X      .outputs newST[0:0] newFL[2:2] newFL[1:1] newFL[0:0] 
X	newHL[2:2] newHL[1:1] newHL[0:0] state[2:2] 
X	state[1:1] state[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .attribute constraint delay 2 1 cycles;
X      .attribute tag tags[0:0] ;
X      .operation load_register;
X    .endnode;
X
X    .node 3 loop;
X      .successors 4 ;	#  predecessors 2 
X      .loop T9[0:0] ;	#	
X        #	Index 2
X        .polargraph 1 3;
X        #	3 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 operation;
X          .inputs state[0:0] state[1:1] state[2:2] Cars[0:0] 
X	TimeoutL[0:0] TimeoutS[0:0] run[0:0] ;
X          .outputs M1[0:0] M1[1:1] M1[2:2] X1[0:0] 
X	X2[0:0] X3[0:0] X4[0:0] X5[0:0] 
X	T9[0:0] ;
X          .successors 3 ;	#  predecessors 1 
X          .operation logic 1 ;
X            #	Expression 0
X            T1[0:0] = state[0:0] ;
X            T1[1:1] = state[1:1] ;
X            T1[2:2] = state[2:2] ;
X            T6[0:0] = (Cars[0:0]  TimeoutL[0:0] );
X            T2[0:0] = T6[0:0] ;
X            T3[0:0] = TimeoutS[0:0] ;
X            T7[0:0] = Cars[0:0]' ;
X            T8[0:0] = (T7[0:0] +TimeoutL[0:0] );
X            T4[0:0] = T8[0:0] ;
X            T5[0:0] = TimeoutS[0:0] ;
X            M1[0:0] = X7[0:0] ;
X            M1[1:1] = X6[0:0] ;
X            M1[2:2] =  0 ;
X            X1[0:0] = ((((((( 0 + 0 )+ 0 )+ 0 )+(V000_T1_0_2[0:0]  X8[0:0] ))+(V100_T1_0_2[0:0]  X9[0:0] ))+(V010_T1_0_2[0:0]  X11[0:0] ))+(V110_T1_0_2[0:0]  X12[0:0] ));
X            X2[0:0] = ((((((( 0 + 0 )+ 0 )+ 0 )+V000_T1_0_2[0:0] )+V100_T1_0_2[0:0] )+ 0 )+V110_T1_0_2[0:0] );
X            X3[0:0] = ((((((( 0 + 0 )+ 0 )+ 0 )+V000_T1_0_2[0:0] )+V100_T1_0_2[0:0] )+V010_T1_0_2[0:0] )+ 0 );
X            X4[0:0] = ((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+V100_T1_0_2[0:0] )+V010_T1_0_2[0:0] )+V110_T1_0_2[0:0] );
X            X5[0:0] = ((((((( 0 + 0 )+ 0 )+ 0 )+V000_T1_0_2[0:0] )+ 0 )+V010_T1_0_2[0:0] )+V110_T1_0_2[0:0] );
X            X6[0:0] = ((((((( 0 + 0 )+ 0 )+ 0 )+ 0 )+V100_T1_0_2[0:0] )+V010_T1_0_2[0:0] )+(V110_T1_0_2[0:0]  X13[0:0] ));
X            X7[0:0] = ((((((( 0 + 0 )+ 0 )+ 0 )+(V000_T1_0_2[0:0]  X8[0:0] ))+(V100_T1_0_2[0:0]  X10[0:0] ))+(V010_T1_0_2[0:0]  X11[0:0] ))+(V110_T1_0_2[0:0]  X13[0:0] ));
X            X8[0:0] = (V1_T2_0_0[0:0] + 0 );
X            X9[0:0] = (V1_T3_0_0[0:0] + 0 );
X            X10[0:0] = ( 0 +V0_T3_0_0[0:0] );
X            X11[0:0] = (V1_T4_0_0[0:0] + 0 );
X            X12[0:0] = (V1_T5_0_0[0:0] + 0 );
X            X13[0:0] = ( 0 +V0_T5_0_0[0:0] );
X            T9[0:0] = run[0:0]' ;
X            V0_T5_0_0[0:0] = T5[0:0]' ;
X            V1_T5_0_0[0:0] = T5[0:0] ;
X            V1_T4_0_0[0:0] = T4[0:0] ;
X            V0_T3_0_0[0:0] = T3[0:0]' ;
X            V1_T3_0_0[0:0] = T3[0:0] ;
X            V1_T2_0_0[0:0] = T2[0:0] ;
X            V110_T1_0_2[0:0] = ((T1[0:0]  T1[1:1] ) T1[2:2]' );
X            V010_T1_0_2[0:0] = ((T1[0:0]'  T1[1:1] ) T1[2:2]' );
X            V100_T1_0_2[0:0] = ((T1[0:0]  T1[1:1]' ) T1[2:2]' );
X            V000_T1_0_2[0:0] = ((T1[0:0]'  T1[1:1]' ) T1[2:2]' );
X            .attribute delay 7 level;
X            .attribute area 185 literal;
X          .endoperation;
X        .endnode;
X
X        .node 3 nop;	#	sink node
X          .successors ;	#  predecessors 2 
X        .endnode;
X
X        .endpolargraph;
X      .attribute hercules loop_load newST[0:0] X1[0:0] ;
X      .attribute hercules loop_load newFL[2:2] 0b0 ;
X      .attribute hercules loop_load newFL[1:1] X2[0:0] ;
X      .attribute hercules loop_load newFL[0:0] X3[0:0] ;
X      .attribute hercules loop_load newHL[2:2] 0b0 ;
X      .attribute hercules loop_load newHL[1:1] X4[0:0] ;
X      .attribute hercules loop_load newHL[0:0] X5[0:0] ;
X      .attribute hercules loop_load state[2:2] M1[2:2] ;
X      .attribute hercules loop_load state[1:1] M1[1:1] ;
X      .attribute hercules loop_load state[0:0] M1[0:0] ;
X      .endloop;
X    .endnode;
X
X    .node 4 nop;	#	sink node
X      .successors ;	#  predecessors 3 
X    .endnode;
X
X    .attribute constraint delay 2 1 cycles;
X    .attribute hercules direct_connect HiWayL[0:0] newHL[0:0] ;
X    .attribute hercules direct_connect HiWayL[1:1] newHL[1:1] ;
X    .attribute hercules direct_connect HiWayL[2:2] newHL[2:2] ;
X    .attribute hercules direct_connect FarmL[0:0] newFL[0:0] ;
X    .attribute hercules direct_connect FarmL[1:1] newFL[1:1] ;
X    .attribute hercules direct_connect FarmL[2:2] newFL[2:2] ;
X    .attribute hercules direct_connect StartTimer[0:0] newST[0:0] ;
X    .endpolargraph;
X.endmodel traffic ;
END_OF_FILE
if test 5057 -ne `wc -c <'traffic/traffic.sif'`; then
    echo shar: \"'traffic/traffic.sif'\" unpacked with wrong size!
fi
# end of 'traffic/traffic.sif'
fi
if test -f 'traffic/traffic.out.gold' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'traffic/traffic.out.gold'\"
else
echo shar: Extracting \"'traffic/traffic.out.gold'\" \(1072 characters\)
sed "s/^X//" >'traffic/traffic.out.gold' <<'END_OF_FILE'
X14 ariadne extract
Xrun[0:0]
XCars[0:0]
XTimeoutL[0:0]
XTimeoutS[0:0]
XStartTimer[0:0]
XOCT HiWay HiWayL[0:0] HiWayL[1:1] HiWayL[2:2]
XOCT FarmL FarmL[0:0] FarmL[1:1] FarmL[2:2]
XOCT state state[0:0] state[1:1] state[2:2]
X     0:00000000000000
X     1:00000100110000
X     2:00000000000000
X     3:01000100110000
X     4:00000000000000
X     5:00000100110000
X     6:00000000000000
X     7:00000100110000
X     8:10000000000000
X     9:11101100110100
X    10:10011010110010
X    11:11010110100010
X    12:10001110100110
X    13:10011110010000
X    14:11101100110100
X    15:10000010110110
X    16:10100110010110
X    17:10111110010000
X    18:11000100110000
X    19:11010100110000
X    20:11101100110100
X    21:11111010110010
X    22:11000110100010
X    25:11101110100110
X    26:11011110010000
X    27:11000100110000
X    29:11010100110000
X    30:11101100110100
X    31:11111010110010
X    32:11000110100010
X    37:10001110100110
X    38:10000110010110
X    43:00000000000000
X    44:00000100110000
X    45:00000000000000
X    46:00000100110000
X    47:00000000000000
X    48:00000100110000
X    49:00000000000000
END_OF_FILE
if test 1072 -ne `wc -c <'traffic/traffic.out.gold'`; then
    echo shar: \"'traffic/traffic.out.gold'\" unpacked with wrong size!
fi
# end of 'traffic/traffic.out.gold'
fi
echo shar: End of shell archive.
exit 0


