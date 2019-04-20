module hdmi_phy
(
  input          px_clk_i,
  input          tmds_clk_i,
  input          rst_i,
  input  [9 : 0] tmds_red_i,
  input  [9 : 0] tmds_green_i,
  input  [9 : 0] tmds_blue_i,
  output         hdmi_red_p_o,
  output         hdmi_red_n_o,
  output         hdmi_green_p_o,
  output         hdmi_green_n_o,
  output         hdmi_blue_p_o,
  output         hdmi_blue_n_o,
  output         hdmi_clk_p_o,
  output         hdmi_clk_n_o
);

logic serial_red;
logic red_shift_1;
logic red_shift_2;
logic serial_green;
logic green_shift_1;
logic green_shift_2;
logic serial_blue;
logic blue_shift_1;
logic blue_shift_2;
logic serial_clk;
logic clk_shift_1;
logic clk_shift_2;

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"         ),
  .DATA_RATE_TQ   ( "SDR"         ),
  .DATA_WIDTH     ( 10            ),
  .TRISTATE_WIDTH ( 1             ),
  .TBYTE_CTL      ( "FALSE"       ),
  .TBYTE_SRC      ( "FALSE"       ),
  .SERDES_MODE    ( "MASTER"      )
) red_serdes_master (
  .OFB            (               ),
  .OQ             ( serial_red    ),
  .SHIFTOUT1      (               ),
  .SHIFTOUT2      (               ),
  .TBYTEOUT       (               ),
  .TFB            (               ),
  .TQ             (               ),
  .CLK            ( tmds_clk_i    ),
  .CLKDIV         ( px_clk_i      ),
  .D1             ( tmds_red_i[0] ),
  .D2             ( tmds_red_i[1] ),
  .D3             ( tmds_red_i[2] ),
  .D4             ( tmds_red_i[3] ),
  .D5             ( tmds_red_i[4] ),
  .D6             ( tmds_red_i[5] ),
  .D7             ( tmds_red_i[6] ),
  .D8             ( tmds_red_i[7] ),
  .OCE            ( 1'b1          ),
  .RST            ( rst_i         ),
  .SHIFTIN1       ( red_shift_1   ),
  .SHIFTIN2       ( red_shift_2   ),
  .T1             ( 1'b0          ),
  .T2             ( 1'b0          ),
  .T3             ( 1'b0          ),
  .T4             ( 1'b0          ),
  .TBYTEIN        ( 1'b0          ),
  .TCE            ( 1'b0          )
);

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"         ),
  .DATA_RATE_TQ   ( "SDR"         ),
  .DATA_WIDTH     ( 10            ),
  .TRISTATE_WIDTH ( 1             ),
  .TBYTE_CTL      ( "FALSE"       ),
  .TBYTE_SRC      ( "FALSE"       ),
  .SERDES_MODE    ( "SLAVE"       )
) red_serdes_slave (
  .OFB            (               ),
  .OQ             (               ),
  .SHIFTOUT1      ( red_shift_1   ),
  .SHIFTOUT2      ( red_shift_2   ),
  .TBYTEOUT       (               ),
  .TFB            (               ),
  .TQ             (               ),
  .CLK            ( tmds_clk_i    ),
  .CLKDIV         ( px_clk_i      ),
  .D1             ( 1'b0          ),
  .D2             ( 1'b0          ),
  .D3             ( tmds_red_i[8] ),
  .D4             ( tmds_red_i[9] ),
  .D5             ( 1'b0          ),
  .D6             ( 1'b0          ),
  .D7             ( 1'b0          ),
  .D8             ( 1'b0          ),
  .OCE            ( 1'b1          ),
  .RST            ( rst_i         ),
  .SHIFTIN1       ( 1'b0          ),
  .SHIFTIN2       ( 1'b0          ),
  .T1             ( 1'b0          ),
  .T2             ( 1'b0          ),
  .T3             ( 1'b0          ),
  .T4             ( 1'b0          ),
  .TBYTEIN        ( 1'b0          ),
  .TCE            ( 1'b0          )
);

OBUFDS #(
  .IOSTANDARD ( "TMDS_33"    )
) red_output (
  .O          ( hdmi_red_p_o ),
  .OB         ( hdmi_red_n_o ),
  .I          ( serial_red   )
);

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"           ),
  .DATA_RATE_TQ   ( "SDR"           ),
  .DATA_WIDTH     ( 10              ),
  .TRISTATE_WIDTH ( 1               ),
  .TBYTE_CTL      ( "FALSE"         ),
  .TBYTE_SRC      ( "FALSE"         ),
  .SERDES_MODE    ( "MASTER"        )
) green_serdes_master (
  .OFB            (                 ),
  .OQ             ( serial_green    ),
  .SHIFTOUT1      (                 ),
  .SHIFTOUT2      (                 ),
  .TBYTEOUT       (                 ),
  .TFB            (                 ),
  .TQ             (                 ),
  .CLK            ( tmds_clk_i      ),
  .CLKDIV         ( px_clk_i        ),
  .D1             ( tmds_green_i[0] ),
  .D2             ( tmds_green_i[1] ),
  .D3             ( tmds_green_i[2] ),
  .D4             ( tmds_green_i[3] ),
  .D5             ( tmds_green_i[4] ),
  .D6             ( tmds_green_i[5] ),
  .D7             ( tmds_green_i[6] ),
  .D8             ( tmds_green_i[7] ),
  .OCE            ( 1'b1            ),
  .RST            ( rst_i           ),
  .SHIFTIN1       ( green_shift_1   ),
  .SHIFTIN2       ( green_shift_2   ),
  .T1             ( 1'b0            ),
  .T2             ( 1'b0            ),
  .T3             ( 1'b0            ),
  .T4             ( 1'b0            ),
  .TBYTEIN        ( 1'b0            ),
  .TCE            ( 1'b0            )
);

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"           ),
  .DATA_RATE_TQ   ( "SDR"           ),
  .DATA_WIDTH     ( 10              ),
  .TRISTATE_WIDTH ( 1               ),
  .TBYTE_CTL      ( "FALSE"         ),
  .TBYTE_SRC      ( "FALSE"         ),
  .SERDES_MODE    ( "SLAVE"         )
) green_serdes_slave (
  .OFB            (                 ),
  .OQ             (                 ),
  .SHIFTOUT1      ( green_shift_1   ),
  .SHIFTOUT2      ( green_shift_2   ),
  .TBYTEOUT       (                 ),
  .TFB            (                 ),
  .TQ             (                 ),
  .CLK            ( tmds_clk_i      ),
  .CLKDIV         ( px_clk_i        ),
  .D1             ( 1'b0            ),
  .D2             ( 1'b0            ),
  .D3             ( tmds_green_i[8] ),
  .D4             ( tmds_green_i[9] ),
  .D5             ( 1'b0            ),
  .D6             ( 1'b0            ),
  .D7             ( 1'b0            ),
  .D8             ( 1'b0            ),
  .OCE            ( 1'b1            ),
  .RST            ( rst_i           ),
  .SHIFTIN1       ( 1'b0            ),
  .SHIFTIN2       ( 1'b0            ),
  .T1             ( 1'b0            ),
  .T2             ( 1'b0            ),
  .T3             ( 1'b0            ),
  .T4             ( 1'b0            ),
  .TBYTEIN        ( 1'b0            ),
  .TCE            ( 1'b0            )
);

OBUFDS #(
  .IOSTANDARD ( "TMDS_33"      )
) green_output (
  .O          ( hdmi_green_p_o ),
  .OB         ( hdmi_green_n_o ),
  .I          ( serial_green   )
);

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"          ),
  .DATA_RATE_TQ   ( "SDR"          ),
  .DATA_WIDTH     ( 10             ),
  .TRISTATE_WIDTH ( 1              ),
  .TBYTE_CTL      ( "FALSE"        ),
  .TBYTE_SRC      ( "FALSE"        ),
  .SERDES_MODE    ( "MASTER"       )
) blue_serdes_master (
  .OFB            (                ),
  .OQ             ( serial_blue    ),
  .SHIFTOUT1      (                ),
  .SHIFTOUT2      (                ),
  .TBYTEOUT       (                ),
  .TFB            (                ),
  .TQ             (                ),
  .CLK            ( tmds_clk_i     ),
  .CLKDIV         ( px_clk_i       ),
  .D1             ( tmds_blue_i[0] ),
  .D2             ( tmds_blue_i[1] ),
  .D3             ( tmds_blue_i[2] ),
  .D4             ( tmds_blue_i[3] ),
  .D5             ( tmds_blue_i[4] ),
  .D6             ( tmds_blue_i[5] ),
  .D7             ( tmds_blue_i[6] ),
  .D8             ( tmds_blue_i[7] ),
  .OCE            ( 1'b1           ),
  .RST            ( rst_i          ),
  .SHIFTIN1       ( blue_shift_1   ),
  .SHIFTIN2       ( blue_shift_2   ),
  .T1             ( 1'b0           ),
  .T2             ( 1'b0           ),
  .T3             ( 1'b0           ),
  .T4             ( 1'b0           ),
  .TBYTEIN        ( 1'b0           ),
  .TCE            ( 1'b0           )
);

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"          ),
  .DATA_RATE_TQ   ( "SDR"          ),
  .DATA_WIDTH     ( 10             ),
  .TRISTATE_WIDTH ( 1              ),
  .TBYTE_CTL      ( "FALSE"        ),
  .TBYTE_SRC      ( "FALSE"        ),
  .SERDES_MODE    ( "SLAVE"        )
) blue_serdes_slave (
  .OFB            (                ),
  .OQ             (                ),
  .SHIFTOUT1      ( blue_shift_1   ),
  .SHIFTOUT2      ( blue_shift_2   ),
  .TBYTEOUT       (                ),
  .TFB            (                ),
  .TQ             (                ),
  .CLK            ( tmds_clk_i     ),
  .CLKDIV         ( px_clk_i       ),
  .D1             ( 1'b0           ),
  .D2             ( 1'b0           ),
  .D3             ( tmds_blue_i[8] ),
  .D4             ( tmds_blue_i[9] ),
  .D5             ( 1'b0           ),
  .D6             ( 1'b0           ),
  .D7             ( 1'b0           ),
  .D8             ( 1'b0           ),
  .OCE            ( 1'b1           ),
  .RST            ( rst_i          ),
  .SHIFTIN1       ( 1'b0           ),
  .SHIFTIN2       ( 1'b0           ),
  .T1             ( 1'b0           ),
  .T2             ( 1'b0           ),
  .T3             ( 1'b0           ),
  .T4             ( 1'b0           ),
  .TBYTEIN        ( 1'b0           ),
  .TCE            ( 1'b0           )
);

OBUFDS #(
  .IOSTANDARD ( "TMDS_33"     )
) blue_output (
  .O          ( hdmi_blue_p_o ),
  .OB         ( hdmi_blue_n_o ),
  .I          ( serial_blue   )
);

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"       ),
  .DATA_RATE_TQ   ( "SDR"       ),
  .DATA_WIDTH     ( 10          ),
  .TRISTATE_WIDTH ( 1           ),
  .TBYTE_CTL      ( "FALSE"     ),
  .TBYTE_SRC      ( "FALSE"     ),
  .SERDES_MODE    ( "MASTER"    )
) clk_serdes_master (
  .OFB            (             ),
  .OQ             ( serial_clk  ),
  .SHIFTOUT1      (             ),
  .SHIFTOUT2      (             ),
  .TBYTEOUT       (             ),
  .TFB            (             ),
  .TQ             (             ),
  .CLK            ( tmds_clk_i  ),
  .CLKDIV         ( px_clk_i    ),
  .D1             ( 1'b0        ),
  .D2             ( 1'b0        ),
  .D3             ( 1'b0        ),
  .D4             ( 1'b0        ),
  .D5             ( 1'b0        ),
  .D6             ( 1'b1        ),
  .D7             ( 1'b1        ),
  .D8             ( 1'b1        ),
  .OCE            ( 1'b1        ),
  .RST            ( rst_i       ),
  .SHIFTIN1       ( clk_shift_1 ),
  .SHIFTIN2       ( clk_shift_2 ),
  .T1             ( 1'b0        ),
  .T2             ( 1'b0        ),
  .T3             ( 1'b0        ),
  .T4             ( 1'b0        ),
  .TBYTEIN        ( 1'b0        ),
  .TCE            ( 1'b0        )
);

OSERDESE2 #(
  .DATA_RATE_OQ   ( "DDR"       ),
  .DATA_RATE_TQ   ( "SDR"       ),
  .DATA_WIDTH     ( 10          ),
  .TRISTATE_WIDTH ( 1           ),
  .TBYTE_CTL      ( "FALSE"     ),
  .TBYTE_SRC      ( "FALSE"     ),
  .SERDES_MODE    ( "SLAVE"     )
) clk_serdes_slave (
  .OFB            (             ),
  .OQ             (             ),
  .SHIFTOUT1      ( clk_shift_1 ),
  .SHIFTOUT2      ( clk_shift_2 ),
  .TBYTEOUT       (             ),
  .TFB            (             ),
  .TQ             (             ),
  .CLK            ( tmds_clk_i  ),
  .CLKDIV         ( px_clk_i    ),
  .D1             ( 1'b0        ),
  .D2             ( 1'b0        ),
  .D3             ( 1'b1        ),
  .D4             ( 1'b1        ),
  .D5             ( 1'b0        ),
  .D6             ( 1'b0        ),
  .D7             ( 1'b0        ),
  .D8             ( 1'b0        ),
  .OCE            ( 1'b1        ),
  .RST            ( rst_i       ),
  .SHIFTIN1       ( 1'b0        ),
  .SHIFTIN2       ( 1'b0        ),
  .T1             ( 1'b0        ),
  .T2             ( 1'b0        ),
  .T3             ( 1'b0        ),
  .T4             ( 1'b0        ),
  .TBYTEIN        ( 1'b0        ),
  .TCE            ( 1'b0        )
);

OBUFDS #(
  .IOSTANDARD ( "TMDS_33"    )
) clk_output (
  .O          ( hdmi_clk_p_o ),
  .OB         ( hdmi_clk_n_o ),
  .I          ( serial_clk   )
);

endmodule
