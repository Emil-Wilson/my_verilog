`timescale 1 ns/100 ps
module band_drive
(
    input clk,
    input reset,
    input [5:0] addr,
    input [23:0] data,
    input wen_i,
    output reg wen_o,
    output reg dout
);

reg [23:0] memory [0:63];
reg [31:0] count1;
reg [5:0] count2;
reg [5:0] led_num;
reg [4:0] bit_num;

always @ (posedge clk or negedge reset)
begin
    if (reset==0)
    begin
        wen_o<=0;
        dout<=0;
        bit_num<=23;
        led_num<=1;
        count1<=32'd0;
        count2<=0;
    end
    else
    begin
        if (count1>=32'd93321+32'd1000)
        begin
            wen_o<=0;
            dout<=0;
            bit_num<=23;
            led_num<=1;
            count1<=32'd0;
            count2<=0;
        end
        else
        begin
            count1<=count1+1;
            if (count1<=32'd2600+32'd1000)
            begin
                wen_o<=1;
                dout<=0;
            end
            else
            begin
                wen_o<=0;
                if (count2>=62)
                begin
                    count2<=0;
                    if (bit_num<=0)
                    begin
                        led_num<=led_num+1;
                        bit_num<=23;
                    end
                    else
                    begin
                        bit_num<=bit_num-1;
                    end
                end
                else
                begin
                    count2<=count2+1;
                    if (memory[led_num][bit_num]==0)
                    begin
                        if (count2<=19)
                        begin
                            dout<=1;
                        end
                        else
                        begin
                            dout<=0;
                        end
                    end
                    else
                    begin
                        if (count2<=42)
                        begin
                            dout<=1;
                        end
                        else
                        begin
                            dout<=0;
                        end
                    end
                end
            end
        end 
    end
end

always @ (posedge clk or negedge reset)
begin
    if (reset==0)
    begin
        memory[0]<=24'h000000;
        memory[1]<=24'h010101;
        memory[2]<=24'h18ff00;
        memory[3]<=24'h30ff00;
        memory[4]<=24'h48ff00;
        memory[5]<=24'h60ff00;
        memory[6]<=24'h78ff00;
        memory[7]<=24'h90ff00;
        memory[8]<=24'ha8ff00;
        memory[9]<=24'hc0ff00;
        memory[10]<=24'hd8ff00;
        memory[11]<=24'hffff00;
        memory[12]<=24'hffe700;
        memory[13]<=24'hffcf00;
        memory[14]<=24'hffb700;
        memory[15]<=24'hff9f00;
        memory[16]<=24'hff8700;
        memory[17]<=24'hff6f00;
        memory[18]<=24'hff5700;
        memory[19]<=24'hff3f00;
        memory[20]<=24'hff2700;
        memory[21]<=24'hff0000;
        memory[22]<=24'hff0018;
        memory[23]<=24'hff0030;
        memory[24]<=24'hff0048;
        memory[25]<=24'hff0060;
        memory[26]<=24'hff0078;
        memory[27]<=24'hff0090;
        memory[28]<=24'hff00a8;
        memory[29]<=24'hff00c0;
        memory[30]<=24'hff00d8;
        memory[31]<=24'hff00ff;
        memory[32]<=24'he700ff;
        memory[33]<=24'hcf00ff;
        memory[34]<=24'hb700ff;
        memory[35]<=24'h9f00ff;
        memory[36]<=24'h8700ff;
        memory[37]<=24'h6f00ff;
        memory[38]<=24'h5700ff;
        memory[39]<=24'h3f00ff;
        memory[40]<=24'h2700ff;
        memory[41]<=24'h0018ff;
        memory[42]<=24'h0030ff;
        memory[43]<=24'h0048ff;
        memory[44]<=24'h0060ff;
        memory[45]<=24'h0078ff;
        memory[46]<=24'h0090ff;
        memory[47]<=24'h00a8ff;
        memory[48]<=24'h00c0ff;
        memory[49]<=24'h00d8ff;
        memory[50]<=24'h00f0ff;
        memory[51]<=24'h00ffff;
        memory[52]<=24'h00ffe7;
        memory[53]<=24'h00ffcf;
        memory[54]<=24'h00ffb7;
        memory[55]<=24'h01ff9f;
        memory[56]<=24'h00ff87;
        memory[57]<=24'h00ff6f;
        memory[58]<=24'h00ff57;
        memory[59]<=24'h00ff3f;   
        memory[60]<=24'h00ff27;
        memory[61]<=24'h000000;
        memory[62]<=24'h000000;
        memory[63]<=24'h000000;  
    end
    else
    begin
        if (wen_o==1 && wen_i==1)
        begin
            memory[addr]<=data;
        end
        else
            ; 
    end
end

endmodule