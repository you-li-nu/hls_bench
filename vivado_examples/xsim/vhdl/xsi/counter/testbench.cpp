#include <stdlib.h>
#include <string>
#include <cstring>
#include <iostream>

#include "xsi_loader.h"

const char* expected_out[15] = {"0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"};

const char* std_logic_literal[]={"U", "X", "0", "1", "Z", "W", "L", "H", "-"};

std::string display_value(const char *count, int size)
{
    std::string res;
    for (int i=0; i < size; i++)
       res +=  std_logic_literal[count[i]];
    return res;
}

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

int main(int argc, char **argv)
{
    std::string cwd = getcurrentdir();
    std::string simengine_libname = "librdi_simulator_kernel";
    
#if defined(_WIN32)
    const char* lib_extension = ".dll";
#else
    const char* lib_extension = ".so";
#endif
    simengine_libname += lib_extension;

    //std::string design_libname = getcurrentdir() + "/xsim.dir/counter/xsimk" + lib_extension;
    std::string design_libname = "xsim.dir/counter/xsimk";
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

    // constants 
    const char one_val  = 3;
    const char zero_val = 2;
    const char zero_val_vec[2] = {2, 2};
    const char one_val_vec[2]  = {3, 3};

    // Output value
    char count_val[4] = {2, 2, 2, 2};

    // Ports
    int reset;
    int clk;
    int enable;
    int count;

    // my variables 
    int count_success = 0;
    int status = 0;

    try {
        Xsi::Loader Xsi_Instance(design_libname, simengine_libname);
        s_xsi_setup_info info;
        memset(&info, 0, sizeof(info));
        info.logFileName = NULL;
        char wdbName[] = "test.wdb";
        info.wdbFileName = wdbName;
        Xsi_Instance.open(&info);
        Xsi_Instance.trace_all();
        reset = Xsi_Instance.get_port_number("reset");
        if(reset <0) {
          std::cerr << "ERROR: reset not found" << std::endl;
          exit(1);
        }
        clk = Xsi_Instance.get_port_number("clk");
        if(clk <0) {
          std::cerr << "ERROR: clk not found" << std::endl;
          exit(1);
        }
        enable = Xsi_Instance.get_port_number("enable");
        if(enable <0) {
          std::cerr << "ERROR: enable not found" << std::endl;
          exit(1);
        }
        count = Xsi_Instance.get_port_number("count");
        if(count <0) {
          std::cerr << "ERROR: count not found" << std::endl;
          exit(1);
        }

        // Start low clock
        Xsi_Instance.put_value(clk, &zero_val);
        Xsi_Instance.run(10);

        // Reset to 1 and clock it
        Xsi_Instance.put_value(reset, &one_val);
        Xsi_Instance.put_value(enable, &zero_val);
        Xsi_Instance.put_value(clk, &one_val);
        Xsi_Instance.run(10);

        // Put clk to 0, reset to 0 and enable to 1
        Xsi_Instance.put_value(clk, &zero_val);
        Xsi_Instance.put_value(reset, &zero_val);
        Xsi_Instance.put_value(enable, &one_val);

        
        std::string count_val_string;
        // The reset is done. Now start counting
        std::cout << "\n *** starting to count ***\n";
        for (int i=0; i < 15; i++) {
           Xsi_Instance.put_value(clk, &one_val);
           Xsi_Instance.run(10);

           // read the output
           Xsi_Instance.get_value(count, count_val);
        
           count_val_string = display_value(count_val, 4);
           std::cout << count_val_string << std::endl;
           if( count_val_string.compare(expected_out[i]) == 0) {
              count_success++;
           }
           // Put clk to zero
           Xsi_Instance.put_value(clk, &zero_val);
           Xsi_Instance.run(10);
        }
        std::cout << "\n *** done counting ***\n";
        
        std::cout << "Total successful checks: " << count_success <<"\n";
        status = (count_success == 15) ? 0:1;

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


