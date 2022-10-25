// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
#include "example.h"
//--------------------------------------------------------
void rtl_model(data_t  a1, data_t  a2, data_t  a3, data_t  a4,
	       data_t  b1, data_t  b2, data_t  b3, data_t  b4,
	       data_t &z1, data_t &z2, data_t &z3, data_t &z4)
{
#pragma HLS inline off
  z1=a1+b1;
  z2=a2+b2;
  z3=a3+b3;
  z4=a4+b4;
}
