// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
#include "resource_uram.h"

int main()
{
	addr_t addrwrite, addrread;
	data_t data, dataout;
	int i, j, retval = 0, errors = 0;

	// File to write the results
	ofstream fout("result.dat");

	// Write data (square of the address)
	for(i=0; i<10; i++)
	{
		resource_uram(1,0,i,i*i,addrread,&dataout);
		cout << "Write address =" << right << setw(3) << i <<endl;
		cout << "Write data    =" << right << setw(3) << i*i << endl;
	}

	// Read data & check
	for(j=0; j<10; j++)
	{
		resource_uram(0,1,addrwrite,data,j,&dataout);
		cout << "Read address =" << right << setw(3) << j << endl;
		cout << "Read data    =" << right << setw(3) << dataout << endl;
		fout << dataout << endl; 
		errors += dataout != j*j;
	}

	fout.close();
	
	// Compare the results file with the golden results
	retval = system("diff --brief -w result.dat result.golden.dat");
	if (retval != 0) {
	  cout << "Test failed  !!!" << endl; 
	  retval=1;
	} else {
	  cout << "Test passed !" << endl;
	}

	return errors;
}
