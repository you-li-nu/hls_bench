
#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of shell archive."
# Contents:  parker1986/parker1986.hc parker1986/parker1986.pat
#   parker1986/parker1986.mon parker1986/add_8.sif
#   parker1986/parker1986.sif parker1986/subtract_8.sif
#   parker1986/parker1986.out.gold
# Wrapped by synthesis@sirius on Thu Jul 26 17:17:25 1990
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'parker1986/parker1986.hc' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'parker1986/parker1986.hc'\"
else
echo shar: Extracting \"'parker1986/parker1986.hc'\" \(777 characters\)
sed "s/^X//" >'parker1986/parker1986.hc' <<'END_OF_FILE'
X/*
XDESCRIPTION:
X
X	This example is taken from  a paper by Alice Parker in ?? 1986.
X
X*/
X
X#include "../templates/library.hc"
X#define SIZE 8
X
Xprocess parker1986(in1,in2,in3,in4,in5,in6,out1)
X	in port in1[SIZE], in2[SIZE], in3[SIZE], in4[SIZE], in5[SIZE], in6[SIZE];
X	out port out1[SIZE];
X[
X	boolean t1[SIZE], t2[SIZE], t3[SIZE], t4[SIZE], t5[SIZE], t6[SIZE], t7[SIZE];
X
X	t1 = in5 - in6;
X	t2 = in2+in3;
X	if (in5 != 0) [
X		if (t2 != 0) [
X			t3 = in1 - 4;
X			if (t3 != 0) t4 = in2+4;
X			else t4 = in3 - in5;
X		] else [
X			t3 = in4 - 5;
X			t5 = t3+5;
X			if (t5 != 0) t6 = in1+in2;
X			else [
X				t7 = in1 - in2;
X				t6 = t7 - in1;
X			]
X			t4 = t6 - in4;
X		]
X		t6 = t4+in4;
X	] else [
X		if (t1 != 0) t6 = in2+5;
X		else t6 = 8 - in4;
X	]
X	if (t6 != 0) out1 = in1 - 5;
X	else out1 = 8+in5;
X]
END_OF_FILE
if test 777 -ne `wc -c <'parker1986/parker1986.hc'`; then
    echo shar: \"'parker1986/parker1986.hc'\" unpacked with wrong size!
fi
# end of 'parker1986/parker1986.hc'
fi
if test -f 'parker1986/parker1986.pat' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'parker1986/parker1986.pat'\"
else
echo shar: Extracting \"'parker1986/parker1986.pat'\" \(3539 characters\)
sed "s/^X//" >'parker1986/parker1986.pat' <<'END_OF_FILE'
X# parker1986 input pattern file
X#
X# simulation outputs verified; traces saved in parker1986.trace.gold
X#
X# R Gupta 7/17/90
X#
X#
X.inputs in1[7:7] in1[6:6] in1[5:5] in1[4:4] in1[3:3] in1[2:2] in1[1:1] in1[0:0] in2[7:7] in2[6:6] in2[5:5] in2[4:4] in2[3:3] in2[2:2] in2[1:1] in2[0:0] in3[7:7] in3[6:6] in3[5:5] in3[4:4] in3[3:3] in3[2:2] in3[1:1] in3[0:0] in4[7:7] in4[6:6] in4[5:5] in4[4:4] in4[3:3] in4[2:2] in4[1:1] in4[0:0] in5[7:7] in5[6:6] in5[5:5] in5[4:4] in5[3:3] in5[2:2] in5[1:1] in5[0:0] in6[7:7] in6[6:6] in6[5:5] in6[4:4] in6[3:3] in6[2:2] in6[1:1] in6[0:0] ; 
X#
X# all zeros; => t6 = 8, out1 = -5 ( BF ); 
X0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 ;
X#
X# in1=6; t6 = 8; out1 = 1 ; 
X0000 0110 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 ;
X#
X# (7, 0, 0, 6, 1, 0) t1=1; t2=0; t3=1; t4=1; t5=6 t6=7; t7=0 out1=2
X0000 0111 0000 0000 0000 0000 0000 0110 0000 0001 0000 0000 ;
X#
X# (in1, in2, ..., in6) => (t1, t2, ..., t7)
X# ( 24 63 64 67 74 92 ) = > ( -18 127 20 67 0 134 0 ); out1 = 19
X# ( 18 3F 40 43 4A 5C ) = > 13
X0001 1000 0011 1111 0100 0000 0100 0011 0100 1010 0101 1100 ;
X#
X# ( 97 1  53 39 52 37 ) => ( 15 54 93 5 0 44 0 ); out1 = 92
X# ( 61 01 35 27 34 25 ) => 5C
X0110 0001 0000 0001 0011 0101 0010 0111 0011 0100 0010 0101 ;
X#
X# ( 56 47 72 87 76 49 ) => ( 27 119 52 51 0 138 0 ); out1 = 51
X# ( 38 2F 48 57 4C 31 ) => 33
X0011 1000 0010 1111 0100 1000 0101 0111 0100 1100 0011 0001 ;
X#
X# ( 81 61 59 54 42 60 ) => ( -18 120 77 65 0 119 0 ); out1 = 76
X# ( 51 33 3B 36 2A 32 ) => 4C 
X0101 0001 0011 0011 0011 1011 0011 0110 0010 1010 0011 0010  ;
X#
X# ( 89 81 61 59 54 42 ) => ( 12 142 85 85 0 144 0 ); out1 = 84
X# ( 59 51 3d 3b 36 2a ) => out1 = 54
X0101 1001 0101 0001 0011 1101 0011 1011 0011 0110 0010 1010 ;
X#
X# ( 51 3d 3b 36 2a 3c ) => ( EE 87 d4 14 0 77 0 ); out1 = c4  
X0101 0001 0011 1101 0011 1011 0011 0110 0010 1010 0011 1100 ;
X#
X# ( 73 89 81 61 59 54 ) => ( 5 170 69 93 0 154 0 ); out1 = 68
X# ( 49 59 51 3d 3b 36 ) => ( 05 aa 45 5d 0 9a 0 ); out1 = 44
X0100 1001 0101 1001 0101 0001 0011 1101 0011 1011 0011 0110 ;
X#
X# ( 13 35 42 60 57 49 ) => ( 8 77 9 39 0 99 0 ); out1 = 8
X# ( 0d 23 2a 3c 39 31 ) => ( 8 4d 9 27 0 63 0 ); out1 = 8
X0000 1101 0010 0011 0010 1010  0011 1100 0011 1001 0011 0001 ;
X#
X# ( 1 53 39 52 37 47 ) => ( -10 92 -3 57 0 109 0 ); out1 = -4
X# ( 1 35 27 34 25 2f ) => ( f6 5c fd 39 0 6d 0 ); out1 = fc
X0000 0001 0011 0101 0010 0111 0011 0100 0010 0101 0010 1111 ;
X#
X# ( 59 54 42 60 57 49 ) => ( 8 96 55 58 0 118 0 ); out1 = 54
X# ( 3b 36 2a 3c 39 31 ) => ( 8 60 37 3a 0 76 0 ); out1 = 36
X0011 1011 0011 0110 0010 1010 0011 1100 0011 1001 0011 0001 ;
X#
X# ( 87 76 49 77 51 34 ) => ( 17 125 83 80 0 157 0 ); out1 = 82
X# ( 57 4c 31 4d 33 22 ) => ( 11 7d 53 50 0 9d 0 ); out1 = 52
X0101 0111 0100 1100 0011 0001 0100 1101 0011 0011 0010 0010 ;
X#
X# ( 47 72 87 76 49 77 ) => ( -28 159 43 76 0 152 0 ); out1 = 42
X# ( 2f 48 57 4c 31 4d ) => ( e4 9f 2b 4c 0 98 0 ); out1 = 2a
X0010 1111 0100 1000 0101 0111 0100 1100 0011 0001 0100 1101 ;
X#
X# ( 5 15 40 55 44 65 ) => ( -21 55 1 19 0 74 0 ); out1 = 0
X# ( 5 0f 28 37 2c 41 ) => ( eb 37 1 13 0 4a 0 ); out1 = 0
X0000 0101 0000 1111 0010 1000 0011 0111 0010 1100 0100 0001 ;
X#
X# ( 72 87 76 49 77 51 ) => ( 26 163 68 91 0 140 0 ); out1 = 67
X# ( 48 57 4c 31 4d 33 ) => ( 1a a3 44 5b 0 8c 0 ); out1 = 43
X0100 1000 0101 0111 0100 1100 0011 0001 0100 1101 0011 0011 ;
X#
X# ( 18 48 75 46 70 82 ) => ( -12 123 14 52 0 98 0 ); out1 = 13
X# ( 12 30 4b 2e 46 52 ) => ( f4 7b e 34 0 62 0 ); out1 = d
X0001 0010 0011 0000 0100 1011 0010 1110 0100 0110 0101 0010 ;
END_OF_FILE
if test 3539 -ne `wc -c <'parker1986/parker1986.pat'`; then
    echo shar: \"'parker1986/parker1986.pat'\" unpacked with wrong size!
