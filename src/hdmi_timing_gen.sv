import cea861d_1080p30_pkg::*;

module hdmi_timing_gen #(
  parameter int PX_WIDTH = 10
)(
  input                clk_i,
  input                rst_i,
  axi4_stream_if.slave video_i,
  output logic         data_enable_o,
  output logic         hsync_o,
  output logic         vsync_o,
  output logic         preamble_o,
  output logic         gb_o,
  output logic [7 : 0] red_o,
  output logic [7 : 0] green_o,
  output logic [7 : 0] blue_o
);

localparam int PX_CNT_WIDTH    = $clog2( TOTAL_X ) + 1;
localparam int HSYNC_CNT_WIDTH = $clog2( TOTAL_Y ) + 1;

logic [PX_CNT_WIDTH - 1 : 0]    px_cnt;
logic [HSYNC_CNT_WIDTH - 1 : 0] hsync_cnt;

enum logic [2 : 0] { IDLE_S,
                     GEN_VSYNC_S,
                     WAIT_PRE_BLANKING_S,
                     ACTIVE_VIDEO_S,
                     WAIT_POST_BLANKING_S,
                     DROP_S                } state, next_state;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      IDLE_S:
        begin
          if( video_i.tvalid )
            if( video_i.tuser )
              next_state = GEN_VSYNC_S;
            else
              next_state = DROP_S;
        end
      GEN_VSYNC_S:
        begin
          if( hsync_cnt == HSYNC_CNT_WIDTH'( VSYNC_WIDTH ) && 
              px_cnt == PX_CNT_WIDTH'( TOTAL_X - 1 ) )
            next_state = WAIT_PRE_BLANKING_S;
        end
      WAIT_PRE_BLANKING_S:
        begin
          if( hsync_cnt == HSYNC_CNT_WIDTH'( VERTICAL_BLNAKING_PRE ) && 
              px_cnt == PX_CNT_WIDTH'( TOTAL_X - 1 ) )
            next_state = ACTIVE_VIDEO_S;
        end
      ACTIVE_VIDEO_S:
        begin
          if( hsync_cnt == HSYNC_CNT_WIDTH'( VERTICAL_BLNAKING_PRE + ACTIVE_LINES ) &&
              px_cnt == PX_CNT_WIDTH'( TOTAL_X - 1 ) )
            next_state =  WAIT_POST_BLANKING_S;
        end
      WAIT_POST_BLANKING_S:
        begin
          if( hsync_cnt == HSYNC_CNT_WIDTH'( TOTAL_Y ) && 
              px_cnt == PX_CNT_WIDTH'( TOTAL_X - 1 ) )
            if( video_i.tvalid && video_i.tuser )
              next_state = GEN_VSYNC_S;
            else
              next_state = IDLE_S;
        end
      DROP_S:
        begin
          if( video_i.tvalid && video_i.tlast )
            next_state = IDLE_S;
        end
    endcase
  end
                     
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    px_cnt <= PX_CNT_WIDTH'( 0 );
  else
    if( state != IDLE_S )
      if( px_cnt == PX_CNT_WIDTH'( TOTAL_X - 1 ) )
        px_cnt <= PX_CNT_WIDTH'( 0 );
      else
        px_cnt <= px_cnt + 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    hsync_cnt <= HSYNC_CNT_WIDTH'( 0 );
  else
    if( state != IDLE_S && px_cnt == PX_CNT_WIDTH'( 0 ) )
      if( hsync_cnt == HSYNC_CNT_WIDTH'( TOTAL_Y ) )
        hsync_cnt <= HSYNC_CNT_WIDTH'( 0 );
      else
        hsync_cnt <= hsync_cnt + 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      hsync_o       <= 1'b0;
      vsync_o       <= 1'b0;
      data_enable_o <= 1'b0;
      preamble_o    <= 1'b0;
      gb_o          <= 1'b0;
    end
  else
    begin
      hsync_o       <= state != IDLE_S && px_cnt < PX_CNT_WIDTH'( HSYNC_WIDTH );
      vsync_o       <= state == GEN_VSYNC_S;
      data_enable_o <= state == ACTIVE_VIDEO_S && 
                       px_cnt > PX_CNT_WIDTH'( HSYNC_NEGEDGE_TO_DE_POSEDGE + HSYNC_WIDTH - 1 ) &&
                       px_cnt < PX_CNT_WIDTH'( TOTAL_X - DE_NEGEDGE_TO_HSYNC_POSEDGE );
      preamble_o    <= state == ACTIVE_VIDEO_S && 
                       px_cnt > PX_CNT_WIDTH'( HSYNC_NEGEDGE_TO_DE_POSEDGE + HSYNC_WIDTH - 11 ) &&
                       px_cnt < PX_CNT_WIDTH'( HSYNC_NEGEDGE_TO_DE_POSEDGE + HSYNC_WIDTH - 2 );
      gb_o          <= state == ACTIVE_VIDEO_S && 
                       px_cnt > PX_CNT_WIDTH'( HSYNC_NEGEDGE_TO_DE_POSEDGE + HSYNC_WIDTH - 3 ) &&
                       px_cnt < PX_CNT_WIDTH'( HSYNC_NEGEDGE_TO_DE_POSEDGE + HSYNC_WIDTH );
    end


assign video_i.tready = data_enable_o || state == DROP_S;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      red_o   <= '0;
      green_o <= '0;
      blue_o  <= '0;
    end
  else
    begin
      red_o   <= video_i.tdata[PX_WIDTH * 3 - 1 -: 8];
      green_o <= video_i.tdata[PX_WIDTH * 1 - 1 -: 8];
      blue_o  <= video_i.tdata[PX_WIDTH * 2 - 1 -: 8];
    end

endmodule
