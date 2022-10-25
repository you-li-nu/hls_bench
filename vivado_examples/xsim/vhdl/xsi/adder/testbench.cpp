#include <stdlib.h>
#include <string>
#include <cstring>
#include <iostream>

#include "xsi_loader.h"

std::string getcurrentdir()
{
#if defined(_WIN32)
    char buf[MAX_PATH];
    GetCurrentDirectory(sizeof(buf), buf);
    buf[sizeof(buf)-1] = 0;
    return buf;
#else
    char buf[1024];
    //getcwd(buf, sizeof(buf)-1);
    buf[sizeof(buf)-1] = 0;
    return buf;
#endif
}
namespace {
    const char* port_direction_string(int xsi_value) {
        switch (xsi_value) {
            case 0: return "INVALID";
            case 1: return "IN";
            case 2: return "OUT";
            case 3: return "INOUT";
            default: return "INVALID";
        }
        return "INVALID";
    }
}
const char* std_logic_literal[]={"U", "X", "0", "1", "Z", "W", "L", "H", "-"};

std::string display_value(const char *count, int size)
{
    std::string res;
    for (int i = 0; i < size; i++)
        res += std_logic_literal[count[i]];
    return res;
}


int main(int argc, char **argv)
{
    std::string simengine_libname = "librdi_simulator_kernel";
    
#if defined(_WIN32)
    const char* lib_extension = ".dll";
#else
    const char* lib_extension = ".so";
#endif
    simengine_libname += lib_extension;

//    std::string design_libname = getcurrentdir() + "/xsim.dir/adder/xsimk" + lib_extension;
    std::string design_libname = "xsim.dir/adder/xsimk";
    design_libname = design_libname + lib_extension;

    std::cout << "Design DLL     : " << design_libname << std::endl;
    std::cout << "Sim Engine DLL : " << simengine_libname << std::endl;

    /* Note: VHDL std_logic value is stored in a byte (char). The 
     * MVL9 values are mapped as  'U':00, 'X':1, '0':2, '1':3
     * 'Z':4, 'W':5, 'L':6, 'H':7, '-':8 . The std_logic_vector 
     * is stored as a contiguous array of bytes. For example 
     * "0101Z" is stored in five bytes as char s[5] = {2,3,2,3,4}
     * An HDL integer type is stored as C int, a HDL real type is 
     * stored as a C double and a VHDL string type is stored as char*.
     * An array of HDL integer or double is stored as an array of C
     * integer or double respectively       
     */ 

    // Constants 
    const char one_val  = 3;
    const char zero_val = 2;
    const int cycle = 16;

    // Input and Output values
    char clk_val = zero_val; // "0"
    char rst_val = zero_val; // "0"
    char a_val[16]  = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}; // X"0000"
    char b_val[16]  = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}; // X"0000"
    char sum_val[16]= {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}; // X"0000"

    // Temp values
    char temp_std_logic;
    char temp_std_logic_vector[16];

    // Port Ids
    int clk;
    int rst;
    int a;
    int b;
    int sum;

    // My variables 
    int status = 0;

    try {

        // Load the design
        Xsi::Loader Xsi_Instance(design_libname, simengine_libname);
        s_xsi_setup_info info;
        memset(&info, 0, sizeof(info));
        info.logFileName = NULL;
        Xsi_Instance.open(&info);

        // Get Port Ids
        clk = Xsi_Instance.get_port_number("clk");
        if(clk <0) {
          std::cerr << "ERROR: Port clk not found" << std::endl;
          exit(1);
        }
        rst = Xsi_Instance.get_port_number("rst");
        if(rst <0) {
          std::cerr << "ERROR: Port rst not found" << std::endl;
          exit(1);
        }
        a = Xsi_Instance.get_port_number("a");
        if(a <0) {
          std::cerr << "ERROR: Port a not found" << std::endl;
          exit(1);
        }
        b = Xsi_Instance.get_port_number("b");
        if(b <0) {
          std::cerr << "ERROR: Port b  not found" << std::endl;
          exit(1);
        }
        sum = Xsi_Instance.get_port_number("sum");
        if(sum <0) {
          std::cerr << "ERROR: Port sum not found" << std::endl;
          exit(1);
        }

        // Debug: Iterate through the ports and print their name, direction, and value size (bytes)
        for(int i = 0; i < Xsi_Instance.num_ports(); i++) {
            std::cout
            << "Port name = " << Xsi_Instance.get_str_property_port(i, xsiNameTopPort) << " : "
            << "Port direction = " << port_direction_string(Xsi_Instance.get_int_property_port(i, xsiDirectionTopPort)) << " : "
            << "Port value size (bytes) = " << Xsi_Instance.get_int_property_port(i, xsiHDLValueSize)
            << std::endl;
        }
        
        int status;
        std::string add_val_string_1;

        // Time 0
        std::cout << "Time = 0" << std::endl;
        Xsi_Instance.display_port_values();

        // Asynchronous reset and set clock to zero for an edge later
        Xsi_Instance.put_value(rst, &one_val);
        Xsi_Instance.put_value(clk, &zero_val);
        Xsi_Instance.run(10);
   
        // Time 10
        std::cout << "Time = 10" << std::endl;
        Xsi_Instance.display_port_values();


	// Set a to 1 and b to 2, sum should be 4 after reset is lifted
        a_val[15] = 3; //X0001
        b_val[14] = 3; //X0002
        // Time 20 reset goes to 0
        Xsi_Instance.put_value(rst, &zero_val);
        Xsi_Instance.put_value(a, a_val);
        Xsi_Instance.put_value(b, b_val);
        Xsi_Instance.run(0);

        // Time 20
        std::cout << "Time = 10" << std::endl;
        // Check a and b should have changed
        Xsi_Instance.display_port_values();
        // Now give posedge clock
        Xsi_Instance.put_value(clk, &one_val);
        Xsi_Instance.run(10);

        // Time 30
        std::cout << "Time = 30" << std::endl;
        // Check sum should have changed
        Xsi_Instance.display_port_values();

        Xsi_Instance.get_value(sum, sum_val); 
        if(sum_val[14] == 3 && sum_val[15] == 3) {
           status = 0;
        } else {
           status = 1;
        }

        // Just a check to rewind time to 0
        Xsi_Instance.restart();

    }
    catch (std::exception& e) {
        std::cerr << "ERROR: An exception occurred: " << e.what() << std::endl;
        status = 2;
    }
    catch (...) {
        std::cerr << "ERROR: An unknown exception occurred." << std::endl;
        status = 3;
    }

    if(status == 0) {
      std::cout << "PASSED test\n";
    } else {
      std::cout << "FAILED test\n";
    }
    exit(status);
}


