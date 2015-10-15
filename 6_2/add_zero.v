`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:50:54 08/28/2015 
// Design Name: 
// Module Name:    add_zero 
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
module add_zero(	pressed,sel_check
    );
//input clk;	 
//input sel_add;
input pressed;
/*input [3:0]tmp;
output [3:0]a_tmp;*/
output sel_check;
reg sel_check;	 
/*reg sel_add_next;	 
reg [3:0]a_tmp;*/
reg press_tmp;
always@(*)
begin
press_tmp<=pressed;
end
/*always@(posedge clk)
begin
	sel_add_next<=sel_add;
end*/

/*always@(sel_add or sel_add_next)
begin
if (sel_add!=sel_add_next)
	begin
	a_tmp<=4'd0;
	end
else
	begin 
	a_tmp<=tmp;
	end
end*/ 

always@(*)
begin
if(press_tmp==1) sel_check<=1;
else	sel_check<=0;
end

endmodule
