onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/reset
add wave -noupdate /tb/clk
add wave -noupdate /tb/MAX_MSG_LENGTH
add wave -noupdate /tb/SUM_OF_STUDENTS_ID
add wave -noupdate /tb/NUM_MSGS
add wave -noupdate /tb/MSG_IDX
add wave -noupdate /tb/qpsk_msg_q
add wave -noupdate /tb/qpsk_msg_i
add wave -noupdate /tb/sym_q
add wave -noupdate /tb/sym_i
add wave -noupdate /tb/sym_idx
add wave -noupdate /tb/iq_valid
add wave -noupdate /tb/iq_idx
add wave -noupdate /tb/data_valid
add wave -noupdate /tb/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {3481 ps}
