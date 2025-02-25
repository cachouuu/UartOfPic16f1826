onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TOP LEVEL INPUTS}
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rs232_1/rst
add wave -noupdate /testbench/rs232_1/rx
add wave -noupdate -divider RECEIVE
add wave -noupdate -radix unsigned /testbench/rs232_1/rx0/rx_data
add wave -noupdate -label RCIF {/testbench/cpu1/PIR1[5]}
add wave -noupdate -divider {PIC spr}
add wave -noupdate -radix unsigned -childformat {{{/testbench/cpu1/RCREG[7]} -radix hexadecimal} {{/testbench/cpu1/RCREG[6]} -radix hexadecimal} {{/testbench/cpu1/RCREG[5]} -radix hexadecimal} {{/testbench/cpu1/RCREG[4]} -radix hexadecimal} {{/testbench/cpu1/RCREG[3]} -radix hexadecimal} {{/testbench/cpu1/RCREG[2]} -radix hexadecimal} {{/testbench/cpu1/RCREG[1]} -radix hexadecimal} {{/testbench/cpu1/RCREG[0]} -radix hexadecimal}} -subitemconfig {{/testbench/cpu1/RCREG[7]} {-height 15 -radix hexadecimal} {/testbench/cpu1/RCREG[6]} {-height 15 -radix hexadecimal} {/testbench/cpu1/RCREG[5]} {-height 15 -radix hexadecimal} {/testbench/cpu1/RCREG[4]} {-height 15 -radix hexadecimal} {/testbench/cpu1/RCREG[3]} {-height 15 -radix hexadecimal} {/testbench/cpu1/RCREG[2]} {-height 15 -radix hexadecimal} {/testbench/cpu1/RCREG[1]} {-height 15 -radix hexadecimal} {/testbench/cpu1/RCREG[0]} {-height 15 -radix hexadecimal}} /testbench/cpu1/RCREG
add wave -noupdate -radix unsigned /testbench/cpu1/TXREG
add wave -noupdate -radix unsigned /testbench/cpu1/port_b_out
add wave -noupdate -divider TRANSMIT
add wave -noupdate -radix unsigned /testbench/rs232_1/tx0/tx_data
add wave -noupdate /testbench/rs232_1/tx0/tx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2469268800 ps} 0}
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
WaveRestoreZoom {0 ps} {3200904 ns}
