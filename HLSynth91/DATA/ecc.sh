
#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of shell archive."
# Contents:  ecc/ecc.hc ecc/ecc.pat ecc/ecc.mon ecc/ENCODER_3.sif
#   ecc/ENCODER_4.sif ecc/decode.sif ecc/ecc.sif ecc/encode.sif
#   ecc/noise.sif ecc/ecc.out.gold
# Wrapped by synthesis@sirius on Thu Jul 26 17:15:31 1990
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'ecc/ecc.hc' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/ecc.hc'\"
else
echo shar: Extracting \"'ecc/ecc.hc'\" \(7141 characters\)
sed "s/^X//" >'ecc/ecc.hc' <<'END_OF_FILE'
X/* Error Correction System
X *
X * This system models transmission of digital data through a serial line.
X * Data is read in parallel at the input, encoded with parity, sent along
X * a serial line (where transmission errors can be inserted), then
X * decoded (possibly correcting transmission errors), and finally written
X * out in parallel.
X *
X *			data_ready                         +-----> output_ready
X *			 +----------------+                |
X *	+--------------+ |  +-----------+ |  +----------------+  2 bits
X *  --->|              |-+  |           | +->|                |-/-> detect_error
X *  =/=>|   encode     |--->|   noise   |--->|     decode     | 
X *    8	|              | +->|           |    |                |==/=> data_out
X *	+--------------+ |  +-----------+    +----------------+   8 bits
X *			 |
X *			error
X *
X *
X *
X * The data to transmit is parity-encoded according to the following table:
X *
X *	D0 D1 D2 R0
X *	D3 D4 D5 R1
X *	D6 D7 X  R2
X *	C0 C1 C2 T
X *
X * where R0 = D0 xor D1 xor D2
X * 	 R1 = D3 xor D4 xor D5
X * 	 R2 = D6 xor D7 xor X
X * 	 C0 = D0 xor D3 xor D6
X * 	 C1 = D1 xor D4 xor D7
X * 	 C2 = D2 xor D5 xor X
X *	 T  = D0 xor D1 xor D2 xor D3 xor D4 xor D5 xor D6 xor D7 xor X
X *	         xor R0 xor R1 xor R2 xor C0 xor C1 xor C2
X *
X * D0-D7 is the data to transmit,
X *     X is any value (but has to stay consistent)
X * R0-R2 represent the parity of the three rows
X * C0-C2 represent the parity of the three columns
X *     T is the total parity
X *
X * the bits are sent serially in the following order:
X * D0,D1,D2,D3,D4.D5.D6,D7,X,R0,R1,R2,C0,C1,C2,T
X *
X * 
X * 
X * The system is represented by three parallel processes:
X *	- Coder
X *	- Noise generator
X *	- Decoder (error correction module)
X *
X * The coder receives the parallel data, plus a data ready signal.
X * It outputs the 16 encoded bits on a serial line, and an output ready
X * signal indicating the first bit on the serial line.
X *
X * The noise generator is an exclusive-or with a data and a noise input.
X *
X * The decoder has a serial line as its input. It waits for the output
X * ready signal of the coder, then immediately starts reading 16 bits.
X * It decodes the original 8 bits, using the parity bits to check
X * the validity of the signal (and possibly to correct it).
X * It outputs the original 8 bits, and an error flag.
X */
X
X#define NO_ERROR	0b00
X#define ONE_ERROR	0b01
X#define MULTIPLE_ERRORS	0b11
X
X
X/*
X *	ENCODER template
X *
X *	Performs exclusive OR's of all the bits in the operand
X */
X
Xtemplate function ENCODER(indata) with (size) 
X	return boolean[1]
X	in boolean indata[size];
X{
X	int 	i;
X	boolean	temp;
X
X	temp = 0;
X	for i = 0 to size-1 do
X		temp = temp xor indata[i];
X	return_value = temp;
X}
X
X/*
X *	encode
X *
X *	Transforms parallel data_in into serial stream, padded
X *	with parity checking
X */
X 
Xprocess encode(data_in,new_data,encoder_out,data_ready)
X
X	in	port data_in[8];
X	in	port new_data;
X	out	port encoder_out;
X	out	port data_ready;
X[
X	int		i;
X	boolean 	output_data[16];
X
X	while ( !new_data) ;	/* Waiting for incoming data */
X
X	output_data[0:7] = read (data_in);
X	output_data[8] = 0;
X	output_data[15] = 0;
X
X	/*
X	 *	calculate parity bits for row and column
X	 */
X	for i = 0 to 2 do
X	{
X		output_data[i+9] = ENCODER (
X				output_data[3*i] @ 
X				output_data[3*i+1] @
X				output_data[3*i+2] ) with (3);
X
X		output_data[i+12] = ENCODER (
X				output_data[i] @
X				output_data[i+3] @
X				output_data[i+6] ) with (3);
X
X		output_data[15] = ENCODER (
X			output_data[15] @
X			output_data[3*i] @
X			output_data[3*i+1] @
X			output_data[3*i+2] )with (4);
X	}
X
X	/*
X 	 *	write output stream, the first bit is
X 	 *	indicated by a pulse in data_ready
X	 */
X	<
X		[
X			write data_ready = 1;
X			write data_ready = 0;
X		]
X
X		for i = 0 to 15 do
X		[
X			write encoder_out = output_data[i:i];
X		]
X	>
X]
X
X/*
X *	noise
X *
X *	Noise generator on the serial data stream
X */
X
Xprocess noise(error,encoder_out,decoder_in)
X	in	port error;
X	in	port encoder_out;
X	out	port decoder_in;
X{
X	decoder_in = encoder_out xor error;
X}
X
X/*
X *	decode
X *
X *	Transforms serial stream of data bits, and perform error
X *	correction to retrieve the original 8 bit data.
X */
X
Xprocess decode(decoder_in, data_ready, data_out, err, out_ready)
X	in	port decoder_in;
X	in	port data_ready;
X	out	port data_out[8];
X	out	port err[2];
X	out	port out_ready;
X[
X	int		i;
X	boolean 	input_data[16];
X	boolean 	row_parity[3];
X	boolean 	column_parity[3];
X	boolean 	global_parity;
X	boolean 	error[2];
X
X	while (!data_ready) ;		/* rising edge of data_ready */
X
X	/*
X	 *	sample input stream
X	 */
X	for i = 0 to 15 do
X	[
X		input_data[i] = read (decoder_in);
X	]
X
X	/*
X	 *	compute parity check on the input data
X	 */
X	global_parity = input_data[15];
X
X	for i = 0 to 2 do
X	{
X		row_parity[i] = ENCODER (
X			input_data[3*i] @
X			input_data[3*i+1] @
X			input_data[3*i+2] @
X			input_data[i+9] ) with (4);
X
X		column_parity[i] = ENCODER (
X			input_data[i] @
X			input_data[i+3] @
X			input_data[i+6] @
X			input_data[i+12] ) with (4);
X
X		global_parity = ENCODER (
X			global_parity @
X			input_data[3*i] @
X			input_data[3*i+1] @
X			input_data[3*i+2] ) with (4);
X	}
X
X	/*
X	 *	error correction
X	 */
X	if (!global_parity)
X	{
X		if ((row_parity[0:2] == 0b000)&(column_parity[0:2] == 0b000))
X		{
X			error = NO_ERROR;	/* No transmission error */
X		}
X		else {
X			error = MULTIPLE_ERRORS;/* Multiple errors,
X						 * no correction  possible */
X		}
X	}
X	else {	/* Single error */
X		if (row_parity[0:0])
X		{
X			if (column_parity[0:0])
X			{
X				input_data[0:0] = !input_data[0:0];
X			}
X			else if (column_parity[1:1])
X			{
X				input_data[1:1] = !input_data[1:1];
X			}
X			else if (column_parity[2:2])
X			{
X				input_data[2:2] = !input_data[2:2];
X			}
X		}
X		else if ( row_parity[1:1])
X		{
X			if (column_parity[0:0])
X			{
X				input_data[3:3] = !input_data[3:3];
X			}
X			else if (column_parity[1:1])
X			{
X				input_data[4:4] = !input_data[4:4];
X			}
X			else if (column_parity[2:2])
X			{
X				input_data[5:5] = !input_data[5:5];
X			}
X		}
X		else if ( row_parity[2:2])
X		{
X			if (column_parity[0:0])
X			{
X				input_data[6:6] = !input_data[6:6];
X			}
X			else if (column_parity[1:1])
X			{
X				input_data[7:7] = !input_data[7:7];
X			}
X		}
X		error = ONE_ERROR ;
X	}
X
X	/*
X	 *	write parallel data and error flags
X	 */
X	<
X		write data_out = input_data[0:7];
X		write err = error;
X		[
X			write out_ready = 1;
X			write out_ready = 0;
X		]
X	>
X]
X
X/*
X *	ecc
X *
X *	Interconnection of the encoder, decoder, and noise generator
X *
X *	The three processes operate in parallel, independently
X */
X
Xblock ecc(new_data,data_in,error,data_out,detected_error,
X		encoder_out,decoder_in,data_ready,out_ready)
X
X	in	port new_data;		/* start signal	*/
X	in	port data_in[8];	/* input data	*/
X	in	port error;		/* noise signal	*/
X	out	port data_out[8];	/* output data	*/
X	out	port detected_error[2];	/* error flag	*/
X	out	port out_ready;		/* data out ready */
X
X	out	port encoder_out;	/* sequential output from encoder */
X	out	port decoder_in;	/* sequential stream (with noise) */
X	out	port data_ready;	/* sequential output ready */
X<
X	encode(data_in,new_data,encoder_out,data_ready);
X
X	noise(error,encoder_out,decoder_in); 
X
X	decode(decoder_in,data_ready,data_out,detected_error,out_ready);
X>
END_OF_FILE
if test 7141 -ne `wc -c <'ecc/ecc.hc'`; then
    echo shar: \"'ecc/ecc.hc'\" unpacked with wrong size!
