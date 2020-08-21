module brightness
(
    input [5:0] addr,
    input [8:0] count_time,
    input [2:0] color_flag,
    output reg [23:0] color
);

reg [7:0] intensity;

always @(*)
begin
    if (count_time[8]==0)
    begin
        if (count_time[7:0]<=128)
            intensity=count_time[7:0]>>1;
        else
            intensity=count_time[7:0]+{1'b0,count_time[7:1]}-128;
    end
    else
    begin
        if (count_time[7:0]>128)
            intensity=8'hff-count_time[7:0]>>1;
        else
            intensity=8'hff-count_time[7:0]-{1'b0,count_time[7:1]};
    end
    
end

always @(*)
begin
    case (color_flag)
        3'b000:begin
            if (addr<=30)
            begin
                color={intensity,8'h00,8'h00};     
            end
            else
            begin
                color={intensity,intensity,8'h00};
            end
        end
        3'b001:begin
            if (addr<=30)
            begin
                color={8'h00,intensity,8'h00};     
            end
            else
            begin
                color={8'h00,intensity,intensity};
            end
        end
        3'b010:begin
            if (addr<=30)
            begin
                color={8'h00,8'h00,intensity};     
            end
            else
            begin
                color={intensity,8'h00,intensity};
            end
		  end
		  3'b011:begin
            if (addr<=30)
            begin
                color={intensity,8'h00,8'h00};     
            end
            else
            begin
                color={8'h00,intensity,intensity};
            end
		  end
		  3'b100:begin
            if (addr<=30)
            begin
                color={8'h00,intensity,8'h00};     
            end
            else
            begin
                color={intensity,8'h00,intensity};
            end
		  end
		  3'b101:begin
            if (addr<=30)
            begin
                color={8'h00,8'h00,intensity};     
            end
            else
            begin
                color={intensity,intensity,8'h00};
            end
        end
		  3'b110:begin
            if (addr<=30)
            begin
                color={8'h00,intensity,intensity};     
            end
            else
            begin
                color={intensity,intensity,8'h00};
            end
        end
		  3'b111:begin
            if (addr<=30)
            begin
                color={intensity,intensity,8'h00};     
            end
            else
            begin
                color={8'h00,intensity,intensity};
            end
        end
        default:
            ;
    endcase
end

endmodule