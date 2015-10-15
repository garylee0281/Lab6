`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:46:16 08/28/2015 
// Design Name: 
// Module Name:    fsm_mode 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fsm_mode(
  rst,clk,sel_out,sel_state
    );
input sel_state;	 
//input in;	 
input rst;
input clk;
output sel_out;
wire [1:0] S0,S1;
wire [1:0] S2,S3;
wire [3:0]sel_state;
wire [1:0]sel_out; 
assign S0=2'b00;
assign S1=2'b01;
assign S2=2'b10;
assign S3=2'b11;
reg [1:0]state,next_state;

always@(posedge clk,negedge rst)
	begin
		if(rst==0)
		state<=S0;
		else
		state<=next_state;
	end
	
always@(state)
begin
case(state)
	S0:begin
		if(sel_state==4'd10)
		next_state=S1;
		else if (sel_state==4'd13)
		next_state=S2;
		else if (sel_state==4'd11)
		next_state=S3;
		else
		next_state=S0;
		end
	S1:begin
		if(sel_state==4'd13)
		next_state=S2;
		else if (sel_state==4'd11)
		next_state=S3;
		else if (sel_state==4'd10)
		next_state=S1;
		else
		next_state=S1;
		end
	S2:begin
		if(sel_state==4'd13)
		next_state=S2;
		else if (sel_state==4'd11)
		next_state=S3;
		else if (sel_state==4'd10)
		next_state=S1;
		else
		next_state=S2;
		end
	S3:begin
		if(sel_state==4'd13)
		next_state=S2;
		else if (sel_state==4'd11)
		next_state=S3;
		else if (sel_state==4'd10)
		next_state=S1;
		else
		next_state=S3;
		end	
	endcase
end

assign sel_out=state;


endmodule
