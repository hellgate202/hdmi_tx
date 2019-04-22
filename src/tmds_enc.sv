module tmds_enc
(
  input          clk_i,
  input          rst_i,
  input  [7 : 0] px_data_i,
  input          px_data_val_i,
  input          ctl_0_i,
  input          ctl_1_i,
  output [9 : 0] tmds_data_o
);

//      1      |    2       |       3      |   4   |
//  ones_in_px | q_m        | ones_in_q_m  | q_out |
//  px_data_d1 | ctl_0_d[1] | zeros_in_q_m |       |
//  ctl_0_d[0] | ctl_1_d[1] | ctl_0_d[2]   |       |
//  ctl_1_d[0] | valid_d[1] | ctl_1_d[2]   |       |
//  valid_d[0] |            | valid_d[2]   |       |

logic [3 : 0] ones_in_px, ones_in_px_comb;
logic [7 : 0] px_data_d1;
logic [2 : 0] ctl_0_d;
logic [2 : 0] ctl_1_d;
logic [2 : 0] valid_d;
logic [8 : 0] q_m;
logic [8 : 0] q_m_comb;
logic [4 : 0] disp_cnt;
logic [3 : 0] ones_in_q_m, ones_in_q_m_comb;
logic [3 : 0] zeros_in_q_m, zeros_in_q_m_comb;
logic [9 : 0] q_out;

assign tmds_data_o = q_out;

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
      ctl_0_d    <= '0;
      ctl_1_d    <= '0;
      valid_d    <= '0;
    end
  else
    begin
      px_data_d1 <= px_data_i;
      ctl_0_d[0] <= ctl_0_i;
      ctl_1_d[0] <= ctl_1_i;
      valid_d[0] <= px_data_val_i;
      for( int i = 1; i < 3; i++ )
        begin
          ctl_0_d[i] <= ctl_0_d[i - 1];
          ctl_1_d[i] <= ctl_1_d[i - 1];
          valid_d[i]  <= valid_d[i - 1];
        end
    end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    q_m <= '0;
  else
    q_m <= q_m_comb;

always_comb
  begin
    q_m_comb = q_m;
    if( ( ones_in_px > 4'd4 ) ||
        ( ( ones_in_px == 4'd4 ) && !px_data_d1[0] ) )
      begin
        q_m_comb[0] = px_data_d1[0];
        q_m_comb[8] = 1'b0;
        for( int i = 0; i < 7; i++ )
          q_m_comb[i + 1] = q_m_comb[i] ~^ px_data_d1[i + 1];
      end
    else
      begin
        q_m_comb[0] = px_data_d1[0];
        q_m_comb[8] = 1'b1;
        for( int i = 0; i < 7; i++ )
          q_m_comb[i + 1] = q_m_comb[i] ^ px_data_d1[i + 1];
      end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      ones_in_q_m  <= '0;
      zeros_in_q_m <= '0;
    end
  else
    begin
      ones_in_q_m  <= ones_in_q_m_comb;
      zeros_in_q_m <= zeros_in_q_m_comb;
    end

always_comb
  begin
    ones_in_q_m_comb = '0;
    for( int i = 0; i < 8; i++ )
      ones_in_q_m_comb = ones_in_q_m_comb + q_m[i];
  end

always_comb
  begin
    zeros_in_q_m_comb = '0;
    for( int i = 0; i < 8; i++ )
      zeros_in_q_m_comb = zeros_in_q_m_comb + !q_m[i];
  end

// May be I should add another stage to pipeline to find out
// zeros - ones and ones - zeros
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      q_out    <= '0;
      disp_cnt <= '0;
    end
  else
    if( valid_d[2] )
      if( (  disp_cnt == '0 ) || ( zeros_in_q_m == ones_in_q_m ) )
        begin
          q_out[9] <= ~q_m[8];
          q_out[8] <= q_m[8];
          if( q_m[8] )
            begin
              q_out[7 : 0] <= q_m[7 : 0];
              disp_cnt     <= disp_cnt + ( ones_in_q_m - zeros_in_q_m );
            end
          else
            begin
              q_out[7 : 0] <= ~q_m[7 : 0];
              disp_cnt     <= disp_cnt + ( zeros_in_q_m - ones_in_q_m );
            end
        end
      else
        if( ( !disp_cnt[4] && ( ones_in_q_m > zeros_in_q_m ) ) ||
            (  disp_cnt[4] && ( zeros_in_q_m > ones_in_q_m ) ) )
          begin
            q_out[9]     <= 1'b1;
            q_out[8]     <= q_m[8];
            q_out[7 : 0] <= ~q_m[7 : 0];
            disp_cnt     <= disp_cnt + { q_m[8], 1'b0 } + ( zeros_in_q_m - ones_in_q_m );
          end
        else
          begin
            q_out[9]     <= 1'b0;
            q_out[8]     <= q_m[8];
            q_out[7 : 0] <= q_m[7 : 0];
            disp_cnt     <= disp_cnt + { !q_m[8], 1'b0 } + ( ones_in_q_m - zeros_in_q_m );
          end
    else
      begin
        disp_cnt <= '0;
        case( { ctl_1_d[2], ctl_0_d[2] } )
          2'b00: q_out <= 10'b1101010100;
          2'b01: q_out <= 10'b0010101011;
          2'b10: q_out <= 10'b0101010100;
          2'b11: q_out <= 10'b1010101011;
        endcase
      end

endmodule