fi
# end of 'ecc/ecc.hc'
fi
if test -f 'ecc/ecc.pat' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/ecc.pat'\"
else
echo shar: Extracting \"'ecc/ecc.pat'\" \(2761 characters\)
sed "s/^X//" >'ecc/ecc.pat' <<'END_OF_FILE'
X# ECC Pattern file
X#
X# Resets system with the first two patterns, then 
X# sends three sets of data:
X#
X# i) data_in = 0x21, no transmission error
X#	=> data_out = 0x21, detected_error = 0b00
X#
X# ii) data_in = 0x43, one transmission error
X#	=> data_out = 0x43, detected_error = 0b01
X#
X# iii) data_in = 0x65, two transmission error (cannot be recovered)
X#	=> data_out = 0x--, detected_error = 0b11 (data_out is invalid)
X#
X#
X#
X
X.inputs  CLK RESET new_data[0:0] data_in[0:0] data_in[1:1] data_in[2:2]
X	 data_in[3:3] data_in[4:4] data_in[5:5] data_in[6:6]
X	 data_in[7:7] error[0:0] ;
X
X110111111110;
X010000000001;
X#
X# First input to the system (data_in = 0x21)
X#
X100000000000;
X000000000000;
X101100001000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X#
X# Second input to the system (data_in = 0x43)
X#
X101110000100;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000001;	# Transmission error (last bit = 1)
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X#
X# Third input to the system (data_in = 0x65)
X#
X101101001100;
X000000000000;
X100000000001;	# Transmission error (last bit = 1)
X000000000001;	# Second transmission error (data_out cannot be corrected)
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000001;
X100000000001;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000001;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
X000000000000;
X100000000000;
END_OF_FILE
if test 2761 -ne `wc -c <'ecc/ecc.pat'`; then
    echo shar: \"'ecc/ecc.pat'\" unpacked with wrong size!
fi
# end of 'ecc/ecc.pat'
fi
if test -f 'ecc/ecc.mon' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/ecc.mon'\"
else
echo shar: Extracting \"'ecc/ecc.mon'\" \(399 characters\)
sed "s/^X//" >'ecc/ecc.mon' <<'END_OF_FILE'
Xnew_data[0:0]
Xerror[0:0]
Xdetected_error[0:0]
Xdetected_error[1:1]
XHEX data_in0 data_in[0:0] data_in[1:1] data_in[2:2] data_in[3:3]
XHEX data_in1 data_in[4:4] data_in[5:5] data_in[6:6] data_in[7:7]
XHEX data_out0 data_out[0:0] data_out[1:1] data_out[2:2] data_out[3:3]
XHEX data_out1 data_out[4:4] data_out[5:5] data_out[6:6] data_out[7:7]
Xencoder_out[0:0]
Xdecoder_in[0:0]
Xdata_ready[0:0]
Xout_ready[0:0]
END_OF_FILE
if test 399 -ne `wc -c <'ecc/ecc.mon'`; then
    echo shar: \"'ecc/ecc.mon'\" unpacked with wrong size!
