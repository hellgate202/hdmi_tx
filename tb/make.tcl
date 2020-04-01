vlib work
vlog -sv -f files
vopt +acc tb_hdmi_tx -o tb_hdmi_tx_opt
vsim tb_hdmi_tx_opt
do wave.do
run -all
