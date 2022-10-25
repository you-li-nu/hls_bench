/*
 *	i8251 UART - HardwareC version
 *
 *	Written by David Ku
 *	Stanford University
 */

# define 	DataSize	8

# define	forever		1
# define	wait(f)		while (f) 

# define 	TRUE  		1
# define 	FALSE 		0

/*
 *	field definition
 */

# define	eh		control[7:7]
# define	ir		control[6:6]
# define	rts		control[5:5]
# define	er		control[4:4]
# define	sbrk		control[3:3]
# define	rxE		control[2:2]
# define	dtr		control[1:1]
# define	txen		control[0:0]

# define	dsr		status[7:7]
# define	syndet		status[6:6]
# define	fe		status[5:5]
# define	oe		status[4:4]
# define	pe		status[3:3]
# define	txe		status[2:2]
# define	rxrdy		status[1:1]
# define	txrdy		status[0:0]

# define	scs		mode[7:7]
# define	nsbits		mode[6:7]
# define	esd		mode[5:5]
# define	ep		mode[4:4]
# define	pen		mode[3:3]
# define	nbits		mode[1:2]
# define	brate		mode[0:0]

/*
 *	hunt_mode()
 *
 *	searches in synchronous receive mode for sync chars
 */


hunt_mode( rxd, drdy, sync1, sync2, mode )
	in boolean rxd;
	in boolean drdy;
	in boolean sync1[DataSize], 
		   sync2[DataSize], 
		   mode[DataSize];
{
	boolean done;
	boolean data[DataSize];
	boolean ncount[3];

	done = FALSE;

	while ( ! done ) {

		data = 0xff;
		while ( data != sync1 ) [
			wait ( drdy );
			data[7:7] = read ( rxd );
			data = data >> 1;
			done = TRUE;
		]

		if ( mode[7:7] == 0 )  {

			ncount[2:2] = 1;
			ncount[0:1] = nbits;
			while ( ncount ) [
				wait ( drdy );
				data[7:7] = rxd;
				data = data >> 1;
				ncount = ncount - 1;
			]

			done = (data == sync2);
		}
	}
}

/*
 *	xmit - transmit process
 */

declare process i8251(ChipSelect, WriteEnable, ReadEnable, ChipData, 
	data, valid, sync1, sync2, mode, control, status)
	in boolean ChipSelect;
	in boolean WriteEnable;
	in boolean ReadEnable;
	in boolean ChipData;
	inout boolean data[DataSize];
	out boolean valid;
	out boolean sync1[DataSize];
	out boolean sync2[DataSize];
	out boolean mode[DataSize];
	out boolean control[DataSize];
	in boolean status[DataSize];


process xmit(cts, txd, xdrdy, valid, 
	     mode, status, control, sync1, sync2)
	in boolean cts;	
	out boolean txd;
	in boolean xdrdy;
	in boolean valid;
	in boolean sync1[DataSize], sync2[DataSize];
	in boolean mode[DataSize], 
		   control[DataSize];
	out boolean status[DataSize];
[
	int i;
	boolean sync_mode;			/* sync mode */
	boolean sync_flag;
	boolean data_ready;
	boolean par;
	boolean ncount[3];			/* # bits */
	boolean dbuf[DataSize];
	boolean xdata[DataSize];
	boolean okay[DataSize];

	free status;

	/*
	 *	initialization - valid true when sync1/sync2 is ready
	 */

	if ( valid ) {

		txd = 1; txe = 0;
		write txd;

		sync_mode = (mode[6:7] == 0);

		/*	wait for enable		 */

		wait ( txen & cts );

		/* 	check for sbrk 		 */

		if (! sync_mode & sbrk)
		[	txd = 0;
			write txd;
			wait ( (!sbrk) | (!txen) | (!cts) );
			txd = 1;
			write txd;
		]

		/*
		 *	wait if in async mode, or send sync char if sync
	 	 */
		txe = 1;
		write txe;
		free txe;

		if ( sync_mode )
		{	/* check if message are pending */
			if ( msgwaiting(i8251) )
				receive(i8251, xdata);
			else
			{	if (sync_flag)
					xdata = sync1;
				else
					xdata = sync2;
				sync_flag = ! sync_flag;
			}
		}
		else
			receive(i8251, xdata);


		/*
	 	 *	send start bit
		 */
		if ( ! sync_mode )
		[	wait (xdrdy);
			txd = 0;
			write txd;
		]

		/*
		 *	send data
		 */
		ncount[2:2] = 1;
		ncount[0:1] = nbits;
		while ( ncount )
		[	wait (xdrdy);
			txd = dbuf[0:0];
			write txd;
			ncount = ncount - 1;
			dbuf = dbuf >> 1;
		]

		/*
		 *	send parity bits if required
		 */
		if (pen)
		[

			par = xdata[0:0];
			for i = 1 to 7 do
				par = par xor xdata[i:i];

			if (! ep)
				par = ! par;
			wait (xdrdy);
			txd = par;
			write txd;
		]

		/*
		 *	send stop bits
		 */
		if (! sync_mode)
		[	wait (xdrdy);
			txd = 1;
			write txd;
		]

		write status;
	}
]

/*
 *	rcvr_sync -
 *
 *	receiver synchronous process
 */

