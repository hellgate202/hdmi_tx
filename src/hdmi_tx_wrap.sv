module hdmi_tx_wrap #(
  parameter int PX_WIDTH = 10
)(
  input          px_clk_i,
  input          tmds_clk_i,
  input          rst_i,
  input [31 : 0] video_i_tdata,
  input          video_i_tvalid,
  output         video_i_tready,
  input          video_i_tuser,
  input          video_i_tlast,
  output         hdmi_tx2_p_o,
  output         hdmi_tx2_n_o,
  output         hdmi_tx1_p_o,
  output         hdmi_tx1_n_o,
  output         hdmi_tx0_p_o,
  output         hdmi_tx0_n_o,
  output         hdmi_clk_p_o,
  output         hdmi_clk_n_o
);

axi4_stream_if #(
  .TDATA_WIDTH ( 32       ),
  .TID_WIDTH   ( 1        ),
  .TDEST_WIDTH ( 1        ),
  .TUSER_WIDTH ( 1        )
) video_i (
  .aclk        ( px_clk_i ),
  .aresetn     ( !rst_i   )
);

assign video_i.tdata  = video_i_tdata;
assign video_i.tvalid = video_i_tvalid;
assign video_i_tready = video_i.tready;
assign video_i.tlast  = video_i_tlast;
assign video_i.tuser  = video_i_tuser;

hdmi_tx #(
  .PX_WIDTH     ( PX_WIDTH     )
) hdmi_tx (
  .px_clk_i     ( px_clk_i     ),
  .tmds_clk_i   ( tmds_clk_i   ),
  .rst_i        ( rst_i        ),
  .video_i      ( video_i      ),
  .hdmi_tx2_p_o ( hdmi_tx2_p_o ),
  .hdmi_tx2_n_o ( hdmi_tx2_n_o ),
  .hdmi_tx1_p_o ( hdmi_tx1_p_o ),
  .hdmi_tx1_n_o ( hdmi_tx1_n_o ),
  .hdmi_tx0_p_o ( hdmi_tx0_p_o ),
  .hdmi_tx0_n_o ( hdmi_tx0_n_o ),
  .hdmi_clk_p_o ( hdmi_clk_p_o ),
  .hdmi_clk_n_o ( hdmi_clk_n_o )
);

endmodule
