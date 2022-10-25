
#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of shell archive."
# Contents:  daio_phase_decoder/daio_phase_decoder.hc
#   daio_phase_decoder/daio_phase_decoder.pat
#   daio_phase_decoder/daio_phase_decoder.mon
#   daio_phase_decoder/daio_phase_decoder.sif
#   daio_phase_decoder/daio_phase_decoder.out.gold
# Wrapped by synthesis@sirius on Thu Jul 26 17:14:16 1990
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'daio_phase_decoder/daio_phase_decoder.hc' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'daio_phase_decoder/daio_phase_decoder.hc'\"
else
echo shar: Extracting \"'daio_phase_decoder/daio_phase_decoder.hc'\" \(10216 characters\)
sed "s/^X//" >'daio_phase_decoder/daio_phase_decoder.hc' <<'END_OF_FILE'
X/*
X *  Author:   Thomas Truong
X *  Revised:  1990-05-02
X *  Comment:  Updated for new HardwareC
X */
X
X/*
X *  get_error - get the error for synchronization
X */
Xget_error(violation,data_bits,carrier_loss,preamble_1,preamble_2,preamble_3)
X    in boolean violation[4], data_bits[4];
X    out boolean carrier_loss, preamble_1, preamble_2, preamble_3;
X{
X    /*
X     *  original values
X     */
X    carrier_loss = 0;
X    preamble_1 = 0;
X    preamble_2 = 0;
X    preamble_3 = 0;
X    /*
X     *  check for preambles
X     */
X    if ( violation[1:3]==0b111 )
X      carrier_loss = 1;
X    if ( (violation==0b1010) & (data_bits==0b0110) )
X      preamble_1 = 1;
X    if ( (violation==0b1100) & (data_bits==0b0101) )
X      preamble_2 = 1;
X    if ( (violation==0b1100) & (data_bits==0b0110) )
X      preamble_3 = 1;
X    /* write carrier_loss, preamble_1, preamble_2, preamble_3; */
X} 
X   
X/*
X *  Main Process phase_decoder()
X *  - monitors the biphase coded data stream 'data' from audio device
X *  - extracts synchronization signals: 'preamble_1', 'preamble_2', 'preamble_3'
X *  - derives signals: 'bit_value', 'bit_clock', 'carrier_loss', and
X *    	'biphase_violation' (if the incoming data stream is corrupted.)
X *
X *  Inputs:
X *	data		   : external analog signal.
X *	reset		   : global reset.
X *
X *  Outputs:
X *      bit_value	   : extracted bit.
X *	bit_clock	   : extracted clock.
X *      preamble_1	   : start of block.
X *	preamble_2	   : start of subframe_A.
X *	preamble_3	   : start of subframe_B.
X *      carrier_loss	   : too many violations --> lost carrier.
X *      biphase_violation  : no transition between bits.
X *      edge               : edge is been detected.
X *      save_edge          : edge was detected.
X *
X *  The value of the bit is determined by using an up-down counter with
X *  each sample.  On a sampled "1", increment the counter; on a sampled
X *  "0", decrement the counter.  The bit value is based on the final
X *  counter value after 10 samples.
X *    0 : if counter value is between 6 and 10 (+- 6)
X *    1 : otherwise
X *    
X *  The tough part is to detect biphase violations.
X *
X *  According to the AES standard, the transitions MUST occur within 20ns 
X *  of the nominal position and the MINIMNUM sample period is 32.6ns 
X *  (corresponding to a sampling frequency of 48kHz).  Therefore, we only 
X *  have to check within one sample to find a legal edge; otherwise, it's
X *  illegal.  For the case where the edge occurs in the next bit period
X *  (after 10 samples) we have 2 choices:
X * 
X *    1) We can assume that we do in fact have a biphase violation.  Thus,
X *	 to maintain full accuracy we should start counting samples for the
X *	 next bit right away.
X *    2) We can assume that we don't have a biphase violation and that the
X *	 transition will occur in the next sample.  In this case we would 
X *       rather start counting from after the edge, so that the contribution
X *       from the transition does not introduce noise into the evaluation of 
X *       the bit.
X *  	
X *  We choose to implement the design based on assumption 2).
X *
X *  Other implementation issues:
X *    This scheme does not suppress noise very well.  However, under
X *    normal conditions, we can withstand up to 2 shots (of duration
X *    equal one sampling period) of noise without getting a wrong answer.
X *    A smarter noise suppression circuitry should look for noise shots
X *    outside valid transition regions and ignore them once detected.
X */
X
X/* 
X *  Check to see if we have finished collecting data in sampling window.
X *  We are done if any of the following occur:
X *
X *    1) We see a transition (edge) near the right end of the window.  
X *       In case of jitter, we will allow any transition within 2 samples
X *	 of the right edge of window to be valid.
X *    2) If we have already seen OVERSAMPLE bits then we should reset the
X *	 counters.  While decoding the first couple of samples for the next 
X *       bit we will look for a transition corresponding to the previous bit.
X *       If we don't find an edge, then we have a biphase violation.
X */
X
X/*  
X *  We assign bit value based on counter value only when we have looked at
X *  the entire window and are about to reset control for the next bit.  
X *  Since we reset at 0 and we can only see a maximum of 10 bits, then a 
X *  valid '1' occurs if levelcount is +-5 from 0 (i.e. from 11 to 5).  
X *  Otherwise, it is a '0'.
X */
X
Xprocess phase_decoder(data, reset, bit_value, bit_clock, 
X		      preamble_1, preamble_2, preamble_3, 
X		      carrier_loss, biphase_violation, edge, save_edge)
X
X   in port data;                /* analog input signal */
X   in port reset;               /* global reset control */
X
X   out port bit_value;          /* extracted bit value */
X   out port bit_clock;          /* derived bit clock */
X   out port preamble_1;         /* start of block */
X   out port preamble_2;         /* start of subframe_A */
X   out port preamble_3;         /* start of subframe_B */
X   out port carrier_loss;       /* too many biphase violations */
X   out port biphase_violation;  /* no transition at end of bit */
X   out port edge, save_edge;    /* internal probes */
X
X{
X   static data_bits[4];    /* stores last 4 data bits */
X   static violation[4];    /* stores last 4 biphase violations */
X   static window_ctr[4];   /* counts position within the window */
X   static bit_counter[4];  /* counts up/down based on samples */
X
X   static int_bit_value, int_bit_clock;
X   static int_preamble_1, int_preamble_2, int_preamble_3;
X   static int_carrier_loss, int_biphase_violation;
X   static int_edge, int_save_edge;
X
X   boolean sample;
X
X   /*
X    *  monitor outputs of static variables
X    */
X
X   if ( reset )
X   {
X      /* 
X       *  reset all internal variables 
X       */
X
X      < 
X	write bit_value=0; 
X        write bit_clock=0; 
X        write preamble_1=0; 
X        write preamble_2=0; 
X        write preamble_3=0;
X        write carrier_loss=0; 
X        write biphase_violation=0; 
X        write edge=0; 
X        write save_edge=0; 
X      >
X   
X   }
X   else
X   [
X      /* 
X       *  wait for the first transition
X       */
X      int_edge = 1;
X      sample = read(data);
X      while ( sample == data )
X        ;
X
X      /* 
X       *  continue sampling until reset 
X       */
X      while ( !reset )
X      [
X         /* 
X          *  start counting samples within window after first transition 
X          */
X         switch ( window_ctr ) 
X         {
X            case 0:  /* edge normally occurs here */
X           	     if ( int_edge )
X                     [
X                        int_save_edge = 1;
X    			violation = violation << 1;
X    			data_bits = data_bits << 1;
X    			if ( (bit_counter==6) | 
X			     (bit_counter==7) |
X			     (bit_counter==8) | 
X			     (bit_counter==9) |
X			     (bit_counter==10) )
X			  int_bit_value = 0;
X			else
X   			{
X			   int_bit_value = 1;
X    			   data_bits[0:0] = 1;
X		        }
X    			bit_counter = 0;
X                     ]
X                     break;
X            case 1:  /* check for late edge */ 
X                     if ( int_save_edge )
X 		     {
X                        int_biphase_violation = 0;
X                        int_save_edge = 0;
X		     }
X                     else
X		     [
X  		        int_biphase_violation = !int_edge;
X                        int_save_edge = int_edge;
X    			violation = violation << 1;
X    			violation[0:0] = !int_edge;
X    			data_bits = data_bits << 1;
X   			if ( sample )
X			[
X    			   if ( (bit_counter==7) | 
X				(bit_counter==8) |
X				(bit_counter==9) | 
X				(bit_counter==10) |
X				(bit_counter==11) )
X		             int_bit_value = 0;
X			   else
X   			   {
X			      int_bit_value = 1;
X    			      data_bits[0:0] = 1;
X		           }
X			   bit_counter = 1;
X			]
X			else
X			[
X    			   if ( (bit_counter==5) | 
X				(bit_counter==6) |
X				(bit_counter==7) | 
X				(bit_counter==8) |
X				(bit_counter==9) )
X		             int_bit_value = 0;
X			   else
X   			   {
X			      int_bit_value = 1;
X    			      data_bits[0:0] = 1;
X		           }
X			   bit_counter = 15;
X			]
X		   	if ( int_edge )
X			{
X			   bit_counter = 0;
X			   window_ctr = 0;
X		        }
X		     ]
X                     break;
X  	    case 2:  /* check for biphase violation and preamble */
X                     get_error(violation, data_bits, int_carrier_loss,
X		       int_preamble_1,int_preamble_2,int_preamble_3);
X		     break;
X            case 4:  /* raise bit_clock */
X                     int_bit_clock = 1;
X		     /* check for out-of-phase and try to resync */
X		     if ( int_carrier_loss )
X		     {
X			int_carrier_loss = 0;
X			int_bit_clock = 0;
X		    	window_ctr = 9;
X		     }
X                     break;
X            case 9:  /* lower bit_clock */
X		     int_bit_clock = 0;
X		     /* check for early edge */
X                     if ( int_edge )
X		     [
X                        int_save_edge = 1;
X    			violation = violation << 1;
X    			data_bits = data_bits << 1;
X    			if ( (bit_counter==6) | 
X			     (bit_counter==7) |
X			     (bit_counter==8) | 
X			     (bit_counter==9) |
X			     (bit_counter==10) )
X		          int_bit_value = 0;
X			else
X			{
X		 	   int_bit_value = 1;
X    			   data_bits[0:0] = 1;
X			}
X			bit_counter = 0;
X                        window_ctr = 0;  
X                     ]
X                     break;
X            default:
X                     break;
X         } /* end switch ( window_ctr ) */
X                   
X         int_edge = (sample != data);   /* check for edge transition */
X
X         sample = data;  		/* sample new data */
X  	 window_ctr++; 	    		/* advance window position */
X         if ( window_ctr==10 )
X	   window_ctr = 0;
X  	 if ( sample ) 	    		/* update counter based on sample */
X	   bit_counter++; 
X 	 else 
X	   bit_counter--;
X
X         < 
X	   write bit_value=int_bit_value; 
X           write bit_clock=int_bit_clock; 
X           write preamble_1=int_preamble_1; 
X           write preamble_2=int_preamble_2; 
X           write preamble_3=int_preamble_3;
X           write carrier_loss=int_carrier_loss; 
X           write biphase_violation=int_biphase_violation; 
X           write edge=int_edge; 
X           write save_edge=int_save_edge; 
X         >
X   
X      ] /* end while ( !reset ) */
X  
X   ] /* end else if ( !reset ) */
X
X}
END_OF_FILE
if test 10216 -ne `wc -c <'daio_phase_decoder/daio_phase_decoder.hc'`; then
    echo shar: \"'daio_phase_decoder/daio_phase_decoder.hc'\" unpacked with wrong size!
