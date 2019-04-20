module hdmi_tx #(
  parameter int X_RES    = 1920,
  parameter int Y_RES    = 1080,
  parameter int PX_WIDTH = 10
)(
  input                px_clk_i,
  input                tmds_clk_i,
  input                rst_i,
  axi4_stream_if.slave video_i,
  output               hdmi_tx2_p_o,
  output               hdmi_tx2_n_o,
  output               hdmi_tx1_p_o,
  output               hdmi_tx1_n_o,
  output               hdmi_tx0_p_o,
  output               hdmi_tx0_n_o,
  output               hdmi_clk_p_o,
  output               hdmi_clk_n_o
);

logic [7 : 0] red;
logic [7 : 0] green;
logic [7 : 0] blue;
logic         px_valid;
logic         h_sync;
logic         v_sync;
logic [9 : 0] tmds_red;
logic [9 : 0] tmds_green;
logic [9 : 0] tmds_blue;

logic rst_d1;
logic rst_d2;
logic px_clk_rst;

always_ff @( posedge px_clk_i, rst_i )
  if( rst_i )
    begin
      rst_d1 <= 1'b1;
      rst_d2 <= 1'b1;
    end
  else
    begin
      rst_d1 <= 1'b0;
      rst_d2 <= rst_d1;
    end

assign px_clk_rst = rst_d2;

axi4_video_to_hv_conv #(
  .X_RES        ( X_RES      ),
  .Y_RES        ( Y_RES      ),
  .PX_WIDTH     ( PX_WIDTH   )
) video_conv (
  .clk_i        ( px_clk_i   ),
  .rst_i        ( px_clk_rst ),
  .axi4_video_i ( video_i    ),
  .red_o        ( red        ),
  .green_o      ( green      ),
  .blue_o       ( blue       ),
  .px_valid_o   ( px_valid   ),
  .h_sync_o     ( h_sync     ),
  .v_sync_o     ( v_sync     )
);

tmds_enc tmds_red_channel
(
  .clk_i         ( px_clk_i   ),
  .rst_i         ( px_clk_rst ),
  .px_data_i     ( red        ),
  .px_data_val_i ( px_valid   ),
  .ctl_0_i       ( 1'b0       ),
  .ctl_1_i       ( 1'b0       ),
  .tmds_data_o   ( tmds_red   )
);

tmds_enc tmds_green_channel
(
  .clk_i         ( px_clk_i   ),
  .rst_i         ( px_clk_rst ),
  .px_data_i     ( green      ),
  .px_data_val_i ( px_valid   ),
  .ctl_0_i       ( 1'b0       ),
  .ctl_1_i       ( 1'b0       ),
  .tmds_data_o   ( tmds_green )
);

tmds_enc tmds_blue_channel
(
  .clk_i         ( px_clk_i   ),
  .rst_i         ( px_clk_rst ),
  .px_data_i     ( blue       ),
  .px_data_val_i ( px_valid   ),
  .ctl_0_i       ( h_sync     ),
  .ctl_1_i       ( v_sync     ),
  .tmds_data_o   ( tmds_blue  )
);

hdmi_phy phy
(
  .px_clk_i       ( px_clk_i     ),
  .tmds_clk_i     ( tmds_clk_i   ),
  .rst_i          ( px_clk_rst   ),
  .tmds_red_i     ( tmds_red     ),
  .tmds_green_i   ( tmds_green   ),
  .tmds_blue_i    ( tmds_blue    ),
  .hdmi_red_p_o   ( hdmi_tx2_p_o ),
  .hdmi_red_n_o   ( hdmi_tx2_n_o ),
  .hdmi_green_p_o ( hdmi_tx1_p_o ),
  .hdmi_green_n_o ( hdmi_tx1_n_o ),
  .hdmi_blue_p_o  ( hdmi_tx0_p_o ),
  .hdmi_blue_n_o  ( hdmi_tx0_n_o ),
  .hdmi_clk_p_o   ( hdmi_clk_p_o ),
  .hdmi_clk_n_o   ( hdmi_clk_n_o )
);

endmodule