fi
# end of 'parker1986/parker1986.pat'
fi
if test -f 'parker1986/parker1986.mon' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'parker1986/parker1986.mon'\"
else
echo shar: Extracting \"'parker1986/parker1986.mon'\" \(512 characters\)
sed "s/^X//" >'parker1986/parker1986.mon' <<'END_OF_FILE'
Xin1[0:0]
Xin1[1:1]
Xin1[2:2]
Xin1[3:3]
Xin1[4:4]
Xin1[5:5]
Xin1[6:6]
Xin1[7:7]
Xin2[0:0]
Xin2[1:1]
Xin2[2:2]
Xin2[3:3]
Xin2[4:4]
Xin2[5:5]
Xin2[6:6]
Xin2[7:7]
Xin3[0:0]
Xin3[1:1]
Xin3[2:2]
Xin3[3:3]
Xin3[4:4]
Xin3[5:5]
Xin3[6:6]
Xin3[7:7]
Xin4[0:0]
Xin4[1:1]
Xin4[2:2]
Xin4[3:3]
Xin4[4:4]
Xin4[5:5]
Xin4[6:6]
Xin4[7:7]
Xin5[0:0]
Xin5[1:1]
Xin5[2:2]
Xin5[3:3]
Xin5[4:4]
Xin5[5:5]
Xin5[6:6]
Xin5[7:7]
Xin6[0:0]
Xin6[1:1]
Xin6[2:2]
Xin6[3:3]
Xin6[4:4]
Xin6[5:5]
Xin6[6:6]
Xin6[7:7]
Xout1[0:0]
Xout1[1:1]
Xout1[2:2]
Xout1[3:3]
Xout1[4:4]
Xout1[5:5]
Xout1[6:6]
Xout1[7:7]
END_OF_FILE
if test 512 -ne `wc -c <'parker1986/parker1986.mon'`; then
    echo shar: \"'parker1986/parker1986.mon'\" unpacked with wrong size!
