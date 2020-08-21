/*
 *NAME: Rayone
 *DATE: 2019/5/21
 *FUNC: key filter
 */
module keyscan(Clk,Rst_n,key_in,key_flag,key_state);
//端口定义
	input Clk;
	input Rst_n;
	input key_in;
	
	output reg key_flag; //滤波后如果检测确实按下了将其置1
	output reg key_state;//按键在空闲稳定状态下为1 在按下稳定状态为0

//key_filter模块设计
//——>利用两级D触发器降低亚稳态发生的可能
	reg key_in_tmpa,key_in_tmpb;
	always@(posedge Clk or negedge Rst_n)
		if(!Rst_n)begin
			key_in_tmpa <= 1'b0;
			key_in_tmpb <= 1'b0;
		end
		else begin
			key_in_tmpa <= key_in;
			key_in_tmpb <= key_in_tmpa;
		end
		
//——>捕获key_in变化信号
	wire pedge,nedge;//key_in的上升沿和下降沿
	reg key_in_a,key_in_b;
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		key_in_a <= 1'b0;
		key_in_b <= 1'b0;
	end
	else begin
		key_in_a <= key_in_tmpb;//key_in_tmpb是key_in经过二级D触发器处理后的，这里是非阻塞赋值
										//key_in_a在给key_in_b赋值的同时也给key_in_b赋值，处于时时更新的
		key_in_b <= key_in_a;
	end
	//now :key_in_a   ago :key_in_b
	assign pedge = ((!key_in_b) & key_in_a);	//key_in上升沿信号到来
	assign nedge = ( key_in_b & (!key_in_a));//key_in下降沿信号到来
	
	
	//前期设计已经准备好了，接下来就是状态机的设计
	localparam  //one-hot code
		IDLE 	  = 4'b0001,
		FILTER0 = 4'b0010,
		DOWN 	  = 4'b0100,
		FILTER1 = 4'b1000;

	//用一个状态寄存器保存状态
		reg [3:0]state;
		
	//设计定时器
	reg [19:0]cnt;		//——>需要一个计数寄存器,因为只用计数20ms,所以一个20位的寄存器已经足够了
	reg en_cnt;   		//——>计数器开始计数使能信号
	reg cnt_full_flag;//——>计数器加满标志
	
	//状态机设计
	always@(posedge Clk or negedge Rst_n)
		if(!Rst_n)begin
			state <= IDLE;
			en_cnt <= 1'b0;
			key_flag <= 1'b0;
			key_state <= 1'b1;
		end
		else begin 
			case(state)
				IDLE:begin
					key_flag <= 1'b0;
					if(nedge)begin//如果检测到下降沿
						state <= FILTER0;//进入按下抖动滤波状态
						en_cnt <= 1'b1;  //使能计数(此时需要计时20ms,前面我们没有设计计数器，于是我们在最后设计一个计数器哦)
					end
					else 
						state <= IDLE;
				end	
				
				FILTER0:begin
					if(cnt_full_flag)begin
						state <= DOWN;
						en_cnt <= 1'b0;
						key_flag <= 1'b1;	//标志按键此时确实按下
						key_state <= 1'b0;//此时按键处于按下稳定状态
					end
						else if(pedge)begin
							en_cnt <= 1'b0;
							state <= IDLE;	
						end
					else 
						state <= FILTER0;	
				end
				
				DOWN:begin
					key_flag <= 1'b0;
					if(pedge)begin
						en_cnt <= 1'b1;
						state <= FILTER1;
					end	
					else
						state <= DOWN;
				end
				
				FILTER1:begin
					if(cnt_full_flag == 1'b1)begin
						state <= IDLE;		//计数满标志成功计数
						en_cnt <= 1'b0;	//关闭计数
//						key_flag <= 1'b1;	//标志按键此时确实释放
						key_state <= 1'b1;//空闲稳定状态下为1
					end
					else if(nedge)begin
							en_cnt <= 1'b0;
							state <= DOWN;	
					end
					else 
						state <= FILTER1;	
				end
				default:
					begin 
						state <= IDLE; 
						en_cnt <= 1'b0;		
						key_flag <= 1'b0;
						key_state <= 1'b1;
					end
					
			endcase
	end
		

//计数器加1操作	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		cnt <= 20'd0;
	end
	else if(en_cnt)
		cnt <= cnt + 1'b1;
	else 
		cnt <= 20'd0;

//产生计数20ms满信号 cnt_full_flag	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		cnt_full_flag <= 1'b0;
	else if(cnt == 999_999)
		cnt_full_flag <= 1'b1;
	else 
		cnt_full_flag <= 1'b0;
		
endmodule