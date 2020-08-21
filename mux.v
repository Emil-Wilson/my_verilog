module mux
(
    input clk,
    input reset,
    input dout1,dout2,
    input key_flag,
    output reg dout
);

reg counter;
always @(posedge clk or negedge reset)
begin
    if (reset==0)
    begin
        counter<=0;
    end
    else
    begin
        if (key_flag==1)
            counter<=counter+1;
        else
            counter<=counter;
    end
end

always @(*)
begin
    if (counter==0)
    begin
        dout=dout1;
    end
    else
    begin
        dout=dout2;
    end
end

endmodule