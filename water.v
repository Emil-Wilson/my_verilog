`timescale  1ns / 100ps
module water
(
    input clk,
    input reset,
    output wire dout
);

reg [5:0] addr;
reg wen_i;
wire wen_o;
reg [23:0] data;
wire [23:0] color;
reg [9:0] location;

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
            addr<=addr+1;
            if (addr>=0 && addr<=60)
            begin
                wen_i=1;
            end
            else
            begin
                wen_i=0;
            end
        end
        else
        begin
            addr<=0;
        end
    end
end

reg [10:0] count_time;
always @(posedge clk or negedge reset)
begin
    if (reset==0)
    begin
        count_time<=0;
    end
    else
    begin
        if (last_wen==1 && current_wen==0)
        begin
            if (count_time[10:1]>=767)
            begin
                count_time<=0;
            end
            else
            begin
                count_time=count_time+1;
            end
        end
        else
        begin
            count_time<=count_time;
        end
    end
end

always @(*)
begin
    if (count_time[10:1]+{2'b00,addr,2'b00}+{1'b0,addr,3'b000}+{4'b0000,addr}>767)
    begin
        location=count_time[10:1]+{2'b00,addr,2'b00}+{1'b0,addr,3'b000}+{4'b0000,addr}-768;
    end
    else
    begin
        location=count_time[10:1]+{2'b00,addr,2'b00}+{1'b0,addr,3'b000}+{4'b0000,addr};
    end
end

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

hue  u_hue (
    .location                ( location  [10-1:0] ),

    .color                   ( color     [24-1:0] )
);

endmodule