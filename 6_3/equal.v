`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:08:46 08/28/2015 
// Design Name: 
// Module Name:    equal 
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
module equal(
    clk,in_trigger,equal_out,rst_n
    );
input rst_n;	 
input clk;
input in_trigger;
output equal_out;
reg in_trigger_delay;
reg equal_out;
wire equal_tmp;

always @(posedge clk)
begin
in_trigger_delay<=in_trigger;
end


assign equal_tmp= ~((in_trigger)&(in_trigger_delay));

always @(posedge clk or negedge rst_n)
begin
if(~rst_n)
	begin
	equal_out<=1'b1;
	end
else
	begin
	equal_out <= equal_tmp;
	end
end

endmodule
