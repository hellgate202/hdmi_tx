module axi4_video_to_hv_conv #(
  parameter int X_RES    = 1920,
  parameter int Y_RES    = 1080,
  parameter int PX_WIDTH = 10
)(
  input                clk_i,
  input                rst_i,
  axi4_stream_if.slave axi4_video_i,
  output logic [7 : 0] red_o,
  output logic [7 : 0] green_o,
  output logic [7 : 0] blue_o,
  output logic         px_valid_o,
  output logic         h_sync_o,
  output logic         v_sync_o
);

localparam int PX_CNT_WIDTH = $clog2( X_RES );
localparam int LN_CNT_WIDTH = $clog2( Y_RES );

logic [PX_CNT_WIDTH : 0] px_cnt;
logic [LN_CNT_WIDTH : 0] ln_cnt;

assign axi4_video_i.tready = 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    px_cnt <= '0;
  else
    if( axi4_video_i.tvalid && axi4_video_i.tlast )
      px_cnt <= '0;
    else
      if( axi4_video_i.tvalid && px_cnt < X_RES )
        px_cnt <= px_cnt + 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    ln_cnt <= '0;
  else
    if( axi4_video_i.tvalid && axi4_video_i.tuser )
      ln_cnt <= '0;
    else
      if( axi4_video_i.tvalid && axi4_video_i.tlast && 
          ln_cnt < Y_RES )
        ln_cnt <= ln_cnt + 1'b1;


always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    px_valid_o <= 1'b0;
  else
    if( px_cnt < X_RES && ln_cnt < Y_RES )
      px_valid_o <= axi4_video_i.tvalid;
    else
      px_valid_o <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    h_sync_o <= 1'b0;
  else
    if( axi4_video_i.tvalid && axi4_video_i.tlast )
      h_sync_o <= 1'b1;
    else
      if( axi4_video_i.tvalid )
        h_sync_o <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    v_sync_o <= 1'b0;
  else
    if( axi4_video_i.tvalid && axi4_video_i.tlast &&
        ln_cnt == ( Y_RES - 1 ) )
      v_sync_o <= 1'b1;
    else
      if( axi4_video_i.tvalid && axi4_video_i.tuser )
        v_sync_o <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      red_o   <= '0;
      green_o <= '0;
      blue_o  <= '0;
    end
  else
    begin
      red_o   <= axi4_video_i.tdata[PX_WIDTH * 3 - 1 -: 8];
      green_o <= axi4_video_i.tdata[PX_WIDTH * 1 - 1 -: 8];
      blue_o  <= axi4_video_i.tdata[PX_WIDTH * 2 - 1 -: 8];
    end

endmodule
