Simple HDMI Transmitter
=======================

Following IP-core realises TMDS encoding from AXI4-Video stream.

DDC and other features are not supported. Only straight AXI4-Stream TMDS conversion.

Video interface is constructed in similar to UG-934 (EOL - tlast, FRAME START - tuser)

Only 10 bit RGB is supported. But I beleive you can run other modes with unsignificant code
modifications.

IP-core tested with following hardware:

  * Digelent Zybo Z7-20 Development Board
  * Philips 240v5 Monitor

Operating mode:

  * RGB 10 bit
  * 1080p
  * 60 FPS

px_clk_i was 148.5 MHz

tmds_clk_i was 742.5 MHz

It is an ok condition that Vivado (2018.3.1) tells that timing requirements wasn't met
for pulse width of TMDS clk. Because FMAX for BUFG and OSERDESE2 is 600 MHz. Hence, it works. 

Example project can be found here:

https://github.com/hellgate202/zybo_z7_hdmi_test
