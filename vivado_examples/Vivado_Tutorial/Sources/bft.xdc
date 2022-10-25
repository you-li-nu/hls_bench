create_clock -name wbClk -period 10 [get_ports wbClk]
create_clock -name bftClk -period 5 [get_ports bftClk]

# Since this sample design is not meant to be stand alone, but exist in a larger
# design, there are no input/output delays specified. Timing will not be done 
# on these interfaces by default.