fi
# end of 'daio_phase_decoder/daio_phase_decoder.hc'
fi
if test -f 'daio_phase_decoder/daio_phase_decoder.pat' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'daio_phase_decoder/daio_phase_decoder.pat'\"
else
echo shar: Extracting \"'daio_phase_decoder/daio_phase_decoder.pat'\" \(3146 characters\)
sed "s/^X//" >'daio_phase_decoder/daio_phase_decoder.pat' <<'END_OF_FILE'
X# Test input patterns for phase_decoder
X.inputs enable clock data reset ;
X# system restart
X0100 ;
X0100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 1, 10 pulses
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 1, 9 pulses
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 1, 11 pulses
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# throw in sync_1 (11)(10)(10)(00)
X# start of 0
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X# start of 1 with violation
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 1 with no violation
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 0 with violation
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# end of sync_one
X# start of 0, 10 pulses
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X# start of 0, 11 pulses
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# throw in a sync_two (11)(10)(00)(10)
X# start of 0 no violation
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X# start of 1 with violation
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 0 with violation
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 1 no violation
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# end of sync_two
X# start of 1, 8 pulses
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X#start of 1, 10 pulses
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of 0 with spike
X1110 ;
X1110 ;
X1110 ;
X# spike
X1100 ;
X# spike
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X# start of 1 with spike
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X# enough
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# do a sync3 (11)(10)(01)(00)
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X# start of (10)
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# start of (01)
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X# start of (00)
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# end of sync3
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X# do a carrier loss
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# kill line here
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# first violation
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# second violation
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# third violation
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# fourth violation
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X1100 ;
X# do a noise spike
X# should see a sync1 now 
X# send in a 0 - add jitter of 1 bit and noise of 2 bits
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X1110 ;
X1110 ;
X# should see a 0, send in a 0, and add two noise spikes
X1100 ;
X1100 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1110 ;
X1100 ;
X1100 ;
X# should see a 0
END_OF_FILE
if test 3146 -ne `wc -c <'daio_phase_decoder/daio_phase_decoder.pat'`; then
    echo shar: \"'daio_phase_decoder/daio_phase_decoder.pat'\" unpacked with wrong size!
fi
# end of 'daio_phase_decoder/daio_phase_decoder.pat'
fi
if test -f 'daio_phase_decoder/daio_phase_decoder.mon' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'daio_phase_decoder/daio_phase_decoder.mon'\"
else
echo shar: Extracting \"'daio_phase_decoder/daio_phase_decoder.mon'\" \(429 characters\)
sed "s/^X//" >'daio_phase_decoder/daio_phase_decoder.mon' <<'END_OF_FILE'
Xdata[0:0]
Xreset[0:0]
Xbit_value[0:0]
Xbit_clock[0:0]
Xpreamble_1[0:0]
Xpreamble_2[0:0]
Xpreamble_3[0:0]
Xcarrier_loss[0:0]
Xbiphase_violation[0:0]
Xedge[0:0]
Xsave_edge[0:0]
Xsample[0:0]
Xbit_counter[0:0]
Xbit_counter[1:1]
Xbit_counter[2:2]
Xbit_counter[3:3]
Xwindow_ctr[0:0]
Xwindow_ctr[1:1]
Xwindow_ctr[2:2]
Xwindow_ctr[3:3]
Xviolation[0:0]
Xviolation[1:1]
Xviolation[2:2]
Xviolation[3:3]
Xdata_bits[0:0]
Xdata_bits[1:1]
Xdata_bits[2:2]
Xdata_bits[3:3]
END_OF_FILE
if test 429 -ne `wc -c <'daio_phase_decoder/daio_phase_decoder.mon'`; then
    echo shar: \"'daio_phase_decoder/daio_phase_decoder.mon'\" unpacked with wrong size!
