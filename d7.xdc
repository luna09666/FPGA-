# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]       
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Switches
    set_property PACKAGE_PIN U1 [get_ports set3]     
 set_property IOSTANDARD LVCMOS33 [get_ports set3]
set_property PACKAGE_PIN W2 [get_ports set4]     
 set_property IOSTANDARD LVCMOS33 [get_ports set4]
set_property PACKAGE_PIN R3 [get_ports set5]     
 set_property IOSTANDARD LVCMOS33 [get_ports set5]
set_property PACKAGE_PIN T2 [get_ports set6]     
 set_property IOSTANDARD LVCMOS33 [get_ports set6]
  set_property PACKAGE_PIN V2 [get_ports set9]     
 set_property IOSTANDARD LVCMOS33 [get_ports set9]
   set_property PACKAGE_PIN W13 [get_ports set10]     
 set_property IOSTANDARD LVCMOS33 [get_ports set10]
   set_property PACKAGE_PIN W14 [get_ports set11]     
 set_property IOSTANDARD LVCMOS33 [get_ports set11]



##Buttons
set_property PACKAGE_PIN W19 [get_ports set1]      
 set_property IOSTANDARD LVCMOS33 [get_ports set1]
set_property PACKAGE_PIN T17 [get_ports set2]      
 set_property IOSTANDARD LVCMOS33 [get_ports set2]
set_property PACKAGE_PIN U18 [get_ports clr]      
 set_property IOSTANDARD LVCMOS33 [get_ports clr]
 
# LEDs
set_property PACKAGE_PIN L1 [get_ports led1]     
 set_property IOSTANDARD LVCMOS33 [get_ports led1]
set_property PACKAGE_PIN P1 [get_ports led2]     
 set_property IOSTANDARD LVCMOS33 [get_ports led2]
set_property PACKAGE_PIN U16 [get_ports led3]     
 set_property IOSTANDARD LVCMOS33 [get_ports led3]
 set_property PACKAGE_PIN U14 [get_ports led4]     
 set_property IOSTANDARD LVCMOS33 [get_ports led4]

#7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg7[0]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {seg7[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg7[1]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {seg7[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg7[2]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {seg7[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg7[3]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {seg7[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg7[4]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {seg7[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg7[5]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {seg7[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg7[6]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {seg7[6]}]

set_property PACKAGE_PIN V7 [get_ports dp]       
 set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]     
 set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]