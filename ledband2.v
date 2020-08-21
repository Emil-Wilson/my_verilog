module ledband2
(
    input clk,
    input reset,
    input K1,
    output wire dout
);

wire dout1,dout2;
wire key_flag,key_state;

breathing  u_breathing (
    .clk                     ( clk     ),
    .reset                   ( reset   ),

    .dout                    ( dout1    )
);

water  u_water (
    .clk                     ( clk     ),
    .reset                   ( reset   ),

    .dout                    ( dout2    )
);

mux  u_mux (
    .clk                     ( clk        ),
    .reset                   ( reset      ),
    .dout1                   ( dout1      ),
    .dout2                   ( dout2      ),
    .key_flag                ( key_flag   ),

    .dout                    ( dout       )
);

keyscan  u_key_filter (
    .Clk                     ( clk         ),
    .Rst_n                   ( reset       ),
    .key_in                  ( K1      ),

    .key_flag                ( key_flag    ),
    .key_state               ( key_state   )
);

endmodule