fi
# end of 'daio_phase_decoder/daio_phase_decoder.mon'
fi
if test -f 'daio_phase_decoder/daio_phase_decoder.sif' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'daio_phase_decoder/daio_phase_decoder.sif'\"
else
echo shar: Extracting \"'daio_phase_decoder/daio_phase_decoder.sif'\" \(58790 characters\)
sed "s/^X//" >'daio_phase_decoder/daio_phase_decoder.sif' <<'END_OF_FILE'
X#
X#	Sif model phase_decoder	Printed Wed Jul 25 14:06:08 1990
X#
X.model phase_decoder sequencing process; 
X  .inputs port data port reset ;
X  .outputs port bit_value port bit_clock port preamble_1 port preamble_2 
X	port preamble_3 port carrier_loss port biphase_violation port edge 
X	port save_edge ;
X    #	Index 1
X    .polargraph 1 5;
X    .variable X112 X111 X110 X109 
X	X108 X107 X106 X105 
X	X75 X74 X73 X72 
X	X71 X70 X69 X68 
X	X113 T75[5] T74[5] T73 
X	T71 X64 T69 X62 
X	X59 X57 X55 X53 
X	X51 X42 T47 T12 
X	T15 T14 T13 T19 
X	T50 T49 T18 T17 
X	T48 T70[5] T46 T16 
X	T11 T10 T9[4] T77 
X	X2 X1 T8 T7 
X	T6 T4 T3 T2 
X	T1 ;
X    .variable register sample register int_save_edge register int_edge register int_biphase_violation 
X	register int_carrier_loss register int_preamble_3 register int_preamble_2 register int_preamble_1 
X	register int_bit_clock register int_bit_value register bit_counter[4] register window_ctr[4] 
X	register violation[4] register data_bits[4] ;
X    #	5 nodes
X    .node 1 nop;	#	source node
X      .successors 2 ;
X    .endnode;
X
X    .node 2 cond;
X      .successors 3 ;	#  predecessors 1 
X      .cond reset[0:0] T1[0:0] ;	#	Latched
X      .case 0 ;
X        #	Index 2
X        .polargraph 1 7;
X        #	7 nodes
X        .node 1 nop;	#	source node
X          .successors 2 ;
X        .endnode;
X
X        .node 2 operation;
X          .inputs data[0:0] ;
X          .outputs T2[0:0] ;
X          .successors 3 ;	#  predecessors 1 
X          .attribute constraint delay 2 1 cycles;
X          .operation read;
X        .endnode;
X
X        .node 3 operation;
X          .inputs T2[0:0] data[0:0] ;
X          .outputs T3[0:0] ;
X          .successors 4 ;	#  predecessors 2 
X          .operation logic 1 ;
X            #	Expression 0
X            T3[0:0] = ((T2[0:0]  data[0:0] )+(T2[0:0]'  data[0:0]' ));
X            .attribute delay 2 level;
X            .attribute area 7 literal;
X          .endoperation;
X        .endnode;
X
X        .node 4 cond;
X          .successors 5 ;	#  predecessors 3 
X          .cond T3[0:0] T4[0:0] ;	#	Latched
X          .case 1 ;
X            #	Index 3
X            .polargraph 1 4;
X            #	4 nodes
X            .node 1 nop;	#	source node
X              .successors 2 3 ;
X            .endnode;
X
X            .node 2 operation;
X              .inputs T2[0:0] 0b1 ;
X              .outputs sample[0:0] int_edge[0:0] ;
X              .successors 4 ;	#  predecessors 1 
X              .attribute constraint delay 2 1 cycles;
X              .operation load_register;
X            .endnode;
X
X            .node 3 loop;
X              .successors 4 ;	#  predecessors 1 
X              .loop T6[0:0] ;	#	
X                #	Index 4
X                .polargraph 1 3;
X                #	3 nodes
X                .node 1 nop;	#	source node
X                  .successors 2 ;
X                .endnode;
X
X                .node 2 operation;
X                  .inputs T2[0:0] data[0:0] ;
X                  .outputs T6[0:0] ;
X                  .successors 3 ;	#  predecessors 1 
X                  .operation logic 2 ;
X                    #	Expression 0
X                    T5[0:0] = ((T2[0:0]  data[0:0] )+(T2[0:0]'  data[0:0]' ));
X                    T6[0:0] = T5[0:0]' ;
X                    .attribute delay 2 level;
X                    .attribute area 8 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 3 nop;	#	sink node
X                  .successors ;	#  predecessors 2 
X                .endnode;
X
X                .endpolargraph;
X              .endloop;
X            .endnode;
X
X            .node 4 nop;	#	sink node
X              .successors ;	#  predecessors 2 3 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .case 0 ;
X            #	Index 5
X            .polargraph 1 2;
X            #	2 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 nop;	#	sink node
X              .successors ;	#  predecessors 1 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .endcond;
X        .endnode;
X
X        .node 5 operation;
X          .inputs reset[0:0] ;
X          .outputs T7[0:0] ;
X          .successors 6 ;	#  predecessors 4 
X          .operation logic 3 ;
X            #	Expression 0
X            T7[0:0] = reset[0:0]' ;
X            .attribute delay 0 level;
X            .attribute area 1 literal;
X          .endoperation;
X        .endnode;
X
X        .node 6 cond;
X          .successors 7 ;	#  predecessors 5 
X          .cond T7[0:0] T8[0:0] ;	#	Latched
X          .case 1 ;
X            #	Index 6
X            .polargraph 1 5;
X            #	5 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 operation;
X              .inputs T4[0:0] sample[0:0] T2[0:0] int_edge[0:0] 
X	;
X              .outputs X1[0:0] X2[0:0] ;
X              .successors 3 ;	#  predecessors 1 
X              .operation logic 4 ;
X                #	Expression 0
X                X1[0:0] = ((V1_T4[0:0]  sample[0:0] )+(V0_T4[0:0]  T2[0:0] ));
X                X2[0:0] = ((V1_T4[0:0]  int_edge[0:0] )+V0_T4[0:0] );
X                V0_T4[0:0] = T4[0:0]' ;
X                V1_T4[0:0] = T4[0:0] ;
X                .attribute delay 2 level;
X                .attribute area 14 literal;
X              .endoperation;
X            .endnode;
X
X            .node 3 operation;
X              .inputs X1[0:0] X2[0:0] ;
X              .outputs sample[0:0] int_edge[0:0] ;
X              .successors 4 ;	#  predecessors 2 
X              .attribute constraint delay 3 1 cycles;
X              .operation load_register;
X            .endnode;
X
X            .node 4 loop;
X              .successors 5 ;	#  predecessors 3 
X              .loop T77[0:0] ;	#	
X                #	Index 7
X                .polargraph 1 19;
X                #	19 nodes
X                .node 1 nop;	#	source node
X                  .successors 2 3 ;
X                .endnode;
X
X                .node 2 operation;
X                  .inputs window_ctr[0:0] window_ctr[1:1] window_ctr[2:2] window_ctr[3:3] 
X	int_edge[0:0] bit_counter[0:0] bit_counter[1:1] bit_counter[2:2] 
X	bit_counter[3:3] int_carrier_loss[0:0] violation[1:1] violation[2:2] 
X	violation[3:3] violation[0:0] data_bits[0:0] data_bits[1:1] 
X	data_bits[2:2] data_bits[3:3] int_save_edge[0:0] ;
X                  .outputs T9[0:0] T9[1:1] T9[2:2] T9[3:3] 
X	T10[0:0] T18[0:0] T11[0:0] T12[0:0] 
X	T13[0:0] T14[0:0] T15[0:0] T16[0:0] 
X	T17[0:0] T19[0:0] ;
X                  .successors 5 ;	#  predecessors 1 
X                  .operation logic 5 ;
X                    #	Expression 0
X                    T9[0:0] = window_ctr[0:0] ;
X                    T9[1:1] = window_ctr[1:1] ;
X                    T9[2:2] = window_ctr[2:2] ;
X                    T9[3:3] = window_ctr[3:3] ;
X                    T10[0:0] = int_edge[0:0] ;
X                    T20[0:0] = V0110_bit_counter[0:3] ;
X                    T21[0:0] = V1110_bit_counter[0:3] ;
X                    T22[0:0] = (T20[0:0] +T21[0:0] );
X                    T23[0:0] = V0001_bit_counter[0:3] ;
X                    T24[0:0] = (T22[0:0] +T23[0:0] );
X                    T25[0:0] = V1001_bit_counter[0:3] ;
X                    T26[0:0] = (T24[0:0] +T25[0:0] );
X                    T27[0:0] = V0101_bit_counter[0:3] ;
X                    T28[0:0] = (T26[0:0] +T27[0:0] );
X                    T18[0:0] = T28[0:0] ;
X                    T11[0:0] = int_carrier_loss[0:0] ;
X                    T29[0:0] = V111_violation[1:3] ;
X                    T12[0:0] = T29[0:0] ;
X                    T30[0:0] = V0101_violation[0:3] ;
X                    T31[0:0] = V0110_data_bits[0:3] ;
X                    T32[0:0] = (T30[0:0]  T31[0:0] );
X                    T13[0:0] = T32[0:0] ;
X                    T33[0:0] = V0011_violation[0:3] ;
X                    T34[0:0] = V1010_data_bits[0:3] ;
X                    T35[0:0] = (T33[0:0]  T34[0:0] );
X                    T14[0:0] = T35[0:0] ;
X                    T36[0:0] = (T33[0:0]  T31[0:0] );
X                    T15[0:0] = T36[0:0] ;
X                    T16[0:0] = int_save_edge[0:0] ;
X                    T17[0:0] = int_edge[0:0] ;
X                    T37[0:0] = V0110_bit_counter[0:3] ;
X                    T38[0:0] = V1110_bit_counter[0:3] ;
X                    T39[0:0] = (T37[0:0] +T38[0:0] );
X                    T40[0:0] = V0001_bit_counter[0:3] ;
X                    T41[0:0] = (T39[0:0] +T40[0:0] );
X                    T42[0:0] = V1001_bit_counter[0:3] ;
X                    T43[0:0] = (T41[0:0] +T42[0:0] );
X                    T44[0:0] = V0101_bit_counter[0:3] ;
X                    T45[0:0] = (T43[0:0] +T44[0:0] );
X                    T19[0:0] = T45[0:0] ;
X                    V1010_data_bits[0:3] = (((data_bits[0:0]  data_bits[1:1]' ) data_bits[2:2] ) data_bits[3:3]' );
X                    V0110_data_bits[0:3] = (((data_bits[0:0]'  data_bits[1:1] ) data_bits[2:2] ) data_bits[3:3]' );
X                    V0011_violation[0:3] = (((violation[0:0]'  violation[1:1]' ) violation[2:2] ) violation[3:3] );
X                    V0101_violation[0:3] = (((violation[0:0]'  violation[1:1] ) violation[2:2]' ) violation[3:3] );
X                    V111_violation[1:3] = ((violation[1:1]  violation[2:2] ) violation[3:3] );
X                    V0101_bit_counter[0:3] = (((bit_counter[0:0]'  bit_counter[1:1] ) bit_counter[2:2]' ) bit_counter[3:3] );
X                    V1001_bit_counter[0:3] = (((bit_counter[0:0]  bit_counter[1:1]' ) bit_counter[2:2]' ) bit_counter[3:3] );
X                    V0001_bit_counter[0:3] = (((bit_counter[0:0]'  bit_counter[1:1]' ) bit_counter[2:2]' ) bit_counter[3:3] );
X                    V1110_bit_counter[0:3] = (((bit_counter[0:0]  bit_counter[1:1] ) bit_counter[2:2] ) bit_counter[3:3]' );
X                    V0110_bit_counter[0:3] = (((bit_counter[0:0]'  bit_counter[1:1] ) bit_counter[2:2] ) bit_counter[3:3]' );
X                    .attribute delay 7 level;
X                    .attribute area 130 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 3 operation;
X                  .inputs int_edge[0:0] ;
X                  .outputs T47[0:0] T46[0:0] ;
X                  .successors 4 ;	#  predecessors 1 
X                  .operation logic 6 ;
X                    #	Expression 0
X                    T47[0:0] = int_edge[0:0]' ;
X                    T46[0:0] = int_edge[0:0] ;
X                    .attribute delay 0 level;
X                    .attribute area 2 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 4 operation;
X                  .inputs sample[0:0] bit_counter[0:0] bit_counter[1:1] bit_counter[2:2] 
X	bit_counter[3:3] ;
X                  .outputs T48[0:0] T49[0:0] T50[0:0] ;
X                  .successors 5 ;	#  predecessors 3 
X                  .operation logic 7 ;
X                    #	Expression 0
X                    T48[0:0] = sample[0:0] ;
X                    T51[0:0] = V1010_bit_counter[0:3] ;
X                    T52[0:0] = V0110_bit_counter[0:3] ;
X                    T53[0:0] = (T51[0:0] +T52[0:0] );
X                    T54[0:0] = V1110_bit_counter[0:3] ;
X                    T55[0:0] = (T53[0:0] +T54[0:0] );
X                    T56[0:0] = V0001_bit_counter[0:3] ;
X                    T57[0:0] = (T55[0:0] +T56[0:0] );
X                    T58[0:0] = V1001_bit_counter[0:3] ;
X                    T59[0:0] = (T57[0:0] +T58[0:0] );
X                    T49[0:0] = T59[0:0] ;
X                    T60[0:0] = V1110_bit_counter[0:3] ;
X                    T61[0:0] = V0001_bit_counter[0:3] ;
X                    T62[0:0] = (T60[0:0] +T61[0:0] );
X                    T63[0:0] = V1001_bit_counter[0:3] ;
X                    T64[0:0] = (T62[0:0] +T63[0:0] );
X                    T65[0:0] = V0101_bit_counter[0:3] ;
X                    T66[0:0] = (T64[0:0] +T65[0:0] );
X                    T67[0:0] = V1101_bit_counter[0:3] ;
X                    T68[0:0] = (T66[0:0] +T67[0:0] );
X                    T50[0:0] = T68[0:0] ;
X                    V1101_bit_counter[0:3] = (((bit_counter[0:0]  bit_counter[1:1] ) bit_counter[2:2]' ) bit_counter[3:3] );
X                    V0101_bit_counter[0:3] = (((bit_counter[0:0]'  bit_counter[1:1] ) bit_counter[2:2]' ) bit_counter[3:3] );
X                    V1001_bit_counter[0:3] = (((bit_counter[0:0]  bit_counter[1:1]' ) bit_counter[2:2]' ) bit_counter[3:3] );
X                    V0001_bit_counter[0:3] = (((bit_counter[0:0]'  bit_counter[1:1]' ) bit_counter[2:2]' ) bit_counter[3:3] );
X                    V1110_bit_counter[0:3] = (((bit_counter[0:0]  bit_counter[1:1] ) bit_counter[2:2] ) bit_counter[3:3]' );
X                    V0110_bit_counter[0:3] = (((bit_counter[0:0]'  bit_counter[1:1] ) bit_counter[2:2] ) bit_counter[3:3]' );
X                    V1010_bit_counter[0:3] = (((bit_counter[0:0]  bit_counter[1:1]' ) bit_counter[2:2] ) bit_counter[3:3]' );
X                    .attribute delay 7 level;
X                    .attribute area 86 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 5 operation;
X                  .inputs sample[0:0] data[0:0] T9[0:0] T9[1:1] 
X	T9[2:2] T9[3:3] window_ctr[3:3] window_ctr[2:2] 
X	window_ctr[1:1] window_ctr[0:0] T10[0:0] T11[0:0] 
X	T16[0:0] T46[0:0] ;
X                  .outputs T69[0:0] T70[0:0] T70[1:1] T70[2:2] 
X	T70[3:3] ;
X                  .successors 6 ;	#  predecessors 2 4 
X                  .operation logic 8 ;
X                    #	Expression 0
X                    T69[0:0] = ((sample[0:0]  data[0:0]' )+(sample[0:0]'  data[0:0] ));
X                    M1[0:0] = X6[0:0] ;
X                    M1[1:1] = X5[0:0] ;
X                    M1[2:2] = X4[0:0] ;
X                    M1[3:3] = X3[0:0] ;
X                    X3[0:0] = ((((((((((((((((V1111_T9[0:3]  window_ctr[3:3] )+(V0111_T9[0:3]  window_ctr[3:3] ))+(V1011_T9[0:3]  window_ctr[3:3] ))+(V0011_T9[0:3]  window_ctr[3:3] ))+(V1101_T9[0:3]  window_ctr[3:3] ))+(V0101_T9[0:3]  window_ctr[3:3] ))+(V0001_T9[0:3]  window_ctr[3:3] ))+(V1110_T9[0:3]  window_ctr[3:3] ))+(V0110_T9[0:3]  window_ctr[3:3] ))+(V1010_T9[0:3]  window_ctr[3:3] ))+(V1100_T9[0:3]  window_ctr[3:3] ))+(V1001_T9[0:3]  X7[0:0] ))+(V0010_T9[0:3]  X11[0:0] ))+(V0100_T9[0:3]  window_ctr[3:3] ))+(V1000_T9[0:3]  X15[0:0] ))+(V0000_T9[0:3]  window_ctr[3:3] ));
X                    X4[0:0] = ((((((((((((((((V1111_T9[0:3]  window_ctr[2:2] )+(V0111_T9[0:3]  window_ctr[2:2] ))+(V1011_T9[0:3]  window_ctr[2:2] ))+(V0011_T9[0:3]  window_ctr[2:2] ))+(V1101_T9[0:3]  window_ctr[2:2] ))+(V0101_T9[0:3]  window_ctr[2:2] ))+(V0001_T9[0:3]  window_ctr[2:2] ))+(V1110_T9[0:3]  window_ctr[2:2] ))+(V0110_T9[0:3]  window_ctr[2:2] ))+(V1010_T9[0:3]  window_ctr[2:2] ))+(V1100_T9[0:3]  window_ctr[2:2] ))+(V1001_T9[0:3]  X8[0:0] ))+(V0010_T9[0:3]  X12[0:0] ))+(V0100_T9[0:3]  window_ctr[2:2] ))+(V1000_T9[0:3]  X16[0:0] ))+(V0000_T9[0:3]  window_ctr[2:2] ));
X                    X5[0:0] = ((((((((((((((((V1111_T9[0:3]  window_ctr[1:1] )+(V0111_T9[0:3]  window_ctr[1:1] ))+(V1011_T9[0:3]  window_ctr[1:1] ))+(V0011_T9[0:3]  window_ctr[1:1] ))+(V1101_T9[0:3]  window_ctr[1:1] ))+(V0101_T9[0:3]  window_ctr[1:1] ))+(V0001_T9[0:3]  window_ctr[1:1] ))+(V1110_T9[0:3]  window_ctr[1:1] ))+(V0110_T9[0:3]  window_ctr[1:1] ))+(V1010_T9[0:3]  window_ctr[1:1] ))+(V1100_T9[0:3]  window_ctr[1:1] ))+(V1001_T9[0:3]  X9[0:0] ))+(V0010_T9[0:3]  X13[0:0] ))+(V0100_T9[0:3]  window_ctr[1:1] ))+(V1000_T9[0:3]  X17[0:0] ))+(V0000_T9[0:3]  window_ctr[1:1] ));
X                    X6[0:0] = ((((((((((((((((V1111_T9[0:3]  window_ctr[0:0] )+(V0111_T9[0:3]  window_ctr[0:0] ))+(V1011_T9[0:3]  window_ctr[0:0] ))+(V0011_T9[0:3]  window_ctr[0:0] ))+(V1101_T9[0:3]  window_ctr[0:0] ))+(V0101_T9[0:3]  window_ctr[0:0] ))+(V0001_T9[0:3]  window_ctr[0:0] ))+(V1110_T9[0:3]  window_ctr[0:0] ))+(V0110_T9[0:3]  window_ctr[0:0] ))+(V1010_T9[0:3]  window_ctr[0:0] ))+(V1100_T9[0:3]  window_ctr[0:0] ))+(V1001_T9[0:3]  X10[0:0] ))+(V0010_T9[0:3]  X14[0:0] ))+(V0100_T9[0:3]  window_ctr[0:0] ))+(V1000_T9[0:3]  X18[0:0] ))+(V0000_T9[0:3]  window_ctr[0:0] ));
X                    X7[0:0] = ((V0_T10[0:0]  window_ctr[3:3] )+ 0 );
X                    X8[0:0] = ((V0_T10[0:0]  window_ctr[2:2] )+ 0 );
X                    X9[0:0] = ((V0_T10[0:0]  window_ctr[1:1] )+ 0 );
X                    X10[0:0] = ((V0_T10[0:0]  window_ctr[0:0] )+ 0 );
X                    X11[0:0] = ((V0_T11[0:0]  window_ctr[3:3] )+V1_T11[0:0] );
X                    X12[0:0] = ((V0_T11[0:0]  window_ctr[2:2] )+ 0 );
X                    X13[0:0] = ((V0_T11[0:0]  window_ctr[1:1] )+ 0 );
X                    X14[0:0] = ((V0_T11[0:0]  window_ctr[0:0] )+V1_T11[0:0] );
X                    X15[0:0] = ((V0_T16[0:0]  X19[0:0] )+(V1_T16[0:0]  window_ctr[3:3] ));
X                    X16[0:0] = ((V0_T16[0:0]  X20[0:0] )+(V1_T16[0:0]  window_ctr[2:2] ));
X                    X17[0:0] = ((V0_T16[0:0]  X21[0:0] )+(V1_T16[0:0]  window_ctr[1:1] ));
X                    X18[0:0] = ((V0_T16[0:0]  X22[0:0] )+(V1_T16[0:0]  window_ctr[0:0] ));
X                    X19[0:0] = ((V0_T46[0:0]  window_ctr[3:3] )+ 0 );
X                    X20[0:0] = ((V0_T46[0:0]  window_ctr[2:2] )+ 0 );
X                    X21[0:0] = ((V0_T46[0:0]  window_ctr[1:1] )+ 0 );
X                    X22[0:0] = ((V0_T46[0:0]  window_ctr[0:0] )+ 0 );
X                    c_T70[0:0] =  0 ;
X                    T70[0:0] = (((((M1[0:0]'   1 ) c_T70[0:0]' )+((M1[0:0]   1' ) c_T70[0:0]' ))+((M1[0:0]'   1' ) c_T70[0:0] ))+((M1[0:0]   1 ) c_T70[0:0] ));
X                    c_T70[1:1] = ((M1[0:0]   1 )+(c_T70[0:0]  (M1[0:0] + 1 )));
X                    T70[1:1] = (((((M1[1:1]'   0 ) c_T70[1:1]' )+((M1[1:1]   0' ) c_T70[1:1]' ))+((M1[1:1]'   0' ) c_T70[1:1] ))+((M1[1:1]   0 ) c_T70[1:1] ));
X                    c_T70[2:2] = ((M1[1:1]   0 )+(c_T70[1:1]  (M1[1:1] + 0 )));
X                    T70[2:2] = (((((M1[2:2]'   0 ) c_T70[2:2]' )+((M1[2:2]   0' ) c_T70[2:2]' ))+((M1[2:2]'   0' ) c_T70[2:2] ))+((M1[2:2]   0 ) c_T70[2:2] ));
X                    c_T70[3:3] = ((M1[2:2]   0 )+(c_T70[2:2]  (M1[2:2] + 0 )));
X                    T70[3:3] = (((((M1[3:3]'   0 ) c_T70[3:3]' )+((M1[3:3]   0' ) c_T70[3:3]' ))+((M1[3:3]'   0' ) c_T70[3:3] ))+((M1[3:3]   0 ) c_T70[3:3] ));
X                    c_T70[4:4] = ((M1[3:3]   0 )+(c_T70[3:3]  (M1[3:3] + 0 )));
X                    T70[4:4] = c_T70[3:3] ;
X                    V0_T46[0:0] = T46[0:0]' ;
X                    V1_T16[0:0] = T16[0:0] ;
X                    V0_T16[0:0] = T16[0:0]' ;
X                    V1_T11[0:0] = T11[0:0] ;
X                    V0_T11[0:0] = T11[0:0]' ;
X                    V0_T10[0:0] = T10[0:0]' ;
X                    V0000_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V1000_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V0100_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V0010_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V1001_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V1100_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V1010_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V0110_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V1110_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V0001_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V0101_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V1101_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V0011_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V1011_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V0111_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    V1111_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    .attribute delay 30 level;
X                    .attribute area 599 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 6 operation;
X                  .inputs T70[0:0] T70[1:1] T70[2:2] T70[3:3] 
X	;
X                  .outputs T71[0:0] ;
X                  .successors 7 ;	#  predecessors 5 
X                  .operation logic 9 ;
X                    #	Expression 0
X                    T72[0:0] = V0101_T70[0:3] ;
X                    T71[0:0] = T72[0:0] ;
X                    V0101_T70[0:3] = (((T70[0:0]'  T70[1:1] ) T70[2:2]' ) T70[3:3] );
X                    .attribute delay 3 level;
X                    .attribute area 9 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 7 operation;
X                  .inputs data[0:0] T9[0:0] T9[1:1] T9[2:2] 
X	T9[3:3] bit_counter[3:3] bit_counter[2:2] bit_counter[1:1] 
X	bit_counter[0:0] T10[0:0] T16[0:0] T48[0:0] 
X	T46[0:0] T17[0:0] ;
X                  .outputs T73[0:0] T74[0:0] T74[1:1] T74[2:2] 
X	T74[3:3] T75[0:0] T75[1:1] T75[2:2] 
X	T75[3:3] ;
X                  .successors 8 9 10 11 12 13 14 15 16 17 ;	#  predecessors 6 
X                  .operation logic 10 ;
X                    #	Expression 0
X                    T73[0:0] = data[0:0] ;
X                    M2[0:0] = X26[0:0] ;
X                    M2[1:1] = X25[0:0] ;
X                    M2[2:2] = X24[0:0] ;
X                    M2[3:3] = X23[0:0] ;
X                    X23[0:0] = ((((((((((((((((V1111_T9[0:3]  bit_counter[3:3] )+(V0111_T9[0:3]  bit_counter[3:3] ))+(V1011_T9[0:3]  bit_counter[3:3] ))+(V0011_T9[0:3]  bit_counter[3:3] ))+(V1101_T9[0:3]  bit_counter[3:3] ))+(V0101_T9[0:3]  bit_counter[3:3] ))+(V0001_T9[0:3]  bit_counter[3:3] ))+(V1110_T9[0:3]  bit_counter[3:3] ))+(V0110_T9[0:3]  bit_counter[3:3] ))+(V1010_T9[0:3]  bit_counter[3:3] ))+(V1100_T9[0:3]  bit_counter[3:3] ))+(V1001_T9[0:3]  X27[0:0] ))+(V0010_T9[0:3]  bit_counter[3:3] ))+(V0100_T9[0:3]  bit_counter[3:3] ))+(V1000_T9[0:3]  X31[0:0] ))+(V0000_T9[0:3]  X38[0:0] ));
X                    X24[0:0] = ((((((((((((((((V1111_T9[0:3]  bit_counter[2:2] )+(V0111_T9[0:3]  bit_counter[2:2] ))+(V1011_T9[0:3]  bit_counter[2:2] ))+(V0011_T9[0:3]  bit_counter[2:2] ))+(V1101_T9[0:3]  bit_counter[2:2] ))+(V0101_T9[0:3]  bit_counter[2:2] ))+(V0001_T9[0:3]  bit_counter[2:2] ))+(V1110_T9[0:3]  bit_counter[2:2] ))+(V0110_T9[0:3]  bit_counter[2:2] ))+(V1010_T9[0:3]  bit_counter[2:2] ))+(V1100_T9[0:3]  bit_counter[2:2] ))+(V1001_T9[0:3]  X28[0:0] ))+(V0010_T9[0:3]  bit_counter[2:2] ))+(V0100_T9[0:3]  bit_counter[2:2] ))+(V1000_T9[0:3]  X32[0:0] ))+(V0000_T9[0:3]  X39[0:0] ));
X                    X25[0:0] = ((((((((((((((((V1111_T9[0:3]  bit_counter[1:1] )+(V0111_T9[0:3]  bit_counter[1:1] ))+(V1011_T9[0:3]  bit_counter[1:1] ))+(V0011_T9[0:3]  bit_counter[1:1] ))+(V1101_T9[0:3]  bit_counter[1:1] ))+(V0101_T9[0:3]  bit_counter[1:1] ))+(V0001_T9[0:3]  bit_counter[1:1] ))+(V1110_T9[0:3]  bit_counter[1:1] ))+(V0110_T9[0:3]  bit_counter[1:1] ))+(V1010_T9[0:3]  bit_counter[1:1] ))+(V1100_T9[0:3]  bit_counter[1:1] ))+(V1001_T9[0:3]  X29[0:0] ))+(V0010_T9[0:3]  bit_counter[1:1] ))+(V0100_T9[0:3]  bit_counter[1:1] ))+(V1000_T9[0:3]  X33[0:0] ))+(V0000_T9[0:3]  X40[0:0] ));
X                    X26[0:0] = ((((((((((((((((V1111_T9[0:3]  bit_counter[0:0] )+(V0111_T9[0:3]  bit_counter[0:0] ))+(V1011_T9[0:3]  bit_counter[0:0] ))+(V0011_T9[0:3]  bit_counter[0:0] ))+(V1101_T9[0:3]  bit_counter[0:0] ))+(V0101_T9[0:3]  bit_counter[0:0] ))+(V0001_T9[0:3]  bit_counter[0:0] ))+(V1110_T9[0:3]  bit_counter[0:0] ))+(V0110_T9[0:3]  bit_counter[0:0] ))+(V1010_T9[0:3]  bit_counter[0:0] ))+(V1100_T9[0:3]  bit_counter[0:0] ))+(V1001_T9[0:3]  X30[0:0] ))+(V0010_T9[0:3]  bit_counter[0:0] ))+(V0100_T9[0:3]  bit_counter[0:0] ))+(V1000_T9[0:3]  X34[0:0] ))+(V0000_T9[0:3]  X41[0:0] ));
X                    X27[0:0] = ((V0_T10[0:0]  bit_counter[3:3] )+ 0 );
X                    X28[0:0] = ((V0_T10[0:0]  bit_counter[2:2] )+ 0 );
X                    X29[0:0] = ((V0_T10[0:0]  bit_counter[1:1] )+ 0 );
X                    X30[0:0] = ((V0_T10[0:0]  bit_counter[0:0] )+ 0 );
X                    X31[0:0] = ((V0_T16[0:0]  X36[0:0] )+(V1_T16[0:0]  bit_counter[3:3] ));
X                    X32[0:0] = ((V0_T16[0:0]  X36[0:0] )+(V1_T16[0:0]  bit_counter[2:2] ));
X                    X33[0:0] = ((V0_T16[0:0]  X36[0:0] )+(V1_T16[0:0]  bit_counter[1:1] ));
X                    X34[0:0] = ((V0_T16[0:0]  X37[0:0] )+(V1_T16[0:0]  bit_counter[0:0] ));
X                    X35[0:0] = (V0_T48[0:0] + 0 );
X                    X36[0:0] = ((V0_T46[0:0]  X35[0:0] )+ 0 );
X                    X37[0:0] = (V0_T46[0:0] + 0 );
X                    X38[0:0] = ((V0_T17[0:0]  bit_counter[3:3] )+ 0 );
X                    X39[0:0] = ((V0_T17[0:0]  bit_counter[2:2] )+ 0 );
X                    X40[0:0] = ((V0_T17[0:0]  bit_counter[1:1] )+ 0 );
X                    X41[0:0] = ((V0_T17[0:0]  bit_counter[0:0] )+ 0 );
X                    c_T74[0:0] =  1 ;
X                    T74[0:0] = (((((M2[0:0]'   1' ) c_T74[0:0]' )+((M2[0:0]   1 ) c_T74[0:0]' ))+((M2[0:0]'   1 ) c_T74[0:0] ))+((M2[0:0]   1' ) c_T74[0:0] ));
X                    c_T74[1:1] = ((M2[0:0]   1' )+(c_T74[0:0]  (M2[0:0] + 1' )));
X                    T74[1:1] = (((((M2[1:1]'   0' ) c_T74[1:1]' )+((M2[1:1]   0 ) c_T74[1:1]' ))+((M2[1:1]'   0 ) c_T74[1:1] ))+((M2[1:1]   0' ) c_T74[1:1] ));
X                    c_T74[2:2] = ((M2[1:1]   0' )+(c_T74[1:1]  (M2[1:1] + 0' )));
X                    T74[2:2] = (((((M2[2:2]'   0' ) c_T74[2:2]' )+((M2[2:2]   0 ) c_T74[2:2]' ))+((M2[2:2]'   0 ) c_T74[2:2] ))+((M2[2:2]   0' ) c_T74[2:2] ));
X                    c_T74[3:3] = ((M2[2:2]   0' )+(c_T74[2:2]  (M2[2:2] + 0' )));
X                    T74[3:3] = (((((M2[3:3]'   0' ) c_T74[3:3]' )+((M2[3:3]   0 ) c_T74[3:3]' ))+((M2[3:3]'   0 ) c_T74[3:3] ))+((M2[3:3]   0' ) c_T74[3:3] ));
X                    c_T74[4:4] = ((M2[3:3]   0' )+(c_T74[3:3]  (M2[3:3] + 0' )));
X                    T74[4:4] = c_T74[3:3] ;
X                    M3[0:0] = X26[0:0] ;
X                    M3[1:1] = X25[0:0] ;
X                    M3[2:2] = X24[0:0] ;
X                    M3[3:3] = X23[0:0] ;
X                    c_T75[0:0] =  0 ;
X                    T75[0:0] = (((((M3[0:0]'   1 ) c_T75[0:0]' )+((M3[0:0]   1' ) c_T75[0:0]' ))+((M3[0:0]'   1' ) c_T75[0:0] ))+((M3[0:0]   1 ) c_T75[0:0] ));
X                    c_T75[1:1] = ((M3[0:0]   1 )+(c_T75[0:0]  (M3[0:0] + 1 )));
X                    T75[1:1] = (((((M3[1:1]'   0 ) c_T75[1:1]' )+((M3[1:1]   0' ) c_T75[1:1]' ))+((M3[1:1]'   0' ) c_T75[1:1] ))+((M3[1:1]   0 ) c_T75[1:1] ));
X                    c_T75[2:2] = ((M3[1:1]   0 )+(c_T75[1:1]  (M3[1:1] + 0 )));
X                    T75[2:2] = (((((M3[2:2]'   0 ) c_T75[2:2]' )+((M3[2:2]   0' ) c_T75[2:2]' ))+((M3[2:2]'   0' ) c_T75[2:2] ))+((M3[2:2]   0 ) c_T75[2:2] ));
X                    c_T75[3:3] = ((M3[2:2]   0 )+(c_T75[2:2]  (M3[2:2] + 0 )));
X                    T75[3:3] = (((((M3[3:3]'   0 ) c_T75[3:3]' )+((M3[3:3]   0' ) c_T75[3:3]' ))+((M3[3:3]'   0' ) c_T75[3:3] ))+((M3[3:3]   0 ) c_T75[3:3] ));
X                    c_T75[4:4] = ((M3[3:3]   0 )+(c_T75[3:3]  (M3[3:3] + 0 )));
X                    T75[4:4] = c_T75[3:3] ;
X                    V0_T17[0:0] = T17[0:0]' ;
X                    V0_T46[0:0] = T46[0:0]' ;
X                    V0_T48[0:0] = T48[0:0]' ;
X                    V1_T16[0:0] = T16[0:0] ;
X                    V0_T16[0:0] = T16[0:0]' ;
X                    V0_T10[0:0] = T10[0:0]' ;
X                    V0000_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V1000_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V0100_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V0010_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V1001_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V1100_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V1010_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V0110_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V1110_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V0001_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V0101_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V1101_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V0011_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V1011_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V0111_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    V1111_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    .attribute delay 30 level;
X                    .attribute area 718 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 8 operation;
X                  .inputs T9[0:0] T9[1:1] T9[2:2] T9[3:3] 
X	int_bit_value[0:0] T10[0:0] T18[0:0] T16[0:0] 
X	T48[0:0] T49[0:0] T50[0:0] T17[0:0] 
X	T19[0:0] int_bit_clock[0:0] T11[0:0] int_preamble_1[0:0] 
X	T13[0:0] int_preamble_2[0:0] T14[0:0] int_preamble_3[0:0] 
X	T15[0:0] int_carrier_loss[0:0] T12[0:0] int_biphase_violation[0:0] 
X	T47[0:0] int_save_edge[0:0] int_edge[0:0] ;
X                  .outputs X42[0:0] X51[0:0] X53[0:0] X55[0:0] 
X	X57[0:0] X59[0:0] X62[0:0] X64[0:0] 
X	;
X                  .successors 18 ;	#  predecessors 7 
X                  .operation logic 11 ;
X                    #	Expression 0
X                    X42[0:0] = ((((((((((((((((V1111_T9[0:3]  int_bit_value[0:0] )+(V0111_T9[0:3]  int_bit_value[0:0] ))+(V1011_T9[0:3]  int_bit_value[0:0] ))+(V0011_T9[0:3]  int_bit_value[0:0] ))+(V1101_T9[0:3]  int_bit_value[0:0] ))+(V0101_T9[0:3]  int_bit_value[0:0] ))+(V0001_T9[0:3]  int_bit_value[0:0] ))+(V1110_T9[0:3]  int_bit_value[0:0] ))+(V0110_T9[0:3]  int_bit_value[0:0] ))+(V1010_T9[0:3]  int_bit_value[0:0] ))+(V1100_T9[0:3]  int_bit_value[0:0] ))+(V1001_T9[0:3]  X43[0:0] ))+(V0010_T9[0:3]  int_bit_value[0:0] ))+(V0100_T9[0:3]  int_bit_value[0:0] ))+(V1000_T9[0:3]  X45[0:0] ))+(V0000_T9[0:3]  X49[0:0] ));
X                    X43[0:0] = ((V0_T10[0:0]  int_bit_value[0:0] )+(V1_T10[0:0]  X44[0:0] ));
X                    X44[0:0] = (V0_T18[0:0] + 0 );
X                    X45[0:0] = ((V0_T16[0:0]  X46[0:0] )+(V1_T16[0:0]  int_bit_value[0:0] ));
X                    X46[0:0] = ((V0_T48[0:0]  X47[0:0] )+(V1_T48[0:0]  X48[0:0] ));
X                    X47[0:0] = (V0_T49[0:0] + 0 );
X                    X48[0:0] = (V0_T50[0:0] + 0 );
X                    X49[0:0] = ((V0_T17[0:0]  int_bit_value[0:0] )+(V1_T17[0:0]  X50[0:0] ));
X                    X50[0:0] = (V0_T19[0:0] + 0 );
X                    X51[0:0] = ((((((((((((((((V1111_T9[0:3]  int_bit_clock[0:0] )+(V0111_T9[0:3]  int_bit_clock[0:0] ))+(V1011_T9[0:3]  int_bit_clock[0:0] ))+(V0011_T9[0:3]  int_bit_clock[0:0] ))+(V1101_T9[0:3]  int_bit_clock[0:0] ))+(V0101_T9[0:3]  int_bit_clock[0:0] ))+(V0001_T9[0:3]  int_bit_clock[0:0] ))+(V1110_T9[0:3]  int_bit_clock[0:0] ))+(V0110_T9[0:3]  int_bit_clock[0:0] ))+(V1010_T9[0:3]  int_bit_clock[0:0] ))+(V1100_T9[0:3]  int_bit_clock[0:0] ))+ 0 )+(V0010_T9[0:3]  X52[0:0] ))+(V0100_T9[0:3]  int_bit_clock[0:0] ))+(V1000_T9[0:3]  int_bit_clock[0:0] ))+(V0000_T9[0:3]  int_bit_clock[0:0] ));
X                    X52[0:0] = (V0_T11[0:0] + 0 );
X                    X53[0:0] = ((((((((((((((((V1111_T9[0:3]  int_preamble_1[0:0] )+(V0111_T9[0:3]  int_preamble_1[0:0] ))+(V1011_T9[0:3]  int_preamble_1[0:0] ))+(V0011_T9[0:3]  int_preamble_1[0:0] ))+(V1101_T9[0:3]  int_preamble_1[0:0] ))+(V0101_T9[0:3]  int_preamble_1[0:0] ))+(V0001_T9[0:3]  int_preamble_1[0:0] ))+(V1110_T9[0:3]  int_preamble_1[0:0] ))+(V0110_T9[0:3]  int_preamble_1[0:0] ))+(V1010_T9[0:3]  int_preamble_1[0:0] ))+(V1100_T9[0:3]  int_preamble_1[0:0] ))+(V1001_T9[0:3]  int_preamble_1[0:0] ))+(V0010_T9[0:3]  int_preamble_1[0:0] ))+(V0100_T9[0:3]  X54[0:0] ))+(V1000_T9[0:3]  int_preamble_1[0:0] ))+(V0000_T9[0:3]  int_preamble_1[0:0] ));
X                    X54[0:0] = ( 0 +V1_T13[0:0] );
X                    X55[0:0] = ((((((((((((((((V1111_T9[0:3]  int_preamble_2[0:0] )+(V0111_T9[0:3]  int_preamble_2[0:0] ))+(V1011_T9[0:3]  int_preamble_2[0:0] ))+(V0011_T9[0:3]  int_preamble_2[0:0] ))+(V1101_T9[0:3]  int_preamble_2[0:0] ))+(V0101_T9[0:3]  int_preamble_2[0:0] ))+(V0001_T9[0:3]  int_preamble_2[0:0] ))+(V1110_T9[0:3]  int_preamble_2[0:0] ))+(V0110_T9[0:3]  int_preamble_2[0:0] ))+(V1010_T9[0:3]  int_preamble_2[0:0] ))+(V1100_T9[0:3]  int_preamble_2[0:0] ))+(V1001_T9[0:3]  int_preamble_2[0:0] ))+(V0010_T9[0:3]  int_preamble_2[0:0] ))+(V0100_T9[0:3]  X56[0:0] ))+(V1000_T9[0:3]  int_preamble_2[0:0] ))+(V0000_T9[0:3]  int_preamble_2[0:0] ));
X                    X56[0:0] = ( 0 +V1_T14[0:0] );
X                    X57[0:0] = ((((((((((((((((V1111_T9[0:3]  int_preamble_3[0:0] )+(V0111_T9[0:3]  int_preamble_3[0:0] ))+(V1011_T9[0:3]  int_preamble_3[0:0] ))+(V0011_T9[0:3]  int_preamble_3[0:0] ))+(V1101_T9[0:3]  int_preamble_3[0:0] ))+(V0101_T9[0:3]  int_preamble_3[0:0] ))+(V0001_T9[0:3]  int_preamble_3[0:0] ))+(V1110_T9[0:3]  int_preamble_3[0:0] ))+(V0110_T9[0:3]  int_preamble_3[0:0] ))+(V1010_T9[0:3]  int_preamble_3[0:0] ))+(V1100_T9[0:3]  int_preamble_3[0:0] ))+(V1001_T9[0:3]  int_preamble_3[0:0] ))+(V0010_T9[0:3]  int_preamble_3[0:0] ))+(V0100_T9[0:3]  X58[0:0] ))+(V1000_T9[0:3]  int_preamble_3[0:0] ))+(V0000_T9[0:3]  int_preamble_3[0:0] ));
X                    X58[0:0] = ( 0 +V1_T15[0:0] );
X                    X59[0:0] = ((((((((((((((((V1111_T9[0:3]  int_carrier_loss[0:0] )+(V0111_T9[0:3]  int_carrier_loss[0:0] ))+(V1011_T9[0:3]  int_carrier_loss[0:0] ))+(V0011_T9[0:3]  int_carrier_loss[0:0] ))+(V1101_T9[0:3]  int_carrier_loss[0:0] ))+(V0101_T9[0:3]  int_carrier_loss[0:0] ))+(V0001_T9[0:3]  int_carrier_loss[0:0] ))+(V1110_T9[0:3]  int_carrier_loss[0:0] ))+(V0110_T9[0:3]  int_carrier_loss[0:0] ))+(V1010_T9[0:3]  int_carrier_loss[0:0] ))+(V1100_T9[0:3]  int_carrier_loss[0:0] ))+(V1001_T9[0:3]  int_carrier_loss[0:0] ))+(V0010_T9[0:3]  X60[0:0] ))+(V0100_T9[0:3]  X61[0:0] ))+(V1000_T9[0:3]  int_carrier_loss[0:0] ))+(V0000_T9[0:3]  int_carrier_loss[0:0] ));
X                    X60[0:0] = ((V0_T11[0:0]  int_carrier_loss[0:0] )+ 0 );
X                    X61[0:0] = ( 0 +V1_T12[0:0] );
X                    X62[0:0] = ((((((((((((((((V1111_T9[0:3]  int_biphase_violation[0:0] )+(V0111_T9[0:3]  int_biphase_violation[0:0] ))+(V1011_T9[0:3]  int_biphase_violation[0:0] ))+(V0011_T9[0:3]  int_biphase_violation[0:0] ))+(V1101_T9[0:3]  int_biphase_violation[0:0] ))+(V0101_T9[0:3]  int_biphase_violation[0:0] ))+(V0001_T9[0:3]  int_biphase_violation[0:0] ))+(V1110_T9[0:3]  int_biphase_violation[0:0] ))+(V0110_T9[0:3]  int_biphase_violation[0:0] ))+(V1010_T9[0:3]  int_biphase_violation[0:0] ))+(V1100_T9[0:3]  int_biphase_violation[0:0] ))+(V1001_T9[0:3]  int_biphase_violation[0:0] ))+(V0010_T9[0:3]  int_biphase_violation[0:0] ))+(V0100_T9[0:3]  int_biphase_violation[0:0] ))+(V1000_T9[0:3]  X63[0:0] ))+(V0000_T9[0:3]  int_biphase_violation[0:0] ));
X                    X63[0:0] = ((V0_T16[0:0]  T47[0:0] )+ 0 );
X                    X64[0:0] = ((((((((((((((((V1111_T9[0:3]  int_save_edge[0:0] )+(V0111_T9[0:3]  int_save_edge[0:0] ))+(V1011_T9[0:3]  int_save_edge[0:0] ))+(V0011_T9[0:3]  int_save_edge[0:0] ))+(V1101_T9[0:3]  int_save_edge[0:0] ))+(V0101_T9[0:3]  int_save_edge[0:0] ))+(V0001_T9[0:3]  int_save_edge[0:0] ))+(V1110_T9[0:3]  int_save_edge[0:0] ))+(V0110_T9[0:3]  int_save_edge[0:0] ))+(V1010_T9[0:3]  int_save_edge[0:0] ))+(V1100_T9[0:3]  int_save_edge[0:0] ))+(V1001_T9[0:3]  X65[0:0] ))+(V0010_T9[0:3]  int_save_edge[0:0] ))+(V0100_T9[0:3]  int_save_edge[0:0] ))+(V1000_T9[0:3]  X66[0:0] ))+(V0000_T9[0:3]  X67[0:0] ));
X                    X65[0:0] = ((V0_T10[0:0]  int_save_edge[0:0] )+V1_T10[0:0] );
X                    X66[0:0] = ((V0_T16[0:0]  int_edge[0:0] )+ 0 );
X                    X67[0:0] = ((V0_T17[0:0]  int_save_edge[0:0] )+V1_T17[0:0] );
X                    V1_T12[0:0] = T12[0:0] ;
X                    V1_T15[0:0] = T15[0:0] ;
X                    V1_T14[0:0] = T14[0:0] ;
X                    V1_T13[0:0] = T13[0:0] ;
X                    V0_T11[0:0] = T11[0:0]' ;
X                    V0_T19[0:0] = T19[0:0]' ;
X                    V1_T17[0:0] = T17[0:0] ;
X                    V0_T17[0:0] = T17[0:0]' ;
X                    V0_T50[0:0] = T50[0:0]' ;
X                    V0_T49[0:0] = T49[0:0]' ;
X                    V1_T48[0:0] = T48[0:0] ;
X                    V0_T48[0:0] = T48[0:0]' ;
X                    V1_T16[0:0] = T16[0:0] ;
X                    V0_T16[0:0] = T16[0:0]' ;
X                    V0_T18[0:0] = T18[0:0]' ;
X                    V1_T10[0:0] = T10[0:0] ;
X                    V0_T10[0:0] = T10[0:0]' ;
X                    V0000_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V1000_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V0100_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V0010_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V1001_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V1100_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V1010_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V0110_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V1110_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V0001_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V0101_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V1101_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V0011_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V1011_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V0111_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    V1111_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    .attribute delay 19 level;
X                    .attribute area 711 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 9 operation;
X                  .inputs X42[0:0] ;
X                  .outputs bit_value[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 9 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 10 operation;
X                  .inputs X51[0:0] ;
X                  .outputs bit_clock[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 10 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 11 operation;
X                  .inputs X53[0:0] ;
X                  .outputs preamble_1[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 11 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 12 operation;
X                  .inputs X55[0:0] ;
X                  .outputs preamble_2[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 12 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 13 operation;
X                  .inputs X57[0:0] ;
X                  .outputs preamble_3[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 13 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 14 operation;
X                  .inputs X59[0:0] ;
X                  .outputs carrier_loss[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 14 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 15 operation;
X                  .inputs X62[0:0] ;
X                  .outputs biphase_violation[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 15 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 16 operation;
X                  .inputs T69[0:0] ;
X                  .outputs edge[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 16 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 17 operation;
X                  .inputs X64[0:0] ;
X                  .outputs save_edge[0:0] ;
X                  .successors 18 ;	#  predecessors 7 
X                  .attribute constraint delay 17 1 cycles;
X                  .operation write;
X                .endnode;
X
X                .node 18 operation;
X                  .inputs violation[0:0] violation[1:1] violation[2:2] data_bits[0:0] 
X	data_bits[1:1] data_bits[2:2] T9[0:0] T9[1:1] 
X	T9[2:2] T9[3:3] violation[3:3] data_bits[3:3] 
X	T10[0:0] T18[0:0] T16[0:0] T47[0:0] 
X	T48[0:0] T49[0:0] T50[0:0] T17[0:0] 
X	T19[0:0] T71[0:0] T70[3:3] T70[2:2] 
X	T70[1:1] T70[0:0] T73[0:0] T74[3:3] 
X	T75[3:3] T74[2:2] T75[2:2] T74[1:1] 
X	T75[1:1] T74[0:0] T75[0:0] reset[0:0] 
X	;
X                  .outputs X68[0:0] X69[0:0] X70[0:0] X71[0:0] 
X	X72[0:0] X73[0:0] X74[0:0] X75[0:0] 
X	X105[0:0] X106[0:0] X107[0:0] X108[0:0] 
X	X109[0:0] X110[0:0] X111[0:0] X112[0:0] 
X	T77[0:0] ;
X                  .successors 19 ;	#  predecessors 8 9 10 11 12 13 14 15 16 17 
X                  .operation logic 12 ;
X                    #	Expression 0
X                    M4[0:0] =  0 ;
X                    M4[1:1] = violation[0:0] ;
X                    M4[2:2] = violation[1:1] ;
X                    M4[3:3] = violation[2:2] ;
X                    M5[0:0] =  0 ;
X                    M5[1:1] = data_bits[0:0] ;
X                    M5[2:2] = data_bits[1:1] ;
X                    M5[3:3] = data_bits[2:2] ;
X                    M6[0:0] =  0 ;
X                    M6[1:1] = violation[0:0] ;
X                    M6[2:2] = violation[1:1] ;
X                    M6[3:3] = violation[2:2] ;
X                    M7[0:0] =  0 ;
X                    M7[1:1] = data_bits[0:0] ;
X                    M7[2:2] = data_bits[1:1] ;
X                    M7[3:3] = data_bits[2:2] ;
X                    M8[0:0] =  0 ;
X                    M8[1:1] = violation[0:0] ;
X                    M8[2:2] = violation[1:1] ;
X                    M8[3:3] = violation[2:2] ;
X                    M9[0:0] =  0 ;
X                    M9[1:1] = data_bits[0:0] ;
X                    M9[2:2] = data_bits[1:1] ;
X                    M9[3:3] = data_bits[2:2] ;
X                    X68[0:0] = ((((((((((((((((V1111_T9[0:3]  violation[3:3] )+(V0111_T9[0:3]  violation[3:3] ))+(V1011_T9[0:3]  violation[3:3] ))+(V0011_T9[0:3]  violation[3:3] ))+(V1101_T9[0:3]  violation[3:3] ))+(V0101_T9[0:3]  violation[3:3] ))+(V0001_T9[0:3]  violation[3:3] ))+(V1110_T9[0:3]  violation[3:3] ))+(V0110_T9[0:3]  violation[3:3] ))+(V1010_T9[0:3]  violation[3:3] ))+(V1100_T9[0:3]  violation[3:3] ))+(V1001_T9[0:3]  X76[0:0] ))+(V0010_T9[0:3]  violation[3:3] ))+(V0100_T9[0:3]  violation[3:3] ))+(V1000_T9[0:3]  X85[0:0] ))+(V0000_T9[0:3]  X96[0:0] ));
X                    X69[0:0] = ((((((((((((((((V1111_T9[0:3]  violation[2:2] )+(V0111_T9[0:3]  violation[2:2] ))+(V1011_T9[0:3]  violation[2:2] ))+(V0011_T9[0:3]  violation[2:2] ))+(V1101_T9[0:3]  violation[2:2] ))+(V0101_T9[0:3]  violation[2:2] ))+(V0001_T9[0:3]  violation[2:2] ))+(V1110_T9[0:3]  violation[2:2] ))+(V0110_T9[0:3]  violation[2:2] ))+(V1010_T9[0:3]  violation[2:2] ))+(V1100_T9[0:3]  violation[2:2] ))+(V1001_T9[0:3]  X77[0:0] ))+(V0010_T9[0:3]  violation[2:2] ))+(V0100_T9[0:3]  violation[2:2] ))+(V1000_T9[0:3]  X86[0:0] ))+(V0000_T9[0:3]  X97[0:0] ));
X                    X70[0:0] = ((((((((((((((((V1111_T9[0:3]  violation[1:1] )+(V0111_T9[0:3]  violation[1:1] ))+(V1011_T9[0:3]  violation[1:1] ))+(V0011_T9[0:3]  violation[1:1] ))+(V1101_T9[0:3]  violation[1:1] ))+(V0101_T9[0:3]  violation[1:1] ))+(V0001_T9[0:3]  violation[1:1] ))+(V1110_T9[0:3]  violation[1:1] ))+(V0110_T9[0:3]  violation[1:1] ))+(V1010_T9[0:3]  violation[1:1] ))+(V1100_T9[0:3]  violation[1:1] ))+(V1001_T9[0:3]  X78[0:0] ))+(V0010_T9[0:3]  violation[1:1] ))+(V0100_T9[0:3]  violation[1:1] ))+(V1000_T9[0:3]  X87[0:0] ))+(V0000_T9[0:3]  X98[0:0] ));
X                    X71[0:0] = ((((((((((((((((V1111_T9[0:3]  violation[0:0] )+(V0111_T9[0:3]  violation[0:0] ))+(V1011_T9[0:3]  violation[0:0] ))+(V0011_T9[0:3]  violation[0:0] ))+(V1101_T9[0:3]  violation[0:0] ))+(V0101_T9[0:3]  violation[0:0] ))+(V0001_T9[0:3]  violation[0:0] ))+(V1110_T9[0:3]  violation[0:0] ))+(V0110_T9[0:3]  violation[0:0] ))+(V1010_T9[0:3]  violation[0:0] ))+(V1100_T9[0:3]  violation[0:0] ))+(V1001_T9[0:3]  X79[0:0] ))+(V0010_T9[0:3]  violation[0:0] ))+(V0100_T9[0:3]  violation[0:0] ))+(V1000_T9[0:3]  X88[0:0] ))+(V0000_T9[0:3]  X99[0:0] ));
X                    X72[0:0] = ((((((((((((((((V1111_T9[0:3]  data_bits[3:3] )+(V0111_T9[0:3]  data_bits[3:3] ))+(V1011_T9[0:3]  data_bits[3:3] ))+(V0011_T9[0:3]  data_bits[3:3] ))+(V1101_T9[0:3]  data_bits[3:3] ))+(V0101_T9[0:3]  data_bits[3:3] ))+(V0001_T9[0:3]  data_bits[3:3] ))+(V1110_T9[0:3]  data_bits[3:3] ))+(V0110_T9[0:3]  data_bits[3:3] ))+(V1010_T9[0:3]  data_bits[3:3] ))+(V1100_T9[0:3]  data_bits[3:3] ))+(V1001_T9[0:3]  X80[0:0] ))+(V0010_T9[0:3]  data_bits[3:3] ))+(V0100_T9[0:3]  data_bits[3:3] ))+(V1000_T9[0:3]  X89[0:0] ))+(V0000_T9[0:3]  X100[0:0] ));
X                    X73[0:0] = ((((((((((((((((V1111_T9[0:3]  data_bits[2:2] )+(V0111_T9[0:3]  data_bits[2:2] ))+(V1011_T9[0:3]  data_bits[2:2] ))+(V0011_T9[0:3]  data_bits[2:2] ))+(V1101_T9[0:3]  data_bits[2:2] ))+(V0101_T9[0:3]  data_bits[2:2] ))+(V0001_T9[0:3]  data_bits[2:2] ))+(V1110_T9[0:3]  data_bits[2:2] ))+(V0110_T9[0:3]  data_bits[2:2] ))+(V1010_T9[0:3]  data_bits[2:2] ))+(V1100_T9[0:3]  data_bits[2:2] ))+(V1001_T9[0:3]  X81[0:0] ))+(V0010_T9[0:3]  data_bits[2:2] ))+(V0100_T9[0:3]  data_bits[2:2] ))+(V1000_T9[0:3]  X90[0:0] ))+(V0000_T9[0:3]  X101[0:0] ));
X                    X74[0:0] = ((((((((((((((((V1111_T9[0:3]  data_bits[1:1] )+(V0111_T9[0:3]  data_bits[1:1] ))+(V1011_T9[0:3]  data_bits[1:1] ))+(V0011_T9[0:3]  data_bits[1:1] ))+(V1101_T9[0:3]  data_bits[1:1] ))+(V0101_T9[0:3]  data_bits[1:1] ))+(V0001_T9[0:3]  data_bits[1:1] ))+(V1110_T9[0:3]  data_bits[1:1] ))+(V0110_T9[0:3]  data_bits[1:1] ))+(V1010_T9[0:3]  data_bits[1:1] ))+(V1100_T9[0:3]  data_bits[1:1] ))+(V1001_T9[0:3]  X82[0:0] ))+(V0010_T9[0:3]  data_bits[1:1] ))+(V0100_T9[0:3]  data_bits[1:1] ))+(V1000_T9[0:3]  X91[0:0] ))+(V0000_T9[0:3]  X102[0:0] ));
X                    X75[0:0] = ((((((((((((((((V1111_T9[0:3]  data_bits[0:0] )+(V0111_T9[0:3]  data_bits[0:0] ))+(V1011_T9[0:3]  data_bits[0:0] ))+(V0011_T9[0:3]  data_bits[0:0] ))+(V1101_T9[0:3]  data_bits[0:0] ))+(V0101_T9[0:3]  data_bits[0:0] ))+(V0001_T9[0:3]  data_bits[0:0] ))+(V1110_T9[0:3]  data_bits[0:0] ))+(V0110_T9[0:3]  data_bits[0:0] ))+(V1010_T9[0:3]  data_bits[0:0] ))+(V1100_T9[0:3]  data_bits[0:0] ))+(V1001_T9[0:3]  X83[0:0] ))+(V0010_T9[0:3]  data_bits[0:0] ))+(V0100_T9[0:3]  data_bits[0:0] ))+(V1000_T9[0:3]  X92[0:0] ))+(V0000_T9[0:3]  X103[0:0] ));
X                    X76[0:0] = ((V0_T10[0:0]  violation[3:3] )+(V1_T10[0:0]  M4[3:3] ));
X                    X77[0:0] = ((V0_T10[0:0]  violation[2:2] )+(V1_T10[0:0]  M4[2:2] ));
X                    X78[0:0] = ((V0_T10[0:0]  violation[1:1] )+(V1_T10[0:0]  M4[1:1] ));
X                    X79[0:0] = ((V0_T10[0:0]  violation[0:0] )+(V1_T10[0:0]  M4[0:0] ));
X                    X80[0:0] = ((V0_T10[0:0]  data_bits[3:3] )+(V1_T10[0:0]  M5[3:3] ));
X                    X81[0:0] = ((V0_T10[0:0]  data_bits[2:2] )+(V1_T10[0:0]  M5[2:2] ));
X                    X82[0:0] = ((V0_T10[0:0]  data_bits[1:1] )+(V1_T10[0:0]  M5[1:1] ));
X                    X83[0:0] = ((V0_T10[0:0]  data_bits[0:0] )+(V1_T10[0:0]  X84[0:0] ));
X                    X84[0:0] = (V0_T18[0:0] +(V1_T18[0:0]  M5[0:0] ));
X                    X85[0:0] = ((V0_T16[0:0]  M6[3:3] )+(V1_T16[0:0]  violation[3:3] ));
X                    X86[0:0] = ((V0_T16[0:0]  M6[2:2] )+(V1_T16[0:0]  violation[2:2] ));
X                    X87[0:0] = ((V0_T16[0:0]  M6[1:1] )+(V1_T16[0:0]  violation[1:1] ));
X                    X88[0:0] = ((V0_T16[0:0]  T47[0:0] )+(V1_T16[0:0]  violation[0:0] ));
X                    X89[0:0] = ((V0_T16[0:0]  M7[3:3] )+(V1_T16[0:0]  data_bits[3:3] ));
X                    X90[0:0] = ((V0_T16[0:0]  M7[2:2] )+(V1_T16[0:0]  data_bits[2:2] ));
X                    X91[0:0] = ((V0_T16[0:0]  M7[1:1] )+(V1_T16[0:0]  data_bits[1:1] ));
X                    X92[0:0] = ((V0_T16[0:0]  X93[0:0] )+(V1_T16[0:0]  data_bits[0:0] ));
X                    X93[0:0] = ((V0_T48[0:0]  X94[0:0] )+(V1_T48[0:0]  X95[0:0] ));
X                    X94[0:0] = (V0_T49[0:0] +(V1_T49[0:0]  M7[0:0] ));
X                    X95[0:0] = (V0_T50[0:0] +(V1_T50[0:0]  M7[0:0] ));
X                    X96[0:0] = ((V0_T17[0:0]  violation[3:3] )+(V1_T17[0:0]  M8[3:3] ));
X                    X97[0:0] = ((V0_T17[0:0]  violation[2:2] )+(V1_T17[0:0]  M8[2:2] ));
X                    X98[0:0] = ((V0_T17[0:0]  violation[1:1] )+(V1_T17[0:0]  M8[1:1] ));
X                    X99[0:0] = ((V0_T17[0:0]  violation[0:0] )+(V1_T17[0:0]  M8[0:0] ));
X                    X100[0:0] = ((V0_T17[0:0]  data_bits[3:3] )+(V1_T17[0:0]  M9[3:3] ));
X                    X101[0:0] = ((V0_T17[0:0]  data_bits[2:2] )+(V1_T17[0:0]  M9[2:2] ));
X                    X102[0:0] = ((V0_T17[0:0]  data_bits[1:1] )+(V1_T17[0:0]  M9[1:1] ));
X                    X103[0:0] = ((V0_T17[0:0]  data_bits[0:0] )+(V1_T17[0:0]  X104[0:0] ));
X                    X104[0:0] = (V0_T19[0:0] +(V1_T19[0:0]  M9[0:0] ));
X                    X105[0:0] = ((V0_T71[0:0]  T70[3:3] )+ 0 );
X                    X106[0:0] = ((V0_T71[0:0]  T70[2:2] )+ 0 );
X                    X107[0:0] = ((V0_T71[0:0]  T70[1:1] )+ 0 );
X                    X108[0:0] = ((V0_T71[0:0]  T70[0:0] )+ 0 );
X                    X109[0:0] = ((V0_T73[0:0]  T74[3:3] )+(V1_T73[0:0]  T75[3:3] ));
X                    X110[0:0] = ((V0_T73[0:0]  T74[2:2] )+(V1_T73[0:0]  T75[2:2] ));
X                    X111[0:0] = ((V0_T73[0:0]  T74[1:1] )+(V1_T73[0:0]  T75[1:1] ));
X                    X112[0:0] = ((V0_T73[0:0]  T74[0:0] )+(V1_T73[0:0]  T75[0:0] ));
X                    T76[0:0] = reset[0:0]' ;
X                    T77[0:0] = T76[0:0]' ;
X                    V1_T73[0:0] = T73[0:0] ;
X                    V0_T73[0:0] = T73[0:0]' ;
X                    V0_T71[0:0] = T71[0:0]' ;
X                    V1_T19[0:0] = T19[0:0] ;
X                    V0_T19[0:0] = T19[0:0]' ;
X                    V1_T17[0:0] = T17[0:0] ;
X                    V0_T17[0:0] = T17[0:0]' ;
X                    V1_T50[0:0] = T50[0:0] ;
X                    V0_T50[0:0] = T50[0:0]' ;
X                    V1_T49[0:0] = T49[0:0] ;
X                    V0_T49[0:0] = T49[0:0]' ;
X                    V1_T48[0:0] = T48[0:0] ;
X                    V0_T48[0:0] = T48[0:0]' ;
X                    V1_T16[0:0] = T16[0:0] ;
X                    V0_T16[0:0] = T16[0:0]' ;
X                    V1_T18[0:0] = T18[0:0] ;
X                    V0_T18[0:0] = T18[0:0]' ;
X                    V1_T10[0:0] = T10[0:0] ;
X                    V0_T10[0:0] = T10[0:0]' ;
X                    V0000_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V1000_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3]' );
X                    V0100_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V0010_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V1001_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V1100_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3]' );
X                    V1010_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3]' );
X                    V0110_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V1110_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3]' );
X                    V0001_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2]' ) T9[3:3] );
X                    V0101_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V1101_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2]' ) T9[3:3] );
X                    V0011_T9[0:3] = (((T9[0:0]'  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V1011_T9[0:3] = (((T9[0:0]  T9[1:1]' ) T9[2:2] ) T9[3:3] );
X                    V0111_T9[0:3] = (((T9[0:0]'  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    V1111_T9[0:3] = (((T9[0:0]  T9[1:1] ) T9[2:2] ) T9[3:3] );
X                    .attribute delay 19 level;
X                    .attribute area 904 literal;
X                  .endoperation;
X                .endnode;
X
X                .node 19 nop;	#	sink node
X                  .successors ;	#  predecessors 18 
X                .endnode;
X
X                .endpolargraph;
X              .attribute hercules loop_load sample[0:0] data[0:0] ;
X              .attribute hercules loop_load int_save_edge[0:0] X64[0:0] ;
X              .attribute hercules loop_load int_edge[0:0] T69[0:0] ;
X              .attribute hercules loop_load int_biphase_violation[0:0] X62[0:0] ;
X              .attribute hercules loop_load int_carrier_loss[0:0] X59[0:0] ;
X              .attribute hercules loop_load int_preamble_3[0:0] X57[0:0] ;
X              .attribute hercules loop_load int_preamble_2[0:0] X55[0:0] ;
X              .attribute hercules loop_load int_preamble_1[0:0] X53[0:0] ;
X              .attribute hercules loop_load int_bit_clock[0:0] X51[0:0] ;
X              .attribute hercules loop_load int_bit_value[0:0] X42[0:0] ;
X              .attribute hercules loop_load bit_counter[3:3] X109[0:0] ;
X              .attribute hercules loop_load bit_counter[2:2] X110[0:0] ;
X              .attribute hercules loop_load bit_counter[1:1] X111[0:0] ;
X              .attribute hercules loop_load bit_counter[0:0] X112[0:0] ;
X              .attribute hercules loop_load window_ctr[3:3] X105[0:0] ;
X              .attribute hercules loop_load window_ctr[2:2] X106[0:0] ;
X              .attribute hercules loop_load window_ctr[1:1] X107[0:0] ;
X              .attribute hercules loop_load window_ctr[0:0] X108[0:0] ;
X              .attribute hercules loop_load violation[3:3] X68[0:0] ;
X              .attribute hercules loop_load violation[2:2] X69[0:0] ;
X              .attribute hercules loop_load violation[1:1] X70[0:0] ;
X              .attribute hercules loop_load violation[0:0] X71[0:0] ;
X              .attribute hercules loop_load data_bits[3:3] X72[0:0] ;
X              .attribute hercules loop_load data_bits[2:2] X73[0:0] ;
X              .attribute hercules loop_load data_bits[1:1] X74[0:0] ;
X              .attribute hercules loop_load data_bits[0:0] X75[0:0] ;
X              .endloop;
X            .endnode;
X
X            .node 5 nop;	#	sink node
X              .successors ;	#  predecessors 4 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .case 0 ;
X            #	Index 8
X            .polargraph 1 2;
X            #	2 nodes
X            .node 1 nop;	#	source node
X              .successors 2 ;
X            .endnode;
X
X            .node 2 nop;	#	sink node
X              .successors ;	#  predecessors 1 
X            .endnode;
X
X            .endpolargraph;
X          .endcase;
X          .endcond;
X        .endnode;
X
X        .node 7 nop;	#	sink node
X          .successors ;	#  predecessors 6 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .case 1 ;
X        #	Index 9
X        .polargraph 1 11;
X        #	11 nodes
X        .node 1 nop;	#	source node
X          .successors 2 3 4 5 6 7 8 9 10 ;
X        .endnode;
X
X        .node 2 operation;
X          .inputs 0b0 ;
X          .outputs bit_value[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 2 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 3 operation;
X          .inputs 0b0 ;
X          .outputs bit_clock[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 3 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 4 operation;
X          .inputs 0b0 ;
X          .outputs preamble_1[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 4 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 5 operation;
X          .inputs 0b0 ;
X          .outputs preamble_2[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 5 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 6 operation;
X          .inputs 0b0 ;
X          .outputs preamble_3[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 6 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 7 operation;
X          .inputs 0b0 ;
X          .outputs carrier_loss[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 7 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 8 operation;
X          .inputs 0b0 ;
X          .outputs biphase_violation[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 8 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 9 operation;
X          .inputs 0b0 ;
X          .outputs edge[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 9 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 10 operation;
X          .inputs 0b0 ;
X          .outputs save_edge[0:0] ;
X          .successors 11 ;	#  predecessors 1 
X          .attribute constraint delay 10 1 cycles;
X          .operation write;
X        .endnode;
X
X        .node 11 nop;	#	sink node
X          .successors ;	#  predecessors 2 3 4 5 6 7 8 9 10 
X        .endnode;
X
X        .endpolargraph;
X      .endcase;
X      .endcond;
X    .endnode;
X
X    .node 3 operation;
X      .inputs T1[0:0] int_edge[0:0] T8[0:0] X2[0:0] 
X	;
X      .outputs X113[0:0] ;
X      .successors 4 ;	#  predecessors 2 
X      .operation logic 13 ;
X        #	Expression 0
X        X113[0:0] = ((V0_T1[0:0]  X114[0:0] )+(V1_T1[0:0]  int_edge[0:0] ));
X        X114[0:0] = ((V1_T8[0:0]  int_edge[0:0] )+(V0_T8[0:0]  X2[0:0] ));
X        V0_T8[0:0] = T8[0:0]' ;
X        V1_T8[0:0] = T8[0:0] ;
X        V1_T1[0:0] = T1[0:0] ;
X        V0_T1[0:0] = T1[0:0]' ;
X        .attribute delay 4 level;
X        .attribute area 18 literal;
X      .endoperation;
X    .endnode;
X
X    .node 4 operation;
X      .inputs X113[0:0] ;
X      .outputs int_edge[0:0] ;
X      .successors 5 ;	#  predecessors 3 
X      .attribute constraint delay 4 1 cycles;
X      .operation load_register;
X    .endnode;
X
X    .node 5 nop;	#	sink node
X      .successors ;	#  predecessors 4 
X    .endnode;
X
X    .endpolargraph;
X.endmodel phase_decoder ;
END_OF_FILE
if test 58790 -ne `wc -c <'daio_phase_decoder/daio_phase_decoder.sif'`; then
    echo shar: \"'daio_phase_decoder/daio_phase_decoder.sif'\" unpacked with wrong size!
fi
# end of 'daio_phase_decoder/daio_phase_decoder.sif'
fi
if test -f 'daio_phase_decoder/daio_phase_decoder.out.gold' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'daio_phase_decoder/daio_phase_decoder.out.gold'\"
else
echo shar: Extracting \"'daio_phase_decoder/daio_phase_decoder.out.gold'\" \(11248 characters\)
sed "s/^X//" >'daio_phase_decoder/daio_phase_decoder.out.gold' <<'END_OF_FILE'
X28 ariadne extract
Xdata[0:0]
Xreset[0:0]
Xbit_value[0:0]
Xbit_clock[0:0]
Xpreamble_1[0:0]
Xpreamble_2[0:0]
Xpreamble_3[0:0]
Xcarrier_loss[0:0]
Xbiphase_violation[0:0]
Xedge[0:0]
Xsave_edge[0:0]
Xsample[0:0]
Xbit_counter[0:0]
Xbit_counter[1:1]
Xbit_counter[2:2]
Xbit_counter[3:3]
Xwindow_ctr[0:0]
Xwindow_ctr[1:1]
Xwindow_ctr[2:2]
Xwindow_ctr[3:3]
Xviolation[0:0]
Xviolation[1:1]
Xviolation[2:2]
Xviolation[3:3]
Xdata_bits[0:0]
Xdata_bits[1:1]
Xdata_bits[2:2]
Xdata_bits[3:3]
X     0:0000000000000000000000000000
X     1:0000000000000000000000000000
X     5:1000000000000000000000000000
X     6:1010000001111000100000001000
X     7:1010000000010100010000001000
X     8:1010000000011100110000001000
X     9:0010000001000100001000001000
X    10:0011000000001000101000001000
X    11:0011000000000000011000001000
X    12:0011000000001111111000001000
X    13:0011000000000111000100001000
X    14:0011000000001011100100001000
X    15:1010000001010111000000001000
X    16:1010000000111000100000001100
X    17:1010000000010100010000001100
X    18:1010000000011100110000001100
X    19:0010000001000100001000001100
X    20:0011000000001000101000001100
X    21:0011000000000000011000001100
X    22:0011000000001111111000001100
X    23:0011000000000111000100001100
X    24:1011000001011111100100001100
X    25:1010000000111000100000001110
X    26:1010000000010100010000001110
X    27:1010000000011100110000001110
X    28:0010000001000100001000001110
X    29:0011000000001000101000001110
X    30:0011000000000000011000001110
X    31:0011000000001111111000001110
X    32:0011000000000111000100001110
X    33:0011000000001011100100001110
X    34:1010000001010111000000001110
X    35:1010000000111000100000001111
X    36:1010000000010100010000001111
X    37:1010000000011100110000001111
X    38:1010000000010010001000001111
X    39:1011000000011010101000001111
X    40:1011000000010110011000001111
X    41:1011000000011110111000001111
X    42:1011000000010001000100001111
X    43:1011000000011001100100001111
X    44:1010000000010101000000001111
X    45:1010000000011101100000001111
X    46:1000000010010100010010000111
X    47:1000000010011100110010000111
X    48:1000000010010010001010000111
X    49:0001000011001100101010000111
X    50:0001000010000100011010000111
X    51:0001000010001000111010000111
X    52:0001000010000000000110000111
X    53:0001000010001111100110000111
X    54:1000000011010000000010000111
X    55:1010000010111000100001001011
X    56:1010000000010100010001001011
X    57:1010000000011100110001001011
X    58:1010000000010010001001001011
X    59:0011000001001100101001001011
X    60:0011000000000100011001001011
X    61:0011000000001000111001001011
X    62:0011000000000000000101001011
X    63:0011000000001111100101001011
X    64:0010000000000111000001001011
X    65:0010000000001011100001001011
X    66:0010000010000111010010101101
X    67:0010000010001011110010101101
X    68:0010000010000011001010101101
X    69:0011000010001101101010101101
X    70:0011000010000101011010101101
X    71:0011000010001001111010101101
X    72:0011000010000001000110101101
X    73:0011000010001110100110101101
X    74:1010000011010001000010101101
X    75:1000000010111000100001010110
X    76:1000000000010100010001010110
X    77:1000100000011100110001010110
X    78:1000100000010010001001010110
X    79:1001100000011010101001010110
X    80:1001100000010110011001010110
X    81:1001100000011110111001010110
X    82:1001100000010001000101010110
X    83:1001100000011001100101010110
X    84:0000100001000001000001010110
X    85:0000100000101111100000100011
X    86:0000100000000111010000100011
X    87:0000000000001011110000100011
X    88:0000000000000011001000100011
X    89:0001000000001101101000100011
X    90:0001000000000101011000100011
X    91:0001000000001001111000100011
X    92:0001000000000001000100100011
X    93:0001000000001110100100100011
X    94:0000000000000110000000100011
X    95:1000000001011110100000100011
X    96:1000000000111000100000010001
X    97:1000000000010100010000010001
X    98:1000000000011100110000010001
X    99:1000000000010010001000010001
X   100:1001000000011010101000010001
X   101:1001000000010110011000010001
X   102:1001000000011110111000010001
X   103:1001000000010001000100010001
X   104:1001000000011001100100010001
X   105:1000000000010101000000010001
X   106:1000000000011101100000010001
X   107:1000000010010100010010000000
X   108:1000000010011100110010000000
X   109:1000000010010010001010000000
X   110:0001000011001100101010000000
X   111:0001000010000100011010000000
X   112:0001000010001000111010000000
X   113:0001000010000000000110000000
X   114:0001000010001111100110000000
X   115:0000000010000111000010000000
X   116:0000000010001011100010000000
X   117:0010000010000111010011001000
X   118:0010000010001011110011001000
X   119:0010000010000011001011001000
X   120:0011000010001101101011001000
X   121:0011000010000101011011001000
X   122:0011000010001001111011001000
X   123:0011000010000001000111001000
X   124:0011000010001110100111001000
X   125:1010000011010001000011001000
X   126:1000000010111000100001100100
X   127:1000000000010100010001100100
X   128:1000000000011100110001100100
X   129:1000000000010010001001100100
X   130:0001000001001100101001100100
X   131:0001000000000100011001100100
X   132:0001000000001000111001100100
X   133:0001000000000000000101100100
X   134:0001000000001111100101100100
X   135:1000000001010000000001100100
X   136:1010000000111000100000111010
X   137:1010000000010100010000111010
X   138:1010010000011100110000111010
X   139:0010010001000100001000111010
X   140:0011010000001000101000111010
X   141:0011010000000000011000111010
X   142:0011010000001111111000111010
X   143:1011010001010000000100111010
X   144:1011010000011000100100111010
X   145:1010010000010100000000111010
X   146:1010010000011100100000111010
X   147:1010010010010100010010011101
X   148:0010000011001000110010011101
X   149:0010000010000000001010011101
X   150:0011000010001111101010011101
X   151:0011000010000111011010011101
X   152:0011000010001011111010011101
X   153:0011000010000011000110011101
X   154:1011000011011011100110011101
X   155:1010000010111000100001001110
X   156:1010000000010100010001001110
X   157:0010000001001000110001001110
X   158:1010000001010100001001001110
X   159:1011000000011100101001001110
X   160:1011000000010010011001001110
X   161:1011000000011010111001001110
X   162:1011000000010110000101001110
X   163:1011000000011110100101001110
X   164:0010000001000110000001001110
X   165:0000000000101111100000100111
X   166:0000000000000111010000100111
X   167:0000000000001011110000100111
X   168:1000000001010111001000100111
X   169:1001000000011111101000100111
X   170:1001000000010000011000100111
X   171:1001000000011000111000100111
X   172:1001000000010100000100100111
X   173:0001000001001000100100100111
X   174:0010000000101111100000011011
X   175:0010000000000111010000011011
X   176:0010000000001011110000011011
X   177:0010000000000011001000011011
X   178:0011000000001101101000011011
X   179:0011000000000101011000011011
X   180:0011000000001001111000011011
X   181:0011000000000001000100011011
X   182:0011000000001110100100011011
X   183:1010000001010001000000011011
X   184:1000000000111000100000000101
X   185:1000000000010100010000000101
X   186:1000000000011100110000000101
X   187:1000000000010010001000000101
X   188:1001000000011010101000000101
X   189:1001000000010110011000000101
X   190:1001000000011110111000000101
X   191:1001000000010001000100000101
X   192:1001000000011001100100000101
X   193:1000000000010101000000000101
X   194:1000000000011101100000000101
X   195:1000000010010100010010000010
X   196:1000000010011100110010000010
X   197:1000000010010010001010000010
X   198:0001000011001100101010000010
X   199:0001000010000100011010000010
X   200:0001000010001000111010000010
X   201:0001000010000000000110000010
X   202:0001000010001111100110000010
X   203:0000000010000111000010000010
X   204:0000000010001011100010000010
X   205:0010000010000111010011001001
X   206:0010000010001011110011001001
X   207:0010000010000011001011001001
X   208:1011000011011011101011001001
X   209:1011000010010111011011001001
X   210:1011000010011111111011001001
X   211:1011000010010000000111001001
X   212:1011000010011000100111001001
X   213:0010000011000000000011001001
X   214:0010000010101111100001101100
X   215:0010000000000111010001101100
X   216:0010000000001011110001101100
X   217:0010000000000011001001101100
X   218:0011000000001101101001101100
X   219:0011000000000101011001101100
X   220:0011000000001001111001101100
X   221:0011000000000001000101101100
X   222:1011000001011001100101101100
X   223:1000000000111000100000110110
X   224:1000000000010100010000110110
X   225:1000001000011100110000110110
X   226:0000001001000100001000110110
X   227:0001001000001000101000110110
X   228:0001001000000000011000110110
X   229:0001001000001111111000110110
X   230:0001001000000111000100110110
X   231:0001001000001011100100110110
X   232:0000001000000011000000110110
X   233:0000001000001101100000110110
X   234:0010001010000111010010011011
X   235:0010000010001011110010011011
X   236:0010000010000011001010011011
X   237:0011000010001101101010011011
X   238:0011000010000101011010011011
X   239:0011000010001001111010011011
X   240:0011000010000001000110011011
X   241:0011000010001110100110011011
X   242:0010000010000110000010011011
X   243:0010000010001010100010011011
X   244:0000000010000111010011000101
X   245:0000000010001011110011000101
X   246:0000000010000011001011000101
X   247:0001000010001101101011000101
X   248:0001000010000101011011000101
X   249:0001000010001001111011000101
X   250:0001000010000001000111000101
X   251:0001000010001110100111000101
X   252:0000000010000110000011000101
X   253:0000000010001010100011000101
X   254:0000000010000111010011100010
X   255:0000000010001011110011100010
X   256:0000000010000011001011100010
X   257:0001000010001101101011100010
X   258:0001000010000101011011100010
X   259:0001000010001001111011100010
X   260:0001000010000001000111100010
X   261:0001000010001110100111100010
X   262:0000000010000110000011100010
X   263:0000000010001010100011100010
X   264:0000000010000111010011110001
X   265:0000000110001011110011110001
X   266:0000000110000011001011110001
X   267:0000000010001101000011110001
X   268:0000000010000101100011110001
X   269:0010000010000111010011111000
X   270:0010000110001011110011111000
X   271:0010000110000011001011111000
X   272:0010000010001101000011111000
X   273:0010000010000101100011111000
X   274:0010000010000111010011111100
X   275:0010000110001011110011111100
X   276:0010000110000011001011111100
X   277:0010000010001101000011111100
X   278:0010000010000101100011111100
X   279:0010000010000111010011111110
X   280:0010000110001011110011111110
X   281:0010000110000011001011111110
X   282:1010000011011011000011111110
X   283:1010000010111000100001111111
X   284:1010000000010100010001111111
X   285:1010000100011100110001111111
X   286:1010000100010010001001111111
X   287:1010000000011010000001111111
X   288:1010000000010110100001111111
X   289:1010000010010100010010111111
X   290:0010000011001000110010111111
X   291:0010000010000000001010111111
X   292:1011000011011000101010111111
X   293:1011000010010100011010111111
X   294:0011000011001000111010111111
X   295:0011000010000000000110111111
X   296:1011000011011000100110111111
X   297:1010000010111000100001011111
X   298:1010000000010100010001011111
X   299:1010000000011100110001011111
X   300:1010000000010010001001011111
X   301:0011000001001100101001011111
X   302:0011000000000100011001011111
END_OF_FILE
if test 11248 -ne `wc -c <'daio_phase_decoder/daio_phase_decoder.out.gold'`; then
    echo shar: \"'daio_phase_decoder/daio_phase_decoder.out.gold'\" unpacked with wrong size!
fi
# end of 'daio_phase_decoder/daio_phase_decoder.out.gold'
fi
echo shar: End of shell archive.
exit 0


