`include "../lib/axi4_lib/src/class/AXI4StreamVideoSource.sv"

`timescale 1 ps / 1 ps

module tb_hdmi_tx;

parameter int    CLK_T       = 13468;
parameter int    FRAME_RES_X = 1920;
parameter int    FRAME_RES_Y = 1080;
parameter int    TOTAL_X     = 1920;
parameter int    TOTAL_Y     = 1080;
parameter int    PX_WIDTH    = 32;
parameter string FILE_PATH   = "./img.hex";

bit clk;
bit rst;

task automatic gen_clk();
  forever
    begin
      #( CLK_T / 2 );
      clk = !clk;
    end
endtask

task automatic apply_rst();
  rst = 1'b1;
  @( posedge clk );
  rst = 1'b0;
endtask

axi4_stream_if #(
  .TDATA_WIDTH ( 32   ),
  .TID_WIDTH   ( 1    ),
  .TDEST_WIDTH ( 1    ),
  .TUSER_WIDTH ( 1    )
) video_i (
  .aclk        ( clk  ),
  .aresetn     ( !rst )
);

AXI4StreamVideoSource #(
  .PX_WIDTH    ( PX_WIDTH    ),
  .FRAME_RES_X ( FRAME_RES_X ),
  .FRAME_RES_Y ( FRAME_RES_Y ),
  .TOTAL_X     ( TOTAL_X     ),
  .TOTAL_Y     ( TOTAL_Y     ),
  .FILE_PATH   ( FILE_PATH   )
) video_gen;

hdmi_timing_gen DUT
(
  .clk_i          ( clk            ),
  .rst_i          ( rst            ),
  .video_i        ( video_i        ),
  .data_enable_o  (                ),
  .hsync_o        (                ),
  .vsync_o        (                ),
  .preamble_o     (                ),
  .gb_o           (                )
);

initial
  begin
    video_gen = new( video_i );
    fork
      gen_clk();
      apply_rst();
      video_gen.run();
    join_none
    repeat( 3)
      begin
        while( !( video_i.tvalid && video_i.tuser && video_i.tready ) )
          @( posedge clk );
        @( posedge clk );
      end
    $stop();
  end

endmodule