fi
# end of 'ecc/ecc.mon'
fi
if test -f 'ecc/ENCODER_3.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/ENCODER_3.sif'\"
else
echo shar: Extracting \"'ecc/ENCODER_3.sif'\" \(913 characters\)
sed "s/^X//" >'ecc/ENCODER_3.sif' <<'END_OF_FILE'
X#
X#	Sif model ENCODER_3	Printed Tue Jul 24 15:06:16 1990
X#
X.model ENCODER_3 sequencing ; 
X  .inputs indata[3] ;
X  .outputs return_value ;
X    #	Index 1
X    .polargraph 1 3;
X    .variable T2 ;
X    #	3 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs indata[0:0] indata[1:1] indata[2:2] ;
X      .outputs T2[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        T1[0:0] = ((indata[0:0]  indata[1:1]' )+(indata[0:0]'  indata[1:1] ));
X        T2[0:0] = ((T1[0:0]  indata[2:2]' )+(T1[0:0]'  indata[2:2] ));
X        .attribute delay 4 level;
X        .attribute area 14 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 nop;	#	sink node
X      .successors ;	#  predecessors 2 
X    .endnode;
X
X    .attribute hercules direct_connect return_value[0:0] T2[0:0] ;
X    .endpolargraph;
X.endmodel ENCODER_3 ;
END_OF_FILE
if test 913 -ne `wc -c <'ecc/ENCODER_3.sif'`; then
    echo shar: \"'ecc/ENCODER_3.sif'\" unpacked with wrong size!
fi
# end of 'ecc/ENCODER_3.sif'
fi
if test -f 'ecc/ENCODER_4.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/ENCODER_4.sif'\"
else
echo shar: Extracting \"'ecc/ENCODER_4.sif'\" \(998 characters\)
sed "s/^X//" >'ecc/ENCODER_4.sif' <<'END_OF_FILE'
X#
X#	Sif model ENCODER_4	Printed Tue Jul 24 15:06:21 1990
X#
X.model ENCODER_4 sequencing ; 
X  .inputs indata[4] ;
X  .outputs return_value ;
X    #	Index 1
X    .polargraph 1 3;
X    .variable T3 ;
X    #	3 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs indata[0:0] indata[1:1] indata[2:2] indata[3:3] 
X	;
X      .outputs T3[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        T1[0:0] = ((indata[0:0]  indata[1:1]' )+(indata[0:0]'  indata[1:1] ));
X        T2[0:0] = ((T1[0:0]  indata[2:2]' )+(T1[0:0]'  indata[2:2] ));
X        T3[0:0] = ((T2[0:0]  indata[3:3]' )+(T2[0:0]'  indata[3:3] ));
X        .attribute delay 6 level;
X        .attribute area 21 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 nop;	#	sink node
X      .successors ;	#  predecessors 2 
X    .endnode;
X
X    .attribute hercules direct_connect return_value[0:0] T3[0:0] ;
X    .endpolargraph;
X.endmodel ENCODER_4 ;
END_OF_FILE
if test 998 -ne `wc -c <'ecc/ENCODER_4.sif'`; then
    echo shar: \"'ecc/ENCODER_4.sif'\" unpacked with wrong size!
fi
# end of 'ecc/ENCODER_4.sif'
fi
if test -f 'ecc/decode.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/decode.sif'\"
else
echo shar: Extracting \"'ecc/decode.sif'\" \(20578 characters\)
sed "s/^X//" >'ecc/decode.sif' <<'END_OF_FILE'
X#
X#	Sif model decode	Printed Tue Jul 24 15:06:27 1990
X#
X.model decode sequencing process; 
X  .inputs port decoder_in port data_ready ;
X  .outputs port data_out[8] port err[2] port out_ready ;
X    #	Index 1
X    .polargraph 1 45;
X    .variable M31[2] T2 M30[8] T53 
X	T13 T52 T12 T11 
X	T51 T10 T50 T9 
X	T49 T8 T7 T48 
X	T6 T47 T5 T46 
X	T4 T3 T1 T40 
X	T37 T34 T39 T36 
X	T33 T41 M27[4] T38 
X	M24[4] T31 M21[4] T28 
X	T25 M18[4] T35 M15[4] 
X	T30 T24 M12[4] T27 
X	T22 T21 M9[4] T32 
X	M6[4] T29 T23 T20 
X	M3[4] T26 T19 T18 
X	T17 T16 T14 ;
X    #	45 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs data_ready[0:0] ;
X      .outputs T14[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        T14[0:0] = data_ready[0:0]' ;
X        .attribute delay 0 level;
X        .attribute area 1 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 cond;
X      .successors 4 ;	#  predecessors 2 
X      .cond T14[0:0] ;	#	Latched
X      .case 1 ;
X        #	Index 2
X        .polargraph 1 3;
X        #	3 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 loop;
X          .successors 3 ;	#  predecessors 1 
X          .loop T16[0:0] ;	#	
X            #	Index 3
X            .polargraph 1 3;
X            #	3 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 operation;
X              .inputs data_ready[0:0] ;
X              .outputs T16[0:0] ;
X              .successors 3 ;	#  predecessors 1 
X              .operation logic 2 ;
X                #	Expression 0
X                T15[0:0] = data_ready[0:0]' ;
X                T16[0:0] = T15[0:0]' ;
X                .attribute delay 0 level;
X                .attribute area 2 literal;
X              .endoperation;
X            .endnode;
X
X            .node 3 nop;	#	sink node
X              .successors ;	#  predecessors 2 
X            .endnode;
X
X            .endpolargraph;
X          .endloop;
X        .endnode;
X
X        .node 3 nop;	#	sink node
X          .successors ;	#  predecessors 2 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .case 0 ;
X        #	Index 4
X        .polargraph 1 2;
X        #	2 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 nop;	#	sink node
X          .successors ;	#  predecessors 1 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .endcond;
X    .endnode;
X
X    .node 4 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T17[0:0] ;
X      .successors 5 ;	#  predecessors 3 
X      .attribute constraint delay 4 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 5 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T18[0:0] ;
X      .successors 6 ;	#  predecessors 4 
X      .attribute constraint delay 5 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 6 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T19[0:0] ;
X      .successors 7 ;	#  predecessors 5 
X      .attribute constraint delay 6 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 7 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T20[0:0] ;
X      .successors 8 ;	#  predecessors 6 
X      .attribute constraint delay 7 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 8 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T21[0:0] ;
X      .successors 9 ;	#  predecessors 7 
X      .attribute constraint delay 8 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 9 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T22[0:0] ;
X      .successors 10 ;	#  predecessors 8 
X      .attribute constraint delay 9 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 10 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T23[0:0] ;
X      .successors 11 ;	#  predecessors 9 
X      .attribute constraint delay 10 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 11 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T24[0:0] ;
X      .successors 12 ;	#  predecessors 10 
X      .attribute constraint delay 11 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 12 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T25[0:0] ;
X      .successors 13 ;	#  predecessors 11 
X      .attribute constraint delay 12 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 13 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T26[0:0] ;
X      .successors 14 ;	#  predecessors 12 
X      .attribute constraint delay 13 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 14 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T27[0:0] ;
X      .successors 15 ;	#  predecessors 13 
X      .attribute constraint delay 14 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 15 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T28[0:0] ;
X      .successors 16 ;	#  predecessors 14 
X      .attribute constraint delay 15 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 16 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T29[0:0] ;
X      .successors 17 ;	#  predecessors 15 
X      .attribute constraint delay 16 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 17 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T30[0:0] ;
X      .successors 18 ;	#  predecessors 16 
X      .attribute constraint delay 17 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 18 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T31[0:0] ;
X      .successors 19 ;	#  predecessors 17 
X      .attribute constraint delay 18 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 19 operation;
X      .inputs decoder_in[0:0] ;
X      .outputs T32[0:0] ;
X      .successors 20 22 24 26 28 32 34 ;	#  predecessors 18 
X      .attribute constraint delay 19 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 20 operation;
X      .inputs T17[0:0] T18[0:0] T19[0:0] T26[0:0] 
X	;
X      .outputs M3[0:0] M3[1:1] M3[2:2] M3[3:3] 
X	;
X      .successors 21 ;	#  predecessors 19 
X      .operation logic 3 ;
X        #	Expression 0
X        M1[0:0] = T17[0:0] ;
X        M1[1:1] = T18[0:0] ;
X        M2[0:0] = M1[0:0] ;
X        M2[1:1] = M1[1:1] ;
X        M2[2:2] = T19[0:0] ;
X        M3[0:0] = M2[0:0] ;
X        M3[1:1] = M2[1:1] ;
X        M3[2:2] = M2[2:2] ;
X        M3[3:3] = T26[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 21 proc;
X      .inputs M3[0:3] ;
X      .outputs T33[0:0] ;
X      .successors 38 ;	#  predecessors 20 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 22 operation;
X      .inputs T17[0:0] T20[0:0] T23[0:0] T29[0:0] 
X	;
X      .outputs M6[0:0] M6[1:1] M6[2:2] M6[3:3] 
X	;
X      .successors 23 ;	#  predecessors 19 
X      .operation logic 4 ;
X        #	Expression 0
X        M4[0:0] = T17[0:0] ;
X        M4[1:1] = T20[0:0] ;
X        M5[0:0] = M4[0:0] ;
X        M5[1:1] = M4[1:1] ;
X        M5[2:2] = T23[0:0] ;
X        M6[0:0] = M5[0:0] ;
X        M6[1:1] = M5[1:1] ;
X        M6[2:2] = M5[2:2] ;
X        M6[3:3] = T29[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 23 proc;
X      .inputs M6[0:3] ;
X      .outputs T34[0:0] ;
X      .successors 38 ;	#  predecessors 22 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 24 operation;
X      .inputs T32[0:0] T17[0:0] T18[0:0] T19[0:0] 
X	;
X      .outputs M9[0:0] M9[1:1] M9[2:2] M9[3:3] 
X	;
X      .successors 25 ;	#  predecessors 19 
X      .operation logic 5 ;
X        #	Expression 0
X        M7[0:0] = T32[0:0] ;
X        M7[1:1] = T17[0:0] ;
X        M8[0:0] = M7[0:0] ;
X        M8[1:1] = M7[1:1] ;
X        M8[2:2] = T18[0:0] ;
X        M9[0:0] = M8[0:0] ;
X        M9[1:1] = M8[1:1] ;
X        M9[2:2] = M8[2:2] ;
X        M9[3:3] = T19[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 25 proc;
X      .inputs M9[0:3] ;
X      .outputs T35[0:0] ;
X      .successors 30 ;	#  predecessors 24 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 26 operation;
X      .inputs T20[0:0] T21[0:0] T22[0:0] T27[0:0] 
X	;
X      .outputs M12[0:0] M12[1:1] M12[2:2] M12[3:3] 
X	;
X      .successors 27 ;	#  predecessors 19 
X      .operation logic 6 ;
X        #	Expression 0
X        M10[0:0] = T20[0:0] ;
X        M10[1:1] = T21[0:0] ;
X        M11[0:0] = M10[0:0] ;
X        M11[1:1] = M10[1:1] ;
X        M11[2:2] = T22[0:0] ;
X        M12[0:0] = M11[0:0] ;
X        M12[1:1] = M11[1:1] ;
X        M12[2:2] = M11[2:2] ;
X        M12[3:3] = T27[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 27 proc;
X      .inputs M12[0:3] ;
X      .outputs T36[0:0] ;
X      .successors 38 ;	#  predecessors 26 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 28 operation;
X      .inputs T18[0:0] T21[0:0] T24[0:0] T30[0:0] 
X	;
X      .outputs M15[0:0] M15[1:1] M15[2:2] M15[3:3] 
X	;
X      .successors 29 ;	#  predecessors 19 
X      .operation logic 7 ;
X        #	Expression 0
X        M13[0:0] = T18[0:0] ;
X        M13[1:1] = T21[0:0] ;
X        M14[0:0] = M13[0:0] ;
X        M14[1:1] = M13[1:1] ;
X        M14[2:2] = T24[0:0] ;
X        M15[0:0] = M14[0:0] ;
X        M15[1:1] = M14[1:1] ;
X        M15[2:2] = M14[2:2] ;
X        M15[3:3] = T30[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 29 proc;
X      .inputs M15[0:3] ;
X      .outputs T37[0:0] ;
X      .successors 38 ;	#  predecessors 28 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 30 operation;
X      .inputs T35[0:0] T20[0:0] T21[0:0] T22[0:0] 
X	;
X      .outputs M18[0:0] M18[1:1] M18[2:2] M18[3:3] 
X	;
X      .successors 31 ;	#  predecessors 25 
X      .operation logic 8 ;
X        #	Expression 0
X        M16[0:0] = T35[0:0] ;
X        M16[1:1] = T20[0:0] ;
X        M17[0:0] = M16[0:0] ;
X        M17[1:1] = M16[1:1] ;
X        M17[2:2] = T21[0:0] ;
X        M18[0:0] = M17[0:0] ;
X        M18[1:1] = M17[1:1] ;
X        M18[2:2] = M17[2:2] ;
X        M18[3:3] = T22[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 31 proc;
X      .inputs M18[0:3] ;
X      .outputs T38[0:0] ;
X      .successors 36 ;	#  predecessors 30 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 32 operation;
X      .inputs T23[0:0] T24[0:0] T25[0:0] T28[0:0] 
X	;
X      .outputs M21[0:0] M21[1:1] M21[2:2] M21[3:3] 
X	;
X      .successors 33 ;	#  predecessors 19 
X      .operation logic 9 ;
X        #	Expression 0
X        M19[0:0] = T23[0:0] ;
X        M19[1:1] = T24[0:0] ;
X        M20[0:0] = M19[0:0] ;
X        M20[1:1] = M19[1:1] ;
X        M20[2:2] = T25[0:0] ;
X        M21[0:0] = M20[0:0] ;
X        M21[1:1] = M20[1:1] ;
X        M21[2:2] = M20[2:2] ;
X        M21[3:3] = T28[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 33 proc;
X      .inputs M21[0:3] ;
X      .outputs T39[0:0] ;
X      .successors 38 ;	#  predecessors 32 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 34 operation;
X      .inputs T19[0:0] T22[0:0] T25[0:0] T31[0:0] 
X	;
X      .outputs M24[0:0] M24[1:1] M24[2:2] M24[3:3] 
X	;
X      .successors 35 ;	#  predecessors 19 
X      .operation logic 10 ;
X        #	Expression 0
X        M22[0:0] = T19[0:0] ;
X        M22[1:1] = T22[0:0] ;
X        M23[0:0] = M22[0:0] ;
X        M23[1:1] = M22[1:1] ;
X        M23[2:2] = T25[0:0] ;
X        M24[0:0] = M23[0:0] ;
X        M24[1:1] = M23[1:1] ;
X        M24[2:2] = M23[2:2] ;
X        M24[3:3] = T31[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 35 proc;
X      .inputs M24[0:3] ;
X      .outputs T40[0:0] ;
X      .successors 38 ;	#  predecessors 34 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 36 operation;
X      .inputs T38[0:0] T23[0:0] T24[0:0] T25[0:0] 
X	;
X      .outputs M27[0:0] M27[1:1] M27[2:2] M27[3:3] 
X	;
X      .successors 37 ;	#  predecessors 31 
X      .operation logic 11 ;
X        #	Expression 0
X        M25[0:0] = T38[0:0] ;
X        M25[1:1] = T23[0:0] ;
X        M26[0:0] = M25[0:0] ;
X        M26[1:1] = M25[1:1] ;
X        M26[2:2] = T24[0:0] ;
X        M27[0:0] = M26[0:0] ;
X        M27[1:1] = M26[1:1] ;
X        M27[2:2] = M26[2:2] ;
X        M27[3:3] = T25[0:0] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 37 proc;
X      .inputs M27[0:3] ;
X      .outputs T41[0:0] ;
X      .successors 38 ;	#  predecessors 36 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 38 operation;
X      .inputs T41[0:0] T33[0:0] T36[0:0] T39[0:0] 
X	T34[0:0] T37[0:0] T40[0:0] T17[0:0] 
X	T18[0:0] T19[0:0] T20[0:0] T21[0:0] 
X	T22[0:0] T23[0:0] T24[0:0] ;
X      .outputs T1[0:0] T2[0:0] T3[0:0] T4[0:0] 
X	T46[0:0] T5[0:0] T47[0:0] T6[0:0] 
X	T48[0:0] T7[0:0] T8[0:0] T49[0:0] 
X	T9[0:0] T50[0:0] T10[0:0] T51[0:0] 
X	T11[0:0] T12[0:0] T52[0:0] T13[0:0] 
X	T53[0:0] ;
X      .successors 39 41 43 ;	#  predecessors 21 23 27 29 33 35 37 
X      .operation logic 12 ;
X        #	Expression 0
X        T42[0:0] = T41[0:0]' ;
X        T1[0:0] = T42[0:0] ;
X        M28[0:0] = T33[0:0] ;
X        M28[1:1] = T36[0:0] ;
X        M28[2:2] = T39[0:0] ;
X        T43[0:0] = V000_M28_0_2[0:0] ;
X        M29[0:0] = T34[0:0] ;
X        M29[1:1] = T37[0:0] ;
X        M29[2:2] = T40[0:0] ;
X        T44[0:0] = V000_M29_0_2[0:0] ;
X        T45[0:0] = (T43[0:0]  T44[0:0] );
X        T2[0:0] = T45[0:0] ;
X        T3[0:0] = T33[0:0] ;
X        T4[0:0] = T34[0:0] ;
X        T46[0:0] = T17[0:0]' ;
X        T5[0:0] = T37[0:0] ;
X        T47[0:0] = T18[0:0]' ;
X        T6[0:0] = T40[0:0] ;
X        T48[0:0] = T19[0:0]' ;
X        T7[0:0] = T36[0:0] ;
X        T8[0:0] = T34[0:0] ;
X        T49[0:0] = T20[0:0]' ;
X        T9[0:0] = T37[0:0] ;
X        T50[0:0] = T21[0:0]' ;
X        T10[0:0] = T40[0:0] ;
X        T51[0:0] = T22[0:0]' ;
X        T11[0:0] = T39[0:0] ;
X        T12[0:0] = T34[0:0] ;
X        T52[0:0] = T23[0:0]' ;
X        T13[0:0] = T37[0:0] ;
X        T53[0:0] = T24[0:0]' ;
X        V000_M29_0_2[0:0] = ((M29[0:0]'  M29[1:1]' ) M29[2:2]' );
X        V000_M28_0_2[0:0] = ((M28[0:0]'  M28[1:1]' ) M28[2:2]' );
X        .attribute delay 3 level;
X        .attribute area 43 literal;
X      .endoperation;
X    .endnode;
X
X    .node 39 operation;
X      .inputs T1[0:0] T24[0:0] T23[0:0] T22[0:0] 
X	T21[0:0] T20[0:0] T19[0:0] T18[0:0] 
X	T17[0:0] T3[0:0] T4[0:0] T46[0:0] 
X	T5[0:0] T47[0:0] T6[0:0] T48[0:0] 
X	T7[0:0] T8[0:0] T49[0:0] T9[0:0] 
X	T50[0:0] T10[0:0] T51[0:0] T11[0:0] 
X	T12[0:0] T52[0:0] T13[0:0] T53[0:0] 
X	;
X      .outputs M30[0:0] M30[1:1] M30[2:2] M30[3:3] 
X	M30[4:4] M30[5:5] M30[6:6] M30[7:7] 
X	;
X      .successors 40 ;	#  predecessors 38 
X      .operation logic 13 ;
X        #	Expression 0
X        M30[0:0] = X8[0:0] ;
X        M30[1:1] = X7[0:0] ;
X        M30[2:2] = X6[0:0] ;
X        M30[3:3] = X5[0:0] ;
X        M30[4:4] = X4[0:0] ;
X        M30[5:5] = X3[0:0] ;
X        M30[6:6] = X2[0:0] ;
X        M30[7:7] = X1[0:0] ;
X        X1[0:0] = ((V1_T1_0_0[0:0]  T24[0:0] )+(V0_T1_0_0[0:0]  X9[0:0] ));
X        X2[0:0] = ((V1_T1_0_0[0:0]  T23[0:0] )+(V0_T1_0_0[0:0]  X10[0:0] ));
X        X3[0:0] = ((V1_T1_0_0[0:0]  T22[0:0] )+(V0_T1_0_0[0:0]  X11[0:0] ));
X        X4[0:0] = ((V1_T1_0_0[0:0]  T21[0:0] )+(V0_T1_0_0[0:0]  X12[0:0] ));
X        X5[0:0] = ((V1_T1_0_0[0:0]  T20[0:0] )+(V0_T1_0_0[0:0]  X13[0:0] ));
X        X6[0:0] = ((V1_T1_0_0[0:0]  T19[0:0] )+(V0_T1_0_0[0:0]  X14[0:0] ));
X        X7[0:0] = ((V1_T1_0_0[0:0]  T18[0:0] )+(V0_T1_0_0[0:0]  X15[0:0] ));
X        X8[0:0] = ((V1_T1_0_0[0:0]  T17[0:0] )+(V0_T1_0_0[0:0]  X16[0:0] ));
X        X9[0:0] = ((V1_T3_0_0[0:0]  T24[0:0] )+(V0_T3_0_0[0:0]  X23[0:0] ));
X        X10[0:0] = ((V1_T3_0_0[0:0]  T23[0:0] )+(V0_T3_0_0[0:0]  X24[0:0] ));
X        X11[0:0] = ((V1_T3_0_0[0:0]  T22[0:0] )+(V0_T3_0_0[0:0]  X25[0:0] ));
X        X12[0:0] = ((V1_T3_0_0[0:0]  T21[0:0] )+(V0_T3_0_0[0:0]  X26[0:0] ));
X        X13[0:0] = ((V1_T3_0_0[0:0]  T20[0:0] )+(V0_T3_0_0[0:0]  X27[0:0] ));
X        X14[0:0] = ((V1_T3_0_0[0:0]  X17[0:0] )+(V0_T3_0_0[0:0]  T19[0:0] ));
X        X15[0:0] = ((V1_T3_0_0[0:0]  X18[0:0] )+(V0_T3_0_0[0:0]  T18[0:0] ));
X        X16[0:0] = ((V1_T3_0_0[0:0]  X19[0:0] )+(V0_T3_0_0[0:0]  T17[0:0] ));
X        X17[0:0] = ((V1_T4_0_0[0:0]  T19[0:0] )+(V0_T4_0_0[0:0]  X20[0:0] ));
X        X18[0:0] = ((V1_T4_0_0[0:0]  T18[0:0] )+(V0_T4_0_0[0:0]  X21[0:0] ));
X        X19[0:0] = ((V1_T4_0_0[0:0]  T46[0:0] )+(V0_T4_0_0[0:0]  T17[0:0] ));
X        X20[0:0] = ((V1_T5_0_0[0:0]  T19[0:0] )+(V0_T5_0_0[0:0]  X22[0:0] ));
X        X21[0:0] = ((V1_T5_0_0[0:0]  T47[0:0] )+(V0_T5_0_0[0:0]  T18[0:0] ));
X        X22[0:0] = ((V1_T6_0_0[0:0]  T48[0:0] )+(V0_T6_0_0[0:0]  T19[0:0] ));
X        X23[0:0] = ((V1_T7_0_0[0:0]  T24[0:0] )+(V0_T7_0_0[0:0]  X34[0:0] ));
X        X24[0:0] = ((V1_T7_0_0[0:0]  T23[0:0] )+(V0_T7_0_0[0:0]  X35[0:0] ));
X        X25[0:0] = ((V1_T7_0_0[0:0]  X28[0:0] )+(V0_T7_0_0[0:0]  T22[0:0] ));
X        X26[0:0] = ((V1_T7_0_0[0:0]  X29[0:0] )+(V0_T7_0_0[0:0]  T21[0:0] ));
X        X27[0:0] = ((V1_T7_0_0[0:0]  X30[0:0] )+(V0_T7_0_0[0:0]  T20[0:0] ));
X        X28[0:0] = ((V1_T8_0_0[0:0]  T22[0:0] )+(V0_T8_0_0[0:0]  X31[0:0] ));
X        X29[0:0] = ((V1_T8_0_0[0:0]  T21[0:0] )+(V0_T8_0_0[0:0]  X32[0:0] ));
X        X30[0:0] = ((V1_T8_0_0[0:0]  T49[0:0] )+(V0_T8_0_0[0:0]  T20[0:0] ));
X        X31[0:0] = ((V1_T9_0_0[0:0]  T22[0:0] )+(V0_T9_0_0[0:0]  X33[0:0] ));
X        X32[0:0] = ((V1_T9_0_0[0:0]  T50[0:0] )+(V0_T9_0_0[0:0]  T21[0:0] ));
X        X33[0:0] = ((V1_T10_0_0[0:0]  T51[0:0] )+(V0_T10_0_0[0:0]  T22[0:0] ));
X        X34[0:0] = ((V1_T11_0_0[0:0]  X36[0:0] )+(V0_T11_0_0[0:0]  T24[0:0] ));
X        X35[0:0] = ((V1_T11_0_0[0:0]  X37[0:0] )+(V0_T11_0_0[0:0]  T23[0:0] ));
X        X36[0:0] = ((V1_T12_0_0[0:0]  T24[0:0] )+(V0_T12_0_0[0:0]  X38[0:0] ));
X        X37[0:0] = ((V1_T12_0_0[0:0]  T52[0:0] )+(V0_T12_0_0[0:0]  T23[0:0] ));
X        X38[0:0] = ((V1_T13_0_0[0:0]  T53[0:0] )+(V0_T13_0_0[0:0]  T24[0:0] ));
X        V0_T13_0_0[0:0] = T13[0:0]' ;
X        V1_T13_0_0[0:0] = T13[0:0] ;
X        V0_T12_0_0[0:0] = T12[0:0]' ;
X        V1_T12_0_0[0:0] = T12[0:0] ;
X        V0_T11_0_0[0:0] = T11[0:0]' ;
X        V1_T11_0_0[0:0] = T11[0:0] ;
X        V0_T10_0_0[0:0] = T10[0:0]' ;
X        V1_T10_0_0[0:0] = T10[0:0] ;
X        V0_T9_0_0[0:0] = T9[0:0]' ;
X        V1_T9_0_0[0:0] = T9[0:0] ;
X        V0_T8_0_0[0:0] = T8[0:0]' ;
X        V1_T8_0_0[0:0] = T8[0:0] ;
X        V0_T7_0_0[0:0] = T7[0:0]' ;
X        V1_T7_0_0[0:0] = T7[0:0] ;
X        V0_T6_0_0[0:0] = T6[0:0]' ;
X        V1_T6_0_0[0:0] = T6[0:0] ;
X        V0_T5_0_0[0:0] = T5[0:0]' ;
X        V1_T5_0_0[0:0] = T5[0:0] ;
X        V0_T4_0_0[0:0] = T4[0:0]' ;
X        V1_T4_0_0[0:0] = T4[0:0] ;
X        V0_T3_0_0[0:0] = T3[0:0]' ;
X        V1_T3_0_0[0:0] = T3[0:0] ;
X        V0_T1_0_0[0:0] = T1[0:0]' ;
X        V1_T1_0_0[0:0] = T1[0:0] ;
X        .attribute delay 12 level;
X        .attribute area 298 literal;
X      .endoperation;
X    .endnode;
X
X    .node 40 operation;
X      .inputs M30[0:7] ;
X      .outputs data_out[0:7] ;
X      .successors 45 ;	#  predecessors 39 
X      .attribute constraint delay 40 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 41 operation;
X      .inputs T1[0:0] T2[0:0] ;
X      .outputs M31[0:0] M31[1:1] ;
X      .successors 42 ;	#  predecessors 38 
X      .operation logic 14 ;
X        #	Expression 0
X        M31[0:0] = X40[0:0] ;
X        M31[1:1] = X39[0:0] ;
X        X39[0:0] = ((V1_T1_0_0[0:0]  X41[0:0] )+ 0 );
X        X40[0:0] = ((V1_T1_0_0[0:0]  X41[0:0] )+V0_T1_0_0[0:0] );
X        X41[0:0] = ( 0 +V0_T2_0_0[0:0] );
X        V0_T2_0_0[0:0] = T2[0:0]' ;
X        V0_T1_0_0[0:0] = T1[0:0]' ;
X        V1_T1_0_0[0:0] = T1[0:0] ;
X        .attribute delay 3 level;
X        .attribute area 18 literal;
X      .endoperation;
X    .endnode;
X
X    .node 42 operation;
X      .inputs M31[0:1] ;
X      .outputs err[0:1] ;
X      .successors 45 ;	#  predecessors 41 
X      .attribute constraint delay 42 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 43 operation;
X      .inputs 0b1 ;
X      .outputs out_ready[0:0] ;
X      .successors 44 ;	#  predecessors 38 
X      .attribute constraint delay 43 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 44 operation;
X      .inputs 0b0 ;
X      .outputs out_ready[0:0] ;
X      .successors 45 ;	#  predecessors 43 
X      .attribute constraint delay 44 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 45 nop;	#	sink node
X      .successors ;	#  predecessors 40 42 44 
X    .endnode;
X
X    .endpolargraph;
X.endmodel decode ;
END_OF_FILE
if test 20578 -ne `wc -c <'ecc/decode.sif'`; then
    echo shar: \"'ecc/decode.sif'\" unpacked with wrong size!
fi
# end of 'ecc/decode.sif'
fi
if test -f 'ecc/ecc.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/ecc.sif'\"
else
echo shar: Extracting \"'ecc/ecc.sif'\" \(517 characters\)
sed "s/^X//" >'ecc/ecc.sif' <<'END_OF_FILE'
X#
X#	Sif model ecc	Printed Tue Jul 24 15:06:36 1990
X#
X.model ecc structure; 
X  .inputs port new_data port data_in[8] port error ;
X  .outputs port data_out[8] port detected_error[2] port encoder_out port decoder_in 
X	port data_ready port out_ready ;
X  .call encode (data_in[0:7] new_data[0:0] ; ; encoder_out[0:0] data_ready[0:0] );
X  .call noise (error[0:0] encoder_out[0:0] ; ; decoder_in[0:0] );
X  .call decode (decoder_in[0:0] data_ready[0:0] ; ; data_out[0:7] detected_error[0:1] out_ready[0:0] );
X.endmodel ecc ;
END_OF_FILE
if test 517 -ne `wc -c <'ecc/ecc.sif'`; then
    echo shar: \"'ecc/ecc.sif'\" unpacked with wrong size!
fi
# end of 'ecc/ecc.sif'
fi
if test -f 'ecc/encode.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/encode.sif'\"
else
echo shar: Extracting \"'ecc/encode.sif'\" \(11304 characters\)
sed "s/^X//" >'ecc/encode.sif' <<'END_OF_FILE'
X#
X#	Sif model encode	Printed Tue Jul 24 15:06:41 1990
X#
X.model encode sequencing process; 
X  .inputs port data_in[8] port new_data ;
X  .outputs port encoder_out port data_ready ;
X    #	Index 1
X    .polargraph 1 39;
X    .variable T13 T12 T9 T6 
X	T11 T8 T5 M16[4] 
X	T10 M13[3] M11[3] M10[4] 
X	T7 M7[3] M5[4] M2[3] 
X	T4[8] T3 T1 ;
X    #	39 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs new_data[0:0] ;
X      .outputs T1[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        T1[0:0] = new_data[0:0]' ;
X        .attribute delay 0 level;
X        .attribute area 1 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 cond;
X      .successors 4 ;	#  predecessors 2 
X      .cond T1[0:0] ;	#	Latched
X      .case 1 ;
X        #	Index 2
X        .polargraph 1 3;
X        #	3 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 loop;
X          .successors 3 ;	#  predecessors 1 
X          .loop T3[0:0] ;	#	
X            #	Index 3
X            .polargraph 1 3;
X            #	3 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 operation;
X              .inputs new_data[0:0] ;
X              .outputs T3[0:0] ;
X              .successors 3 ;	#  predecessors 1 
X              .operation logic 2 ;
X                #	Expression 0
X                T2[0:0] = new_data[0:0]' ;
X                T3[0:0] = T2[0:0]' ;
X                .attribute delay 0 level;
X                .attribute area 2 literal;
X              .endoperation;
X            .endnode;
X
X            .node 3 nop;	#	sink node
X              .successors ;	#  predecessors 2 
X            .endnode;
X
X            .endpolargraph;
X          .endloop;
X        .endnode;
X
X        .node 3 nop;	#	sink node
X          .successors ;	#  predecessors 2 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .case 0 ;
X        #	Index 4
X        .polargraph 1 2;
X        #	2 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 nop;	#	sink node
X          .successors ;	#  predecessors 1 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .endcond;
X    .endnode;
X
X    .node 4 operation;
X      .inputs data_in[0:7] ;
X      .outputs T4[0:7] ;
X      .successors 5 6 8 10 11 15 17 ;	#  predecessors 3 
X      .attribute constraint delay 4 1 cycles;
X      .operation read;
X    .endnode;
X
X    .node 5 proc;
X      .inputs T4[0:2] ;
X      .outputs T5[0:0] ;
X      .successors 21 23 ;	#  predecessors 4 
X      .proc ENCODER with (3);
X    .endnode;
X
X    .node 6 operation;
X      .inputs T4[0:0] T4[3:3] T4[6:6] ;
X      .outputs M2[0:0] M2[1:1] M2[2:2] ;
X      .successors 7 ;	#  predecessors 4 
X      .operation logic 3 ;
X        #	Expression 0
X        M1[0:0] = T4[0:0] ;
X        M1[1:1] = T4[3:3] ;
X        M2[0:0] = M1[0:0] ;
X        M2[1:1] = M1[1:1] ;
X        M2[2:2] = T4[6:6] ;
X        .attribute delay 0 level;
X        .attribute area 5 literal;
X      .endoperation;
X    .endnode;
X
X    .node 7 proc;
X      .inputs M2[0:2] ;
X      .outputs T6[0:0] ;
X      .successors 21 23 ;	#  predecessors 6 
X      .proc ENCODER with (3);
X    .endnode;
X
X    .node 8 operation;
X      .inputs T4[0:0] T4[1:1] T4[2:2] ;
X      .outputs M5[0:0] M5[1:1] M5[2:2] M5[3:3] 
X	;
X      .successors 9 ;	#  predecessors 4 
X      .operation logic 4 ;
X        #	Expression 0
X        M3[0:0] =  0 ;
X        M3[1:1] = T4[0:0] ;
X        M4[0:0] = M3[0:0] ;
X        M4[1:1] = M3[1:1] ;
X        M4[2:2] = T4[1:1] ;
X        M5[0:0] = M4[0:0] ;
X        M5[1:1] = M4[1:1] ;
X        M5[2:2] = M4[2:2] ;
X        M5[3:3] = T4[2:2] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 9 proc;
X      .inputs M5[0:3] ;
X      .outputs T7[0:0] ;
X      .successors 13 ;	#  predecessors 8 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 10 proc;
X      .inputs T4[3:5] ;
X      .outputs T8[0:0] ;
X      .successors 21 23 ;	#  predecessors 4 
X      .proc ENCODER with (3);
X    .endnode;
X
X    .node 11 operation;
X      .inputs T4[1:1] T4[4:4] T4[7:7] ;
X      .outputs M7[0:0] M7[1:1] M7[2:2] ;
X      .successors 12 ;	#  predecessors 4 
X      .operation logic 5 ;
X        #	Expression 0
X        M6[0:0] = T4[1:1] ;
X        M6[1:1] = T4[4:4] ;
X        M7[0:0] = M6[0:0] ;
X        M7[1:1] = M6[1:1] ;
X        M7[2:2] = T4[7:7] ;
X        .attribute delay 0 level;
X        .attribute area 5 literal;
X      .endoperation;
X    .endnode;
X
X    .node 12 proc;
X      .inputs M7[0:2] ;
X      .outputs T9[0:0] ;
X      .successors 21 23 ;	#  predecessors 11 
X      .proc ENCODER with (3);
X    .endnode;
X
X    .node 13 operation;
X      .inputs T7[0:0] T4[3:3] T4[4:4] T4[5:5] 
X	;
X      .outputs M10[0:0] M10[1:1] M10[2:2] M10[3:3] 
X	;
X      .successors 14 ;	#  predecessors 9 
X      .operation logic 6 ;
X        #	Expression 0
X        M8[0:0] = T7[0:0] ;
X        M8[1:1] = T4[3:3] ;
X        M9[0:0] = M8[0:0] ;
X        M9[1:1] = M8[1:1] ;
X        M9[2:2] = T4[4:4] ;
X        M10[0:0] = M9[0:0] ;
X        M10[1:1] = M9[1:1] ;
X        M10[2:2] = M9[2:2] ;
X        M10[3:3] = T4[5:5] ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 14 proc;
X      .inputs M10[0:3] ;
X      .outputs T10[0:0] ;
X      .successors 19 ;	#  predecessors 13 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 15 operation;
X      .inputs T4[6:6] T4[7:7] ;
X      .outputs M11[0:0] M11[1:1] M11[2:2] ;
X      .successors 16 ;	#  predecessors 4 
X      .operation logic 7 ;
X        #	Expression 0
X        M11[0:0] = T4[6:6] ;
X        M11[1:1] = T4[7:7] ;
X        M11[2:2] =  0 ;
X        .attribute delay 0 level;
X        .attribute area 3 literal;
X      .endoperation;
X    .endnode;
X
X    .node 16 proc;
X      .inputs M11[0:2] ;
X      .outputs T11[0:0] ;
X      .successors 21 23 ;	#  predecessors 15 
X      .proc ENCODER with (3);
X    .endnode;
X
X    .node 17 operation;
X      .inputs T4[2:2] T4[5:5] ;
X      .outputs M13[0:0] M13[1:1] M13[2:2] ;
X      .successors 18 ;	#  predecessors 4 
X      .operation logic 8 ;
X        #	Expression 0
X        M12[0:0] = T4[2:2] ;
X        M12[1:1] = T4[5:5] ;
X        M13[0:0] = M12[0:0] ;
X        M13[1:1] = M12[1:1] ;
X        M13[2:2] =  0 ;
X        .attribute delay 0 level;
X        .attribute area 5 literal;
X      .endoperation;
X    .endnode;
X
X    .node 18 proc;
X      .inputs M13[0:2] ;
X      .outputs T12[0:0] ;
X      .successors 21 23 ;	#  predecessors 17 
X      .proc ENCODER with (3);
X    .endnode;
X
X    .node 19 operation;
X      .inputs T10[0:0] T4[6:6] T4[7:7] ;
X      .outputs M16[0:0] M16[1:1] M16[2:2] M16[3:3] 
X	;
X      .successors 20 ;	#  predecessors 14 
X      .operation logic 9 ;
X        #	Expression 0
X        M14[0:0] = T10[0:0] ;
X        M14[1:1] = T4[6:6] ;
X        M15[0:0] = M14[0:0] ;
X        M15[1:1] = M14[1:1] ;
X        M15[2:2] = T4[7:7] ;
X        M16[0:0] = M15[0:0] ;
X        M16[1:1] = M15[1:1] ;
X        M16[2:2] = M15[2:2] ;
X        M16[3:3] =  0 ;
X        .attribute delay 0 level;
X        .attribute area 9 literal;
X      .endoperation;
X    .endnode;
X
X    .node 20 proc;
X      .inputs M16[0:3] ;
X      .outputs T13[0:0] ;
X      .successors 21 23 ;	#  predecessors 19 
X      .proc ENCODER with (4);
X    .endnode;
X
X    .node 21 operation;
X      .inputs 0b1 ;
X      .outputs data_ready[0:0] ;
X      .successors 22 ;	#  predecessors 5 7 10 12 16 18 20 
X      .attribute constraint delay 21 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 22 operation;
X      .inputs 0b0 ;
X      .outputs data_ready[0:0] ;
X      .successors 39 ;	#  predecessors 21 
X      .attribute constraint delay 22 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 23 operation;
X      .inputs T4[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 24 ;	#  predecessors 5 7 10 12 16 18 20 
X      .attribute constraint delay 23 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 24 operation;
X      .inputs T4[1:1] ;
X      .outputs encoder_out[0:0] ;
X      .successors 25 ;	#  predecessors 23 
X      .attribute constraint delay 24 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 25 operation;
X      .inputs T4[2:2] ;
X      .outputs encoder_out[0:0] ;
X      .successors 26 ;	#  predecessors 24 
X      .attribute constraint delay 25 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 26 operation;
X      .inputs T4[3:3] ;
X      .outputs encoder_out[0:0] ;
X      .successors 27 ;	#  predecessors 25 
X      .attribute constraint delay 26 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 27 operation;
X      .inputs T4[4:4] ;
X      .outputs encoder_out[0:0] ;
X      .successors 28 ;	#  predecessors 26 
X      .attribute constraint delay 27 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 28 operation;
X      .inputs T4[5:5] ;
X      .outputs encoder_out[0:0] ;
X      .successors 29 ;	#  predecessors 27 
X      .attribute constraint delay 28 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 29 operation;
X      .inputs T4[6:6] ;
X      .outputs encoder_out[0:0] ;
X      .successors 30 ;	#  predecessors 28 
X      .attribute constraint delay 29 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 30 operation;
X      .inputs T4[7:7] ;
X      .outputs encoder_out[0:0] ;
X      .successors 31 ;	#  predecessors 29 
X      .attribute constraint delay 30 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 31 operation;
X      .inputs 0b0 ;
X      .outputs encoder_out[0:0] ;
X      .successors 32 ;	#  predecessors 30 
X      .attribute constraint delay 31 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 32 operation;
X      .inputs T5[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 33 ;	#  predecessors 31 
X      .attribute constraint delay 32 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 33 operation;
X      .inputs T8[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 34 ;	#  predecessors 32 
X      .attribute constraint delay 33 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 34 operation;
X      .inputs T11[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 35 ;	#  predecessors 33 
X      .attribute constraint delay 34 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 35 operation;
X      .inputs T6[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 36 ;	#  predecessors 34 
X      .attribute constraint delay 35 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 36 operation;
X      .inputs T9[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 37 ;	#  predecessors 35 
X      .attribute constraint delay 36 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 37 operation;
X      .inputs T12[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 38 ;	#  predecessors 36 
X      .attribute constraint delay 37 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 38 operation;
X      .inputs T13[0:0] ;
X      .outputs encoder_out[0:0] ;
X      .successors 39 ;	#  predecessors 37 
X      .attribute constraint delay 38 1 cycles;
X      .operation write;
X    .endnode;
X
X    .node 39 nop;	#	sink node
X      .successors ;	#  predecessors 22 38 
X    .endnode;
X
X    .endpolargraph;
X.endmodel encode ;
END_OF_FILE
if test 11304 -ne `wc -c <'ecc/encode.sif'`; then
    echo shar: \"'ecc/encode.sif'\" unpacked with wrong size!
fi
# end of 'ecc/encode.sif'
fi
if test -f 'ecc/noise.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/noise.sif'\"
else
echo shar: Extracting \"'ecc/noise.sif'\" \(855 characters\)
sed "s/^X//" >'ecc/noise.sif' <<'END_OF_FILE'
X#
X#	Sif model noise	Printed Tue Jul 24 15:06:12 1990
X#
X.model noise sequencing process; 
X  .inputs port error port encoder_out ;
X  .outputs port decoder_in ;
X    #	Index 1
X    .polargraph 1 3;
X    .variable T1 ;
X    #	3 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 operation;
X      .inputs encoder_out[0:0] error[0:0] ;
X      .outputs T1[0:0] ;
X      .successors 3 ;	#  predecessors 1 
X      .operation logic 1 ;
X        #	Expression 0
X        T1[0:0] = ((encoder_out[0:0]  error[0:0]' )+(encoder_out[0:0]'  error[0:0] ));
X        .attribute delay 2 level;
X        .attribute area 7 literal;
X      .endoperation;
X    .endnode;
X
X    .node 3 nop;	#	sink node
X      .successors ;	#  predecessors 2 
X    .endnode;
X
X    .attribute hercules direct_connect decoder_in[0:0] T1[0:0] ;
X    .endpolargraph;
X.endmodel noise ;
END_OF_FILE
if test 855 -ne `wc -c <'ecc/noise.sif'`; then
    echo shar: \"'ecc/noise.sif'\" unpacked with wrong size!
fi
# end of 'ecc/noise.sif'
fi
if test -f 'ecc/ecc.out.gold' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'ecc/ecc.out.gold'\"
else
echo shar: Extracting \"'ecc/ecc.out.gold'\" \(1858 characters\)
sed "s/^X//" >'ecc/ecc.out.gold' <<'END_OF_FILE'
X24 ariadne extract
Xnew_data[0:0]
Xerror[0:0]
Xdetected_error[0:0]
Xdetected_error[1:1]
XHEX data_in0 data_in[0:0] data_in[1:1] data_in[2:2] data_in[3:3]
XHEX data_in1 data_in[4:4] data_in[5:5] data_in[6:6] data_in[7:7]
XHEX data_out0 data_out[0:0] data_out[1:1] data_out[2:2] data_out[3:3]
XHEX data_out1 data_out[4:4] data_out[5:5] data_out[6:6] data_out[7:7]
Xencoder_out[0:0]
Xdecoder_in[0:0]
Xdata_ready[0:0]
Xout_ready[0:0]
X     0:001111111111110001100000
X     1:011100000000110001100100
X     2:001100000000110001100000
X     4:101110000100110001100000
X     5:001100000000110001101110
X     6:001100000000110001100000
X    10:001100000000110001101100
X    11:001100000000110001100000
X    14:001100000000110001101100
X    16:001100000000110001100000
X    17:001100000000110001101100
X    18:001100000000110001100000
X    19:001100000000110001101100
X    20:001100000000110001100000
X    21:000000000000100001000001
X    22:000000000000100001000000
X    43:100011000010100001000000
X    44:000000000000100001001110
X    45:000000000000100001001100
X    46:000000000000100001000000
X    50:000000000000100001001100
X    51:010000000000100001000100
X    52:000000000000100001000000
X    55:000000000000100001001100
X    56:000000000000100001000000
X    57:000000000000100001001100
X    58:000000000000100001000000
X    59:000000000000100001001100
X    60:001000000000110000101101
X    61:001000000000110000101100
X    87:101010100110110000101100
X    88:001000000000110000101110
X    89:011000000000110000100100
X    90:011000000000110000101000
X    91:001000000000110000100000
X    93:001000000000110000101100
X    95:001000000000110000100000
X    98:001000000000110000101100
X   100:001000000000110000100000
X   104:001100000000110001100001
X   105:001100000000110001100000
X   118:011100000000110001100100
X   120:001100000000110001100000
X   127:011100000000110001100100
X   128:001100000000110001100000
END_OF_FILE
if test 1858 -ne `wc -c <'ecc/ecc.out.gold'`; then
    echo shar: \"'ecc/ecc.out.gold'\" unpacked with wrong size!
fi
# end of 'ecc/ecc.out.gold'
fi
echo shar: End of shell archive.
exit 0


