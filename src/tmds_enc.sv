module tmds_enc
(
  input          clk_i,
  input          rst_i,
  input  [7 : 0] px_data_i,
  input          px_data_valid_i,
  input          h_sync_i,
  input          v_sync_i,
  output [9 : 0] tmds_data_o,
  output         tmds_data_valid_o
);

logic [3 : 0] ones_in_px;
logic [3 : 0] ones_in_px_comb;
logic [7 : 0] px_data_d1;
logic         h_sync_d1, h_sync_d2;
logic         v_sync_d1, v_sync_d2;
logic         xor_xnor;
logic [8 : 0] q_m;
logic [4 : 0] disp_cnt;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    ones_in_px <= '0;
  else
    ones_in_px <= ones_in_px_comb;

always_comb
  begin
    ones_in_px_comb = '0;
    for( int i = 0; i < 8; i++ )
      ones_in_px_comb = ones_in_px_comb + px_data_i[i];
  end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      px_data_d1 <= '0;
      h_sync_d1  <= '0;
      h_sync_d2  <= '0;
      v_sync_d1  <= '0;
      v_sync_d2  <= '0;
    end
  else
    begin
      px_data_d1 <= px_data_i;
      h_sync_d1  <= h_sync_i;
      h_sync_d2  <= h_sync_d1;
      v_sync_d1  <= v_sync_i;
      v_sync_d2  <= v_sync_d1;
    end

assign xor_xnor = ( ones_in_px > 4'd4 ) || ( ( ones_in_px == 4'd4 ) && !px_data_d1[0] );

always_ff @( posedge clk_i, posedge rst_i )
  if ( rst_i )
    q_m <= '0;
  else
    if( xor_xnor )
      begin
        q_m[0] <= px_data_d1[0];
        q_m[8] <= 1'b0;
        for( int i = 0; i < 7; i++ )
          q_m[i + 1] <= q_m[i] ~^ px_data_d1[i + 1];
      end
    else
      begin
        q_m[0] <= px_data_d1[0];
        q_m[8] <= 1'b1;
        for( int i = 0; i < 7; i++ )
          q_m[i + 1] <= q_m[i] ^ px_data_d1[i + 1];
      end

endmodule
