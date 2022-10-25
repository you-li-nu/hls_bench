
/*
 *	library.hc - list of library templates
 *
 *	Author:		Rajesh Gupta
 *	Date:		7/16/90
 */

/*
 *	add(a,b)
 *
 * 	ripple carry adder
 */

template function add(op1, op2) with (SIZE) return boolean[SIZE+1] 
	in boolean op1[SIZE];
	in boolean op2[SIZE];
{
	int i;
	boolean carry;

	carry = 0;
	for i = 0 to SIZE-1 do
	{
		return_value[i] = op1[i] ^ op2[i] ^ carry;
		carry = op1[i]  & op2 [i] | carry & ( op1[i] | op2[i] );
	};
	return_value[SIZE] = carry;
}


/*
 *	subtract(a,b)
 */

template function subtract(op1, op2) with (SIZE) return boolean[SIZE+1] 
	in boolean op1[SIZE];
	in boolean op2[SIZE];
{
	boolean tmp[SIZE+1];

	tmp = 0 - op2;

	return_value = add(op1, tmp) with (SIZE);
}

/*
 *	multiply(a,b)
 */

template function multiply(op1, op2) with (SIZE) return boolean[2*SIZE] 
	in boolean op1[SIZE];
	in boolean op2[SIZE];
{
	boolean count[SIZE];
	boolean tmp[2*SIZE];

	tmp = 0;
	count = op2;
	while (count > 0) { 
		tmp = tmp + op1;
		count--;
	}
	return_value = tmp;	
}
#
template function smultiply(op1, op2) with (SIZE) return boolean[SIZE] 
	in boolean op1[SIZE];
	in boolean op2[SIZE];
{
	boolean count[SIZE];
	boolean tmp[SIZE];

	tmp = 0;
	count = op2;
	while (count > 0) { 
		tmp = tmp + op1;
		count = count - 1;
	}
	return_value = tmp;	
}
#
template function tmultiply(op1, op2) with (SIZE) return boolean[SIZE] 
	in boolean op1[SIZE];
	in boolean op2[SIZE];
{
	boolean count[SIZE];
	boolean tmp[SIZE];
	boolean hi[SIZE];
	boolean lo[SIZE];

	tmp = 0;
	count = 0;
	if ((op1 == 0) || (op2 == 0)) 
		return_value = 0; 
	else {
		if (op1 > op2) {
			lo = op2;
			hi = op1;
		} else {
			lo = op1;
			hi = op2; };
	
		while (count < lo) { 
			tmp = tmp + hi;
			count = count + 1;
		}
		return_value = tmp;	
	}
}

template function smpy(op1, op2) with (SIZE) return boolean[SIZE]
	in boolean op1[SIZE];
	in boolean op2[SIZE];
{
	boolean i[SIZE];
	boolean acc[2*SIZE];
	int j;

	if ((op1 == 0) || (op2 == 0)) 
		return_value = 0; 
	else [
		acc = op1;
		i = op2 ;
		while (i >= 1) [
			if (i[0:0] == 1) {
				acc = acc + op1;
			};
			i = i >> 1;
			if (i > 0)
				acc = acc << 1;
		];
		for j = 0 to SIZE-1 do {
			return_value[j] = acc[j];
		}
	]
}

/*
 *	divide(a,b)
 */

template function divide(op1, op2) with (SIZE) return boolean[SIZE] 
	in boolean op1[SIZE];
	in boolean op2[SIZE];
{
	boolean tmp[SIZE];
	boolean i[SIZE];

	if (op1 < op2)
		return_value = 0;
	else {
		i = 0;
		tmp = op1;
		while (tmp >= op2) {
			tmp = tmp - op2;
			i++;
		}
		return_value = i;
	}
}

/*
 *	compare(a,b)
 */

declare
template function compare(op1, op2) with (SIZE) return boolean[1]
	in boolean op1[SIZE];
	in boolean op2[SIZE];