process rcvr_sync(rxd, drdy, valid, mode, control, status, sync1, sync2)
	in boolean rxd;				/* receive serial data */
	in boolean drdy;			/* data ready */
	in boolean valid;
	in boolean mode[DataSize];
	in boolean control[DataSize];
	in boolean sync1[DataSize];
	in boolean sync2[DataSize];
	out boolean status[DataSize];
{
	boolean sync_mode;
	boolean par;
	boolean ncount[3];
	boolean data[DataSize];

	/*
	 *	free up line
	 */

	free status;

	/* 
	 *	determine initialization
	 */

	if ( valid ) {

		sync_mode = (mode[6:7] == 0);

		if ( sync_mode ) [

			/*
			 *	wait for mode
			 */
			if ( eh )
				hunt_mode(rxd, drdy, sync1, sync2, mode );

			/*
			 *	start shifting data in
			 */
			ncount[2:2] = 1;
			ncount[0:1] = nbits;
			while ( ncount ) [
				wait ( drdy );
				data[7:7] = read ( rxd );
				data = data >> 1;
				ncount = ncount - 1;
			]

			/*
			 *	send data to main process
			 */
			send( i8251, data );

		]

		write status;
	}
}


/*
 *	rcvr_async -
 *
 *	receiver asynchronous process
 */

process rcvr_async(rxd, drdy, valid, mode, control, status)
	in boolean rxd;				/* receive serial data */
	in boolean drdy;			/* data ready */
	in boolean valid;
	in boolean mode[DataSize];
	in boolean control[DataSize];
	out boolean status[DataSize];
{
	int i;
	boolean sync_mode;
	boolean par;
	boolean ncount[3];
	boolean data[DataSize];

	/* 
	 *	determine initialization
	 */

	free status;
	if ( valid ) {

		/* assume mode is stable now */

		sync_mode = (mode[6:7] == 0);

		if ( ! sync_mode ) [

			/*
			 *	wait for start bit
			 */
			wait ( rxd );
			wait ( ! rxd );

			/*
			 *	start shifting data in
			 */
			ncount[2:2] = 1;
			ncount[0:1] = nbits;
			while ( ncount ) [
				wait ( drdy );
				data[7:7] = read ( rxd );
				data = data >> 1;
				ncount = ncount - 1;
			]
	
			/*
			 *	sample parity bit
			 */
			if ( pen ) [

				par = data[0:0];
				for i = 1 to 7 do
					par = par xor data[i:i];
		
				if ( ep ) 
					par = ! par;
				wait ( drdy );
				if ( par != rxd ) {
					pe = 1;		/* parity error */
					write pe;
				}
			]

			/*
			 *	sample stop bit
			 */
			wait ( drdy );
			if ( rxd == 0 ) {
				fe = 1;			/* framing error */
				write fe;
			}
	
			/*
			 *	send data to main process
			 */
			send( i8251, data );

		]

		write status;
	}
}


/*
 *	main process for intel 8251
 */

process i8251(ChipSelect, WriteEnable, ReadEnable, ChipData, data, valid,
    sync1, sync2, mode, control, status)
	in boolean ChipSelect;
	in boolean WriteEnable;
	in boolean ReadEnable;
	in boolean ChipData;
	inout boolean data[DataSize];
	out boolean valid;
	out boolean sync1[DataSize];
	out boolean sync2[DataSize];
	out boolean mode[DataSize];
	out boolean control[DataSize];
	in boolean status[DataSize];
[
	boolean modebuf[DataSize];
	boolean dbuf[DataSize];
	boolean decode[3];
	boolean sync_mode;

	valid = 0;
	write valid;

	/*
	 *	reset sequence: read mode character
	 */
	wait ( ChipSelect & WriteEnable & ChipData ) ;

	modebuf = read ( data );

	mode = modebuf;
	valid = 1;

	sync_mode = (modebuf[6:7] == 0);

	/*
	 *	read sync characters if necessary 
	 */

	sync1 = 0;
	sync2 = 0;

	if ( sync_mode )
	[	/* read first sync char */
		wait ( ChipSelect & WriteEnable & ChipData );
		sync1 = read ( data );
	
		/* read second sync char */
		if ( ! modebuf[7:7] )
		[	wait ( ChipSelect & WriteEnable & ChipData );
			sync2 = read ( data );
		]
	]

	write valid, mode, sync1, sync2;	/* write to output port */

	/*
	 *	main interp loop
	 */

	decode[0:0] = ChipData;
	decode[1:1] = ReadEnable;
	decode[2:2] = WriteEnable;

	while ( ChipSelect )
	{	switch (decode) {
		case 0x2:			/* read data */
			[
			if (sync_mode)
				receive(rcvr_sync, dbuf);
			else
				receive(rcvr_async, dbuf);

			wait ( ! WriteEnable );
			data = dbuf;
			write data;
			]
			break;
		case 0x3:			/* read status */
			[
			data = read ( status );
			wait ( ! WriteEnable );
			write data;
			]
			break;
		case 0xC:			/* write data */
			dbuf = read ( data );
			send(xmit, dbuf);
			break;
		case 0xD:			/* write control */
			dbuf = read ( data );
			control = dbuf;
			write control;
			break;
		}
	}

]


