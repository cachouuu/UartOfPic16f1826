onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {OUTPUT}

add wave -noupdate -format logic				 		/testbench/clk
add wave -noupdate -format logic				 		/testbench/rst
add wave -noupdate -format Literal -radix Hexadecimal 	/testbench/W_q
add wave -noupdate -format logic				 		/testbench/top1/BRA
add wave -noupdate -format Literal -radix Hexadecimal 	/testbench/top1/ram1/ram\[33\]
add wave -noupdate -format Literal -radix Hexadecimal 	/testbench/top1/ram1/ram\[34\]
add wave -noupdate -format Literal -radix Hexadecimal 	/testbench/port_b_out

