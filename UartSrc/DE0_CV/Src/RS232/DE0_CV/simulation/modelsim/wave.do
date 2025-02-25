onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TOP LEVEL INPUTS}
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate -radix hexadecimal /testbench/send_data
add wave -noupdate -divider RX
add wave -noupdate /testbench/rs232_1/rx
add wave -noupdate /testbench/rs232_1/rx0/bit_flag
add wave -noupdate /testbench/rs232_1/rx0/rx_finish
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/rs232_1/rx0/rx_data[7]} -radix unsigned} {{/testbench/rs232_1/rx0/rx_data[6]} -radix unsigned} {{/testbench/rs232_1/rx0/rx_data[5]} -radix unsigned} {{/testbench/rs232_1/rx0/rx_data[4]} -radix unsigned} {{/testbench/rs232_1/rx0/rx_data[3]} -radix unsigned} {{/testbench/rs232_1/rx0/rx_data[2]} -radix unsigned} {{/testbench/rs232_1/rx0/rx_data[1]} -radix unsigned} {{/testbench/rs232_1/rx0/rx_data[0]} -radix unsigned}} -subitemconfig {{/testbench/rs232_1/rx0/rx_data[7]} {-height 15 -radix unsigned} {/testbench/rs232_1/rx0/rx_data[6]} {-height 15 -radix unsigned} {/testbench/rs232_1/rx0/rx_data[5]} {-height 15 -radix unsigned} {/testbench/rs232_1/rx0/rx_data[4]} {-height 15 -radix unsigned} {/testbench/rs232_1/rx0/rx_data[3]} {-height 15 -radix unsigned} {/testbench/rs232_1/rx0/rx_data[2]} {-height 15 -radix unsigned} {/testbench/rs232_1/rx0/rx_data[1]} {-height 15 -radix unsigned} {/testbench/rs232_1/rx0/rx_data[0]} {-height 15 -radix unsigned}} /testbench/rs232_1/rx0/rx_data
add wave -noupdate /testbench/rs232_1/rx0/rx_ps
add wave -noupdate -radix hexadecimal /testbench/rs232_1/rx0/reg_data
add wave -noupdate -divider PACKAGE
add wave -noupdate /testbench/rs232_1/rx0/pkg_ready
add wave -noupdate /testbench/rs232_1/rx0/write
add wave -noupdate /testbench/rs232_1/rx0/read
add wave -noupdate /testbench/rs232_1/tx0/tx_req
add wave -noupdate /testbench/rs232_1/tx0/tx_ack
add wave -noupdate -divider TX
add wave -noupdate /testbench/rs232_1/tx0/tx
add wave -noupdate /testbench/rs232_1/tx0/bit_flag
add wave -noupdate /testbench/rs232_1/tx0/load_tx_data
add wave -noupdate /testbench/rs232_1/tx0/send_tx_data
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/rs232_1/tx0/tx_data[7]} -radix hexadecimal} {{/testbench/rs232_1/tx0/tx_data[6]} -radix hexadecimal} {{/testbench/rs232_1/tx0/tx_data[5]} -radix hexadecimal} {{/testbench/rs232_1/tx0/tx_data[4]} -radix hexadecimal} {{/testbench/rs232_1/tx0/tx_data[3]} -radix hexadecimal} {{/testbench/rs232_1/tx0/tx_data[2]} -radix hexadecimal} {{/testbench/rs232_1/tx0/tx_data[1]} -radix hexadecimal} {{/testbench/rs232_1/tx0/tx_data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/rs232_1/tx0/tx_data[7]} {-height 15 -radix hexadecimal} {/testbench/rs232_1/tx0/tx_data[6]} {-height 15 -radix hexadecimal} {/testbench/rs232_1/tx0/tx_data[5]} {-height 15 -radix hexadecimal} {/testbench/rs232_1/tx0/tx_data[4]} {-height 15 -radix hexadecimal} {/testbench/rs232_1/tx0/tx_data[3]} {-height 15 -radix hexadecimal} {/testbench/rs232_1/tx0/tx_data[2]} {-height 15 -radix hexadecimal} {/testbench/rs232_1/tx0/tx_data[1]} {-height 15 -radix hexadecimal} {/testbench/rs232_1/tx0/tx_data[0]} {-height 15 -radix hexadecimal}} /testbench/rs232_1/tx0/tx_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6261956029 ps} 0} {{Cursor 2} {12982041980 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {6427092 ns}