fi
# end of 'parker1986/parker1986.mon'
fi
if test -f 'parker1986/add_8.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'parker1986/add_8.sif'\"
else
echo shar: Extracting \"'parker1986/add_8.sif'\" \(3745 characters\)
sed "s/^X//" >'parker1986/add_8.sif' <<'END_OF_FILE'
X#
X#	Sif model add_8	Printed Tue Jul 24 15:07:01 1990
X#
X.model add_8 sequencing ; 
X  .inputs op1[8] op2[8] ;
X  .outputs return_value[9] ;
X    #	Index 1
X    .polargraph 1 3;
X    .variable T44 T40 T34 T28 
X	T22 T16 T10 T4 
X	T1 ;
X    #	3 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs op1[0:0] op2[0:0] op1[1:1] op2[1:1] 
X	op1[2:2] op2[2:2] op1[3:3] op2[3:3] 
X	op1[4:4] op2[4:4] op1[5:5] op2[5:5] 
X	op1[6:6] op2[6:6] op1[7:7] op2[7:7] 
X	;
X      .outputs T1[0:0] T4[0:0] T10[0:0] T16[0:0] 
X	T22[0:0] T28[0:0] T34[0:0] T40[0:0] 
X	T44[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        T1[0:0] = ((op1[0:0]  op2[0:0]' )+(op1[0:0]'  op2[0:0] ));
X        T2[0:0] = (op1[0:0]  op2[0:0] );
X        T3[0:0] = ((op1[1:1]  op2[1:1]' )+(op1[1:1]'  op2[1:1] ));
X        T4[0:0] = ((T3[0:0]  T2[0:0]' )+(T3[0:0]'  T2[0:0] ));
X        T5[0:0] = (op1[1:1]  op2[1:1] );
X        T6[0:0] = (op1[1:1] +op2[1:1] );
X        T7[0:0] = (T2[0:0]  T6[0:0] );
X        T8[0:0] = (T5[0:0] +T7[0:0] );
X        T9[0:0] = ((op1[2:2]  op2[2:2]' )+(op1[2:2]'  op2[2:2] ));
X        T10[0:0] = ((T9[0:0]  T8[0:0]' )+(T9[0:0]'  T8[0:0] ));
X        T11[0:0] = (op1[2:2]  op2[2:2] );
X        T12[0:0] = (op1[2:2] +op2[2:2] );
X        T13[0:0] = (T8[0:0]  T12[0:0] );
X        T14[0:0] = (T11[0:0] +T13[0:0] );
X        T15[0:0] = ((op1[3:3]  op2[3:3]' )+(op1[3:3]'  op2[3:3] ));
X        T16[0:0] = ((T15[0:0]  T14[0:0]' )+(T15[0:0]'  T14[0:0] ));
X        T17[0:0] = (op1[3:3]  op2[3:3] );
X        T18[0:0] = (op1[3:3] +op2[3:3] );
X        T19[0:0] = (T14[0:0]  T18[0:0] );
X        T20[0:0] = (T17[0:0] +T19[0:0] );
X        T21[0:0] = ((op1[4:4]  op2[4:4]' )+(op1[4:4]'  op2[4:4] ));
X        T22[0:0] = ((T21[0:0]  T20[0:0]' )+(T21[0:0]'  T20[0:0] ));
X        T23[0:0] = (op1[4:4]  op2[4:4] );
X        T24[0:0] = (op1[4:4] +op2[4:4] );
X        T25[0:0] = (T20[0:0]  T24[0:0] );
X        T26[0:0] = (T23[0:0] +T25[0:0] );
X        T27[0:0] = ((op1[5:5]  op2[5:5]' )+(op1[5:5]'  op2[5:5] ));
X        T28[0:0] = ((T27[0:0]  T26[0:0]' )+(T27[0:0]'  T26[0:0] ));
X        T29[0:0] = (op1[5:5]  op2[5:5] );
X        T30[0:0] = (op1[5:5] +op2[5:5] );
X        T31[0:0] = (T26[0:0]  T30[0:0] );
X        T32[0:0] = (T29[0:0] +T31[0:0] );
X        T33[0:0] = ((op1[6:6]  op2[6:6]' )+(op1[6:6]'  op2[6:6] ));
X        T34[0:0] = ((T33[0:0]  T32[0:0]' )+(T33[0:0]'  T32[0:0] ));
X        T35[0:0] = (op1[6:6]  op2[6:6] );
X        T36[0:0] = (op1[6:6] +op2[6:6] );
X        T37[0:0] = (T32[0:0]  T36[0:0] );
X        T38[0:0] = (T35[0:0] +T37[0:0] );
X        T39[0:0] = ((op1[7:7]  op2[7:7]' )+(op1[7:7]'  op2[7:7] ));
X        T40[0:0] = ((T39[0:0]  T38[0:0]' )+(T39[0:0]'  T38[0:0] ));
X        T41[0:0] = (op1[7:7]  op2[7:7] );
X        T42[0:0] = (op1[7:7] +op2[7:7] );
X        T43[0:0] = (T38[0:0]  T42[0:0] );
X        T44[0:0] = (T41[0:0] +T43[0:0] );
X        .attribute delay 15 level;
X        .attribute area 192 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 nop;	#	sink node
X      .successors ;	#  predecessors 2 
X    .endnode;
X
X    .attribute hercules direct_connect return_value[0:0] T1[0:0] ;
X    .attribute hercules direct_connect return_value[1:1] T4[0:0] ;
X    .attribute hercules direct_connect return_value[2:2] T10[0:0] ;
X    .attribute hercules direct_connect return_value[3:3] T16[0:0] ;
X    .attribute hercules direct_connect return_value[4:4] T22[0:0] ;
X    .attribute hercules direct_connect return_value[5:5] T28[0:0] ;
X    .attribute hercules direct_connect return_value[6:6] T34[0:0] ;
X    .attribute hercules direct_connect return_value[7:7] T40[0:0] ;
X    .attribute hercules direct_connect return_value[8:8] T44[0:0] ;
X    .endpolargraph;
X.endmodel add_8 ;
END_OF_FILE
if test 3745 -ne `wc -c <'parker1986/add_8.sif'`; then
    echo shar: \"'parker1986/add_8.sif'\" unpacked with wrong size!
fi
# end of 'parker1986/add_8.sif'
fi
if test -f 'parker1986/parker1986.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'parker1986/parker1986.sif'\"
else
echo shar: Extracting \"'parker1986/parker1986.sif'\" \(19826 characters\)
sed "s/^X//" >'parker1986/parker1986.sif' <<'END_OF_FILE'
X#
X#	Sif model parker1986	Printed Tue Jul 24 15:06:55 1990
X#
X.model parker1986 sequencing process; 
X  .inputs port in1[8] port in2[8] port in3[8] port in4[8] 
X	port in5[8] port in6[8] ;
X  .outputs port out1[8] ;
X    #	Index 1
X    .polargraph 1 9;
X    .variable X41 X42 X43 X44 
X	X45 X46 X47 X48 
X	T28[9] T27[9] T26 T25 
X	T24[9] T23[9] T20[9] T22 
X	T21 T1[9] M2[8] T11[9] 
X	T10[9] T19[9] M1[8] T18[9] 
X	T16[9] T17[9] T15 T14 
X	T13[9] T12[9] T9 T8 
X	T7[9] T6 T5 T2[9] 
X	T4 T3 ;
X    #	9 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 proc;
X      .inputs in5[0:7] in6[0:7] ;
X      .outputs T1[0:8] ;
X      .successors 3 ;	#  predecessors 1 
X      .proc subtract with (8);
X    .endnode;
X
X    .node 3 proc;
X      .inputs in2[0:7] in3[0:7] ;
X      .outputs T2[0:8] ;
X      .successors 4 ;	#  predecessors 2 
X      .proc add with (8);
X    .endnode;
X
X    .node 4 operation;
X      .inputs in5[0:0] in5[1:1] in5[2:2] in5[3:3] 
X	in5[4:4] in5[5:5] in5[6:6] in5[7:7] 
X	;
X      .outputs T3[0:0] ;
X      .successors 5 ;	#  predecessors 3 
X      .operation logic 1 ;
X        #	Expression 0
X        T3[0:0] = (V00000000_in5_0_7[0:0] )';
X        V00000000_in5_0_7[0:0] = (((((((in5[0:0]'  in5[1:1]' ) in5[2:2]' ) in5[3:3]' ) in5[4:4]' ) in5[5:5]' ) in5[6:6]' ) in5[7:7]' );
X        .attribute delay 8 level;
X        .attribute area 17 literal;
X      .endoperation;
X    .endnode;
X
X    .node 5 cond;
X      .successors 6 ;	#  predecessors 4 
X      .cond T3[0:0] T4[0:0] ;	#	Latched
X      .case 1 ;
X        #	Index 2
X        .polargraph 1 6;
X        #	6 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 operation;
X          .inputs T2[0:0] T2[1:1] T2[2:2] T2[3:3] 
X	T2[4:4] T2[5:5] T2[6:6] T2[7:7] 
X	;
X          .outputs T5[0:0] ;
X          .successors 3 ;	#  predecessors 1 
X          .operation logic 2 ;
X            #	Expression 0
X            T5[0:0] = (V00000000_T2_0_7[0:0] )';
X            V00000000_T2_0_7[0:0] = (((((((T2[0:0]'  T2[1:1]' ) T2[2:2]' ) T2[3:3]' ) T2[4:4]' ) T2[5:5]' ) T2[6:6]' ) T2[7:7]' );
X            .attribute delay 8 level;
X            .attribute area 17 literal;
X          .endoperation;
X        .endnode;
X
X        .node 3 cond;
X          .successors 4 ;	#  predecessors 2 
X          .cond T5[0:0] T6[0:0] ;	#	Latched
X          .case 1 ;
X            #	Index 3
X            .polargraph 1 5;
X            #	5 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 proc;
X              .inputs in1[0:7] 0b00100000 ;
X              .outputs T7[0:8] ;
X              .successors 3 ;	#  predecessors 1 
X              .proc subtract with (8);
X            .endnode;
X
X            .node 3 operation;
X              .inputs T7[0:0] T7[1:1] T7[2:2] T7[3:3] 
X	T7[4:4] T7[5:5] T7[6:6] T7[7:7] 
X	;
X              .outputs T8[0:0] ;
X              .successors 4 ;	#  predecessors 2 
X              .operation logic 3 ;
X                #	Expression 0
X                T8[0:0] = (V00000000_T7_0_7[0:0] )';
X                V00000000_T7_0_7[0:0] = (((((((T7[0:0]'  T7[1:1]' ) T7[2:2]' ) T7[3:3]' ) T7[4:4]' ) T7[5:5]' ) T7[6:6]' ) T7[7:7]' );
X                .attribute delay 8 level;
X                .attribute area 17 literal;
X              .endoperation;
X            .endnode;
X
X            .node 4 cond;
X              .successors 5 ;	#  predecessors 3 
X              .cond T8[0:0] T9[0:0] ;	#	Latched
X              .case 1 ;
X                #	Index 4
X                .polargraph 1 3;
X                #	3 nodes
X                .node 1 nop;	#	source node
X                  .successors 2 ;
X                .endnode;
X
X                .node 2 proc;
X                  .inputs in2[0:7] 0b00100000 ;
X                  .outputs T10[0:8] ;
X                  .successors 3 ;	#  predecessors 1 
X                  .proc add with (8);
X                .endnode;
X
X                .node 3 nop;	#	sink node
X                  .successors ;	#  predecessors 2 
X                .endnode;
X
X                .endpolargraph;
X              .endcase;
X              .case 0 ;
X                #	Index 5
X                .polargraph 1 3;
X                #	3 nodes
X                .node 1 nop;	#	source node
X                  .successors 2 ;
X                .endnode;
X
X                .node 2 proc;
X                  .inputs in3[0:7] in5[0:7] ;
X                  .outputs T11[0:8] ;
X                  .successors 3 ;	#  predecessors 1 
X                  .proc subtract with (8);
X                .endnode;
X
X                .node 3 nop;	#	sink node
X                  .successors ;	#  predecessors 2 
X                .endnode;
X
X                .endpolargraph;
X              .endcase;
X              .endcond;
X            .endnode;
X
X            .node 5 nop;	#	sink node
X              .successors ;	#  predecessors 4 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .case 0 ;
X            #	Index 6
X            .polargraph 1 8;
X            #	8 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 proc;
X              .inputs in4[0:7] 0b10100000 ;
X              .outputs T12[0:8] ;
X              .successors 3 ;	#  predecessors 1 
X              .proc subtract with (8);
X            .endnode;
X
X            .node 3 proc;
X              .inputs T12[0:7] 0b10100000 ;
X              .outputs T13[0:8] ;
X              .successors 4 ;	#  predecessors 2 
X              .proc add with (8);
X            .endnode;
X
X            .node 4 operation;
X              .inputs T13[0:0] T13[1:1] T13[2:2] T13[3:3] 
X	T13[4:4] T13[5:5] T13[6:6] T13[7:7] 
X	;
X              .outputs T14[0:0] ;
X              .successors 5 ;	#  predecessors 3 
X              .operation logic 4 ;
X                #	Expression 0
X                T14[0:0] = (V00000000_T13_0_7[0:0] )';
X                V00000000_T13_0_7[0:0] = (((((((T13[0:0]'  T13[1:1]' ) T13[2:2]' ) T13[3:3]' ) T13[4:4]' ) T13[5:5]' ) T13[6:6]' ) T13[7:7]' );
X                .attribute delay 8 level;
X                .attribute area 17 literal;
X              .endoperation;
X            .endnode;
X
X            .node 5 cond;
X              .successors 6 ;	#  predecessors 4 
X              .cond T14[0:0] T15[0:0] ;	#	Latched
X              .case 1 ;
X                #	Index 7
X                .polargraph 1 3;
X                #	3 nodes
X                .node 1 nop;	#	source node
X                  .successors 2 ;
X                .endnode;
X
X                .node 2 proc;
X                  .inputs in1[0:7] in2[0:7] ;
X                  .outputs T16[0:8] ;
X                  .successors 3 ;	#  predecessors 1 
X                  .proc add with (8);
X                .endnode;
X
X                .node 3 nop;	#	sink node
X                  .successors ;	#  predecessors 2 
X                .endnode;
X
X                .endpolargraph;
X              .endcase;
X              .case 0 ;
X                #	Index 8
X                .polargraph 1 4;
X                #	4 nodes
X                .node 1 nop;	#	source node
X                  .successors 2 ;
X                .endnode;
X
X                .node 2 proc;
X                  .inputs in1[0:7] in2[0:7] ;
X                  .outputs T17[0:8] ;
X                  .successors 3 ;	#  predecessors 1 
X                  .proc subtract with (8);
X                .endnode;
X
X                .node 3 proc;
X                  .inputs T17[0:7] in1[0:7] ;
X                  .outputs T18[0:8] ;
X                  .successors 4 ;	#  predecessors 2 
X                  .proc subtract with (8);
X                .endnode;
X
X                .node 4 nop;	#	sink node
X                  .successors ;	#  predecessors 3 
X                .endnode;
X
X                .endpolargraph;
X              .endcase;
X              .endcond;
X            .endnode;
X
X            .node 6 operation;
X              .inputs T15[0:0] T16[7:7] T18[7:7] T16[6:6] 
X	T18[6:6] T16[5:5] T18[5:5] T16[4:4] 
X	T18[4:4] T16[3:3] T18[3:3] T16[2:2] 
X	T18[2:2] T16[1:1] T18[1:1] T16[0:0] 
X	T18[0:0] ;
X              .outputs M1[0:0] M1[1:1] M1[2:2] M1[3:3] 
X	M1[4:4] M1[5:5] M1[6:6] M1[7:7] 
X	;
X              .successors 7 ;	#  predecessors 5 
X              .operation logic 5 ;
X                #	Expression 0
X                M1[0:0] = X8[0:0] ;
X                M1[1:1] = X7[0:0] ;
X                M1[2:2] = X6[0:0] ;
X                M1[3:3] = X5[0:0] ;
X                M1[4:4] = X4[0:0] ;
X                M1[5:5] = X3[0:0] ;
X                M1[6:6] = X2[0:0] ;
X                M1[7:7] = X1[0:0] ;
X                X1[0:0] = ((V1_T15_0_0[0:0]  T16[7:7] )+(V0_T15_0_0[0:0]  T18[7:7] ));
X                X2[0:0] = ((V1_T15_0_0[0:0]  T16[6:6] )+(V0_T15_0_0[0:0]  T18[6:6] ));
X                X3[0:0] = ((V1_T15_0_0[0:0]  T16[5:5] )+(V0_T15_0_0[0:0]  T18[5:5] ));
X                X4[0:0] = ((V1_T15_0_0[0:0]  T16[4:4] )+(V0_T15_0_0[0:0]  T18[4:4] ));
X                X5[0:0] = ((V1_T15_0_0[0:0]  T16[3:3] )+(V0_T15_0_0[0:0]  T18[3:3] ));
X                X6[0:0] = ((V1_T15_0_0[0:0]  T16[2:2] )+(V0_T15_0_0[0:0]  T18[2:2] ));
X                X7[0:0] = ((V1_T15_0_0[0:0]  T16[1:1] )+(V0_T15_0_0[0:0]  T18[1:1] ));
X                X8[0:0] = ((V1_T15_0_0[0:0]  T16[0:0] )+(V0_T15_0_0[0:0]  T18[0:0] ));
X                V0_T15_0_0[0:0] = T15[0:0]' ;
X                V1_T15_0_0[0:0] = T15[0:0] ;
X                .attribute delay 2 level;
X                .attribute area 66 literal;
X              .endoperation;
X            .endnode;
X
X            .node 7 proc;
X              .inputs M1[0:7] in4[0:7] ;
X              .outputs T19[0:8] ;
X              .successors 8 ;	#  predecessors 6 
X              .proc subtract with (8);
X            .endnode;
X
X            .node 8 nop;	#	sink node
X              .successors ;	#  predecessors 7 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .endcond;
X        .endnode;
X
X        .node 4 operation;
X          .inputs T6[0:0] T19[7:7] T19[6:6] T19[5:5] 
X	T19[4:4] T19[3:3] T19[2:2] T19[1:1] 
X	T19[0:0] T9[0:0] T10[7:7] T11[7:7] 
X	T10[6:6] T11[6:6] T10[5:5] T11[5:5] 
X	T10[4:4] T11[4:4] T10[3:3] T11[3:3] 
X	T10[2:2] T11[2:2] T10[1:1] T11[1:1] 
X	T10[0:0] T11[0:0] ;
X          .outputs M2[0:0] M2[1:1] M2[2:2] M2[3:3] 
X	M2[4:4] M2[5:5] M2[6:6] M2[7:7] 
X	;
X          .successors 5 ;	#  predecessors 3 
X          .operation logic 6 ;
X            #	Expression 0
X            M2[0:0] = X16[0:0] ;
X            M2[1:1] = X15[0:0] ;
X            M2[2:2] = X14[0:0] ;
X            M2[3:3] = X13[0:0] ;
X            M2[4:4] = X12[0:0] ;
X            M2[5:5] = X11[0:0] ;
X            M2[6:6] = X10[0:0] ;
X            M2[7:7] = X9[0:0] ;
X            X9[0:0] = ((V1_T6_0_0[0:0]  X17[0:0] )+(V0_T6_0_0[0:0]  T19[7:7] ));
X            X10[0:0] = ((V1_T6_0_0[0:0]  X18[0:0] )+(V0_T6_0_0[0:0]  T19[6:6] ));
X            X11[0:0] = ((V1_T6_0_0[0:0]  X19[0:0] )+(V0_T6_0_0[0:0]  T19[5:5] ));
X            X12[0:0] = ((V1_T6_0_0[0:0]  X20[0:0] )+(V0_T6_0_0[0:0]  T19[4:4] ));
X            X13[0:0] = ((V1_T6_0_0[0:0]  X21[0:0] )+(V0_T6_0_0[0:0]  T19[3:3] ));
X            X14[0:0] = ((V1_T6_0_0[0:0]  X22[0:0] )+(V0_T6_0_0[0:0]  T19[2:2] ));
X            X15[0:0] = ((V1_T6_0_0[0:0]  X23[0:0] )+(V0_T6_0_0[0:0]  T19[1:1] ));
X            X16[0:0] = ((V1_T6_0_0[0:0]  X24[0:0] )+(V0_T6_0_0[0:0]  T19[0:0] ));
X            X17[0:0] = ((V1_T9_0_0[0:0]  T10[7:7] )+(V0_T9_0_0[0:0]  T11[7:7] ));
X            X18[0:0] = ((V1_T9_0_0[0:0]  T10[6:6] )+(V0_T9_0_0[0:0]  T11[6:6] ));
X            X19[0:0] = ((V1_T9_0_0[0:0]  T10[5:5] )+(V0_T9_0_0[0:0]  T11[5:5] ));
X            X20[0:0] = ((V1_T9_0_0[0:0]  T10[4:4] )+(V0_T9_0_0[0:0]  T11[4:4] ));
X            X21[0:0] = ((V1_T9_0_0[0:0]  T10[3:3] )+(V0_T9_0_0[0:0]  T11[3:3] ));
X            X22[0:0] = ((V1_T9_0_0[0:0]  T10[2:2] )+(V0_T9_0_0[0:0]  T11[2:2] ));
X            X23[0:0] = ((V1_T9_0_0[0:0]  T10[1:1] )+(V0_T9_0_0[0:0]  T11[1:1] ));
X            X24[0:0] = ((V1_T9_0_0[0:0]  T10[0:0] )+(V0_T9_0_0[0:0]  T11[0:0] ));
X            V0_T9_0_0[0:0] = T9[0:0]' ;
X            V1_T9_0_0[0:0] = T9[0:0] ;
X            V0_T6_0_0[0:0] = T6[0:0]' ;
X            V1_T6_0_0[0:0] = T6[0:0] ;
X            .attribute delay 4 level;
X            .attribute area 124 literal;
X          .endoperation;
X        .endnode;
X
X        .node 5 proc;
X          .inputs M2[0:7] in4[0:7] ;
X          .outputs T20[0:8] ;
X          .successors 6 ;	#  predecessors 4 
X          .proc add with (8);
X        .endnode;
X
X        .node 6 nop;	#	sink node
X          .successors ;	#  predecessors 5 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .case 0 ;
X        #	Index 9
X        .polargraph 1 4;
X        #	4 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 operation;
X          .inputs T1[0:0] T1[1:1] T1[2:2] T1[3:3] 
X	T1[4:4] T1[5:5] T1[6:6] T1[7:7] 
X	;
X          .outputs T21[0:0] ;
X          .successors 3 ;	#  predecessors 1 
X          .operation logic 7 ;
X            #	Expression 0
X            T21[0:0] = (V00000000_T1_0_7[0:0] )';
X            V00000000_T1_0_7[0:0] = (((((((T1[0:0]'  T1[1:1]' ) T1[2:2]' ) T1[3:3]' ) T1[4:4]' ) T1[5:5]' ) T1[6:6]' ) T1[7:7]' );
X            .attribute delay 8 level;
X            .attribute area 17 literal;
X          .endoperation;
X        .endnode;
X
X        .node 3 cond;
X          .successors 4 ;	#  predecessors 2 
X          .cond T21[0:0] T22[0:0] ;	#	Latched
X          .case 1 ;
X            #	Index 10
X            .polargraph 1 3;
X            #	3 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 proc;
X              .inputs in2[0:7] 0b10100000 ;
X              .outputs T23[0:8] ;
X              .successors 3 ;	#  predecessors 1 
X              .proc add with (8);
X            .endnode;
X
X            .node 3 nop;	#	sink node
X              .successors ;	#  predecessors 2 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .case 0 ;
X            #	Index 11
X            .polargraph 1 3;
X            #	3 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 proc;
X              .inputs 0b00010000 in4[0:7] ;
X              .outputs T24[0:8] ;
X              .successors 3 ;	#  predecessors 1 
X              .proc subtract with (8);
X            .endnode;
X
X            .node 3 nop;	#	sink node
X              .successors ;	#  predecessors 2 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .endcond;
X        .endnode;
X
X        .node 4 nop;	#	sink node
X          .successors ;	#  predecessors 3 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .endcond;
X    .endnode;
X
X    .node 6 operation;
X      .inputs T4[0:0] T20[7:7] T20[6:6] T20[5:5] 
X	T20[4:4] T20[3:3] T20[2:2] T20[1:1] 
X	T20[0:0] T22[0:0] T23[7:7] T24[7:7] 
X	T23[6:6] T24[6:6] T23[5:5] T24[5:5] 
X	T23[4:4] T24[4:4] T23[3:3] T24[3:3] 
X	T23[2:2] T24[2:2] T23[1:1] T24[1:1] 
X	T23[0:0] T24[0:0] ;
X      .outputs T25[0:0] ;
X      .successors 7 ;	#  predecessors 5 
X      .operation logic 8 ;
X        #	Expression 0
X        M3[0:0] = X32[0:0] ;
X        M3[1:1] = X31[0:0] ;
X        M3[2:2] = X30[0:0] ;
X        M3[3:3] = X29[0:0] ;
X        M3[4:4] = X28[0:0] ;
X        M3[5:5] = X27[0:0] ;
X        M3[6:6] = X26[0:0] ;
X        M3[7:7] = X25[0:0] ;
X        X25[0:0] = ((V1_T4_0_0[0:0]  T20[7:7] )+(V0_T4_0_0[0:0]  X33[0:0] ));
X        X26[0:0] = ((V1_T4_0_0[0:0]  T20[6:6] )+(V0_T4_0_0[0:0]  X34[0:0] ));
X        X27[0:0] = ((V1_T4_0_0[0:0]  T20[5:5] )+(V0_T4_0_0[0:0]  X35[0:0] ));
X        X28[0:0] = ((V1_T4_0_0[0:0]  T20[4:4] )+(V0_T4_0_0[0:0]  X36[0:0] ));
X        X29[0:0] = ((V1_T4_0_0[0:0]  T20[3:3] )+(V0_T4_0_0[0:0]  X37[0:0] ));
X        X30[0:0] = ((V1_T4_0_0[0:0]  T20[2:2] )+(V0_T4_0_0[0:0]  X38[0:0] ));
X        X31[0:0] = ((V1_T4_0_0[0:0]  T20[1:1] )+(V0_T4_0_0[0:0]  X39[0:0] ));
X        X32[0:0] = ((V1_T4_0_0[0:0]  T20[0:0] )+(V0_T4_0_0[0:0]  X40[0:0] ));
X        X33[0:0] = ((V1_T22_0_0[0:0]  T23[7:7] )+(V0_T22_0_0[0:0]  T24[7:7] ));
X        X34[0:0] = ((V1_T22_0_0[0:0]  T23[6:6] )+(V0_T22_0_0[0:0]  T24[6:6] ));
X        X35[0:0] = ((V1_T22_0_0[0:0]  T23[5:5] )+(V0_T22_0_0[0:0]  T24[5:5] ));
X        X36[0:0] = ((V1_T22_0_0[0:0]  T23[4:4] )+(V0_T22_0_0[0:0]  T24[4:4] ));
X        X37[0:0] = ((V1_T22_0_0[0:0]  T23[3:3] )+(V0_T22_0_0[0:0]  T24[3:3] ));
X        X38[0:0] = ((V1_T22_0_0[0:0]  T23[2:2] )+(V0_T22_0_0[0:0]  T24[2:2] ));
X        X39[0:0] = ((V1_T22_0_0[0:0]  T23[1:1] )+(V0_T22_0_0[0:0]  T24[1:1] ));
X        X40[0:0] = ((V1_T22_0_0[0:0]  T23[0:0] )+(V0_T22_0_0[0:0]  T24[0:0] ));
X        T25[0:0] = (V00000000_M3_0_7[0:0] )';
X        V00000000_M3_0_7[0:0] = (((((((M3[0:0]'  M3[1:1]' ) M3[2:2]' ) M3[3:3]' ) M3[4:4]' ) M3[5:5]' ) M3[6:6]' ) M3[7:7]' );
X        V0_T22_0_0[0:0] = T22[0:0]' ;
X        V1_T22_0_0[0:0] = T22[0:0] ;
X        V0_T4_0_0[0:0] = T4[0:0]' ;
X        V1_T4_0_0[0:0] = T4[0:0] ;
X        .attribute delay 12 level;
X        .attribute area 141 literal;
X      .endoperation;
X    .endnode;
X
X    .node 7 cond;
X      .successors 8 ;	#  predecessors 6 
X      .cond T25[0:0] T26[0:0] ;	#	Latched
X      .case 1 ;
X        #	Index 12
X        .polargraph 1 3;
X        #	3 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 proc;
X          .inputs in1[0:7] 0b10100000 ;
X          .outputs T27[0:8] ;
X          .successors 3 ;	#  predecessors 1 
X          .proc subtract with (8);
X        .endnode;
X
X        .node 3 nop;	#	sink node
X          .successors ;	#  predecessors 2 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .case 0 ;
X        #	Index 13
X        .polargraph 1 3;
X        #	3 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 proc;
X          .inputs 0b00010000 in5[0:7] ;
X          .outputs T28[0:8] ;
X          .successors 3 ;	#  predecessors 1 
X          .proc add with (8);
X        .endnode;
X
X        .node 3 nop;	#	sink node
X          .successors ;	#  predecessors 2 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .endcond;
X    .endnode;
X
X    .node 8 operation;
X      .inputs T26[0:0] T27[7:7] T28[7:7] T27[6:6] 
X	T28[6:6] T27[5:5] T28[5:5] T27[4:4] 
X	T28[4:4] T27[3:3] T28[3:3] T27[2:2] 
X	T28[2:2] T27[1:1] T28[1:1] T27[0:0] 
X	T28[0:0] ;
X      .outputs X41[0:0] X42[0:0] X43[0:0] X44[0:0] 
X	X45[0:0] X46[0:0] X47[0:0] X48[0:0] 
X	;
X      .successors 9 ;	#  predecessors 7 
X      .operation logic 9 ;
X        #	Expression 0
X        X41[0:0] = ((V1_T26_0_0[0:0]  T27[7:7] )+(V0_T26_0_0[0:0]  T28[7:7] ));
X        X42[0:0] = ((V1_T26_0_0[0:0]  T27[6:6] )+(V0_T26_0_0[0:0]  T28[6:6] ));
X        X43[0:0] = ((V1_T26_0_0[0:0]  T27[5:5] )+(V0_T26_0_0[0:0]  T28[5:5] ));
X        X44[0:0] = ((V1_T26_0_0[0:0]  T27[4:4] )+(V0_T26_0_0[0:0]  T28[4:4] ));
X        X45[0:0] = ((V1_T26_0_0[0:0]  T27[3:3] )+(V0_T26_0_0[0:0]  T28[3:3] ));
X        X46[0:0] = ((V1_T26_0_0[0:0]  T27[2:2] )+(V0_T26_0_0[0:0]  T28[2:2] ));
X        X47[0:0] = ((V1_T26_0_0[0:0]  T27[1:1] )+(V0_T26_0_0[0:0]  T28[1:1] ));
X        X48[0:0] = ((V1_T26_0_0[0:0]  T27[0:0] )+(V0_T26_0_0[0:0]  T28[0:0] ));
X        V0_T26_0_0[0:0] = T26[0:0]' ;
X        V1_T26_0_0[0:0] = T26[0:0] ;
X        .attribute delay 2 level;
X        .attribute area 58 literal;
X      .endoperation;
X    .endnode;
X
X    .node 9 nop;	#	sink node
X      .successors ;	#  predecessors 8 
X    .endnode;
X
X    .attribute hercules direct_connect out1[0:0] X48[0:0] ;
X    .attribute hercules direct_connect out1[1:1] X47[0:0] ;
X    .attribute hercules direct_connect out1[2:2] X46[0:0] ;
X    .attribute hercules direct_connect out1[3:3] X45[0:0] ;
X    .attribute hercules direct_connect out1[4:4] X44[0:0] ;
X    .attribute hercules direct_connect out1[5:5] X43[0:0] ;
X    .attribute hercules direct_connect out1[6:6] X42[0:0] ;
X    .attribute hercules direct_connect out1[7:7] X41[0:0] ;
X    .endpolargraph;
X.endmodel parker1986 ;
END_OF_FILE
if test 19826 -ne `wc -c <'parker1986/parker1986.sif'`; then
    echo shar: \"'parker1986/parker1986.sif'\" unpacked with wrong size!
fi
# end of 'parker1986/parker1986.sif'
fi
if test -f 'parker1986/subtract_8.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'parker1986/subtract_8.sif'\"
else
echo shar: Extracting \"'parker1986/subtract_8.sif'\" \(3369 characters\)
sed "s/^X//" >'parker1986/subtract_8.sif' <<'END_OF_FILE'
X#
X#	Sif model subtract_8	Printed Tue Jul 24 15:07:07 1990
X#
X.model subtract_8 sequencing ; 
X  .inputs op1[8] op2[8] ;
X  .outputs return_value[9] ;
X    #	Index 1
X    .polargraph 1 4;
X    .variable T2[9] T1[9] ;
X    #	4 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs op2[0:0] op2[1:1] op2[2:2] op2[3:3] 
X	op2[4:4] op2[5:5] op2[6:6] op2[7:7] 
X	;
X      .outputs T1[0:0] T1[1:1] T1[2:2] T1[3:3] 
X	T1[4:4] T1[5:5] T1[6:6] T1[7:7] 
X	;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        c_T1[0:0] =  1 ;
X        T1[0:0] = ((((( 0'  op2[0:0]' ) c_T1[0:0]' )+(( 0  op2[0:0] ) c_T1[0:0]' ))+(( 0'  op2[0:0] ) c_T1[0:0] ))+(( 0  op2[0:0]' ) c_T1[0:0] ));
X        c_T1[1:1] = (( 0  op2[0:0]' )+(c_T1[0:0]  ( 0 +op2[0:0]' )));
X        T1[1:1] = ((((( 0'  op2[1:1]' ) c_T1[1:1]' )+(( 0  op2[1:1] ) c_T1[1:1]' ))+(( 0'  op2[1:1] ) c_T1[1:1] ))+(( 0  op2[1:1]' ) c_T1[1:1] ));
X        c_T1[2:2] = (( 0  op2[1:1]' )+(c_T1[1:1]  ( 0 +op2[1:1]' )));
X        T1[2:2] = ((((( 0'  op2[2:2]' ) c_T1[2:2]' )+(( 0  op2[2:2] ) c_T1[2:2]' ))+(( 0'  op2[2:2] ) c_T1[2:2] ))+(( 0  op2[2:2]' ) c_T1[2:2] ));
X        c_T1[3:3] = (( 0  op2[2:2]' )+(c_T1[2:2]  ( 0 +op2[2:2]' )));
X        T1[3:3] = ((((( 0'  op2[3:3]' ) c_T1[3:3]' )+(( 0  op2[3:3] ) c_T1[3:3]' ))+(( 0'  op2[3:3] ) c_T1[3:3] ))+(( 0  op2[3:3]' ) c_T1[3:3] ));
X        c_T1[4:4] = (( 0  op2[3:3]' )+(c_T1[3:3]  ( 0 +op2[3:3]' )));
X        T1[4:4] = ((((( 0'  op2[4:4]' ) c_T1[4:4]' )+(( 0  op2[4:4] ) c_T1[4:4]' ))+(( 0'  op2[4:4] ) c_T1[4:4] ))+(( 0  op2[4:4]' ) c_T1[4:4] ));
X        c_T1[5:5] = (( 0  op2[4:4]' )+(c_T1[4:4]  ( 0 +op2[4:4]' )));
X        T1[5:5] = ((((( 0'  op2[5:5]' ) c_T1[5:5]' )+(( 0  op2[5:5] ) c_T1[5:5]' ))+(( 0'  op2[5:5] ) c_T1[5:5] ))+(( 0  op2[5:5]' ) c_T1[5:5] ));
X        c_T1[6:6] = (( 0  op2[5:5]' )+(c_T1[5:5]  ( 0 +op2[5:5]' )));
X        T1[6:6] = ((((( 0'  op2[6:6]' ) c_T1[6:6]' )+(( 0  op2[6:6] ) c_T1[6:6]' ))+(( 0'  op2[6:6] ) c_T1[6:6] ))+(( 0  op2[6:6]' ) c_T1[6:6] ));
X        c_T1[7:7] = (( 0  op2[6:6]' )+(c_T1[6:6]  ( 0 +op2[6:6]' )));
X        T1[7:7] = ((((( 0'  op2[7:7]' ) c_T1[7:7]' )+(( 0  op2[7:7] ) c_T1[7:7]' ))+(( 0'  op2[7:7] ) c_T1[7:7] ))+(( 0  op2[7:7]' ) c_T1[7:7] ));
X        c_T1[8:8] = (( 0  op2[7:7]' )+(c_T1[7:7]  ( 0 +op2[7:7]' )));
X        T1[8:8] = c_T1[7:7] ;
X        .attribute delay 19 level;
X        .attribute area 258 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 proc;
X      .inputs op1[0:7] T1[0:7] ;
X      .outputs T2[0:8] ;
X      .successors 4 ;	#  predecessors 2 
X      .proc add with (8);
X    .endnode;
X
X    .node 4 nop;	#	sink node
X      .successors ;	#  predecessors 3 
X    .endnode;
X
X    .attribute hercules direct_connect return_value[0:0] T2[0:0] ;
X    .attribute hercules direct_connect return_value[1:1] T2[1:1] ;
X    .attribute hercules direct_connect return_value[2:2] T2[2:2] ;
X    .attribute hercules direct_connect return_value[3:3] T2[3:3] ;
X    .attribute hercules direct_connect return_value[4:4] T2[4:4] ;
X    .attribute hercules direct_connect return_value[5:5] T2[5:5] ;
X    .attribute hercules direct_connect return_value[6:6] T2[6:6] ;
X    .attribute hercules direct_connect return_value[7:7] T2[7:7] ;
X    .attribute hercules direct_connect return_value[8:8] T2[8:8] ;
X    .endpolargraph;
X.endmodel subtract_8 ;
END_OF_FILE
if test 3369 -ne `wc -c <'parker1986/subtract_8.sif'`; then
    echo shar: \"'parker1986/subtract_8.sif'\" unpacked with wrong size!
fi
# end of 'parker1986/subtract_8.sif'
fi
if test -f 'parker1986/parker1986.out.gold' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'parker1986/parker1986.out.gold'\"
else
echo shar: Extracting \"'parker1986/parker1986.out.gold'\" \(1678 characters\)
sed "s/^X//" >'parker1986/parker1986.out.gold' <<'END_OF_FILE'
X56 THOR banal
Xin1[0:0]
Xin1[1:1]
Xin1[2:2]
Xin1[3:3]
Xin1[4:4]
Xin1[5:5]
Xin1[6:6]
Xin1[7:7]
Xin2[0:0]
Xin2[1:1]
Xin2[2:2]
Xin2[3:3]
Xin2[4:4]
Xin2[5:5]
Xin2[6:6]
Xin2[7:7]
Xin3[0:0]
Xin3[1:1]
Xin3[2:2]
Xin3[3:3]
Xin3[4:4]
Xin3[5:5]
Xin3[6:6]
Xin3[7:7]
Xin4[0:0]
Xin4[1:1]
Xin4[2:2]
Xin4[3:3]
Xin4[4:4]
Xin4[5:5]
Xin4[6:6]
Xin4[7:7]
Xin5[0:0]
Xin5[1:1]
Xin5[2:2]
Xin5[3:3]
Xin5[4:4]
Xin5[5:5]
Xin5[6:6]
Xin5[7:7]
Xin6[0:0]
Xin6[1:1]
Xin6[2:2]
Xin6[3:3]
Xin6[4:4]
Xin6[5:5]
Xin6[6:6]
Xin6[7:7]
Xout1[0:0]
Xout1[1:1]
Xout1[2:2]
Xout1[3:3]
Xout1[4:4]
Xout1[5:5]
Xout1[6:6]
Xout1[7:7]
X     0:00000000000000000000000000000000000000000000000011011111
X     1:01100000000000000000000000000000000000000000000010000000
X     2:11100000000000000000000001100000100000000000000001000000
X     3:00011000111111000000001011000010010100100011101011001000
X     4:10000110100000001010110011100100001011001010010000111010
X     5:00011100111101000001001011101010001100101000110011001100
X     6:10001010110011001101110001101100010101000100110000110010
X     7:10011010100010101011110011011100011011000101010000101010
X     8:10001010101111001101110001101100010101000011110000110010
X     9:10010010100110101000101010111100110111000110110000100010
X    10:10110000110001000101010000111100100111001000110000010000
X    11:10000000101011001110010000101100101001001111010000111111
X    12:11011100011011000101010000111100100111001000110001101100
X    13:11101010001100101000110010110010110011000100010001001010
X    14:11110100000100101110101000110010100011001011001001010100
X    15:10100000111100000001010011101100001101001000001000000000
X    16:00010010111010100011001010001100101100101100110011000010
X    17:01001000000011001101001001110100011000100100101010110000
END_OF_FILE
if test 1678 -ne `wc -c <'parker1986/parker1986.out.gold'`; then
    echo shar: \"'parker1986/parker1986.out.gold'\" unpacked with wrong size!
fi
# end of 'parker1986/parker1986.out.gold'
fi
echo shar: End of shell archive.
exit 0


