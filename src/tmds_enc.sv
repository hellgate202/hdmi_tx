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

always_comb
  begin
    ones_in_px = '0;
    for( int i = 0; i < 8; i++ )
      ones_in_px = ones_in_px + px_data_i[i];
  end

endmodule
