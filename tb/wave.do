onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_hdmi_tx/DUT/clk_i
add wave -noupdate /tb_hdmi_tx/DUT/rst_i
add wave -noupdate /tb_hdmi_tx/DUT/data_enable_o
add wave -noupdate /tb_hdmi_tx/DUT/hsync_o
add wave -noupdate /tb_hdmi_tx/DUT/vsync_o
add wave -noupdate /tb_hdmi_tx/DUT/preamble_o
add wave -noupdate /tb_hdmi_tx/DUT/gb_o
add wave -noupdate /tb_hdmi_tx/DUT/red_o
add wave -noupdate /tb_hdmi_tx/DUT/green_o
add wave -noupdate /tb_hdmi_tx/DUT/blue_o
add wave -noupdate /tb_hdmi_tx/DUT/px_cnt
add wave -noupdate /tb_hdmi_tx/DUT/hsync_cnt
add wave -noupdate /tb_hdmi_tx/DUT/state
add wave -noupdate /tb_hdmi_tx/DUT/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43418736 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 343
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
WaveRestoreZoom {0 ps} {33408894874 ps}
