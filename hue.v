module hue
(
    input [10-1:0] location,
    output reg [24-1:0] color 
);

reg [8-1:0] green,red,blue;
always @(*)
begin
    case(location[9:8])
        2'b00:begin
            green=8'hff-location[7:0];
            red=location[7:0];
            blue=0;
        end 
        2'b01:begin
            red=8'hff-location[7:0];
            blue=location[7:0];
            green=0;
        end
        2'b10:begin
            blue=8'hff-location[7:0];
            green=location[7:0];
            red=0;
        end
        2'b11:begin
            green=8'hff-location[7:0];
            red=location[7:0];
            blue=0;
        end
        default:
            ;
    endcase
end

always @(*)
begin
    color = {green,red,blue};
end

endmodule