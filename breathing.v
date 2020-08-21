module breathing
(
    input clk,
    input reset,
    output wire dout
);

reg [23:0] data;
reg [5:0] addr;
reg wen_i;
wire wen_o;

always @(*)
begin
    if (addr>=1 && addr<=60)
        wen_i=1;
    else
        wen_i=0;
end

always @(posedge clk or negedge reset)
begin
    if (reset==0)
    begin
        addr<=0;
    end
    else
    begin
        if (wen_o==1)
        begin
            if (addr<60)
                addr<=addr+1;
            else
                addr<=addr;    
        end
        else
            addr<=0;
    end
end

reg last_wen,current_wen;
always @(posedge clk or negedge reset)
begin
    if (reset==0)
    begin
        last_wen<=0;
        current_wen<=0;
    end
    else
    begin
        last_wen<=current_wen;
        current_wen<=wen_o;
    end
end

reg [10:0] count_time;
reg [2:0] color_flag;
always @(posedge clk or negedge reset)
begin
    if (reset==0)
    begin
        count_time<=0;
        color_flag<=0;
    end
    else
    begin
        if (last_wen==1 && current_wen==0)
        begin
            count_time=count_time+1;
            if (count_time==11'h7ff)
                color_flag<=color_flag+1;
            else
                color_flag<=color_flag;
        end
        else
        begin
            count_time<=count_time;
        end
    end
end

wire [23:0] color;
always @(*)
begin
    data=color;
end

band_drive  u_band_drive (
    .clk                     ( clk           ),
    .reset                   ( reset         ),
    .addr                    ( addr   [5:0]  ),
    .data                    ( data   [23:0] ),
    .wen_i                   ( wen_i         ),

    .wen_o                   ( wen_o         ),
    .dout                    ( dout          )
);

brightness  u_brightness (
    .addr                    ( addr        [5:0]  ),
    .count_time              ( count_time  [10:2]  ),
    .color_flag              ( color_flag  [2:0]),

    .color               ( color   [23:0] )
);

endmodule