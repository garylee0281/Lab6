`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:47 08/27/2015 
// Design Name: 
// Module Name:    Lab6_1 
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
`define zero 4'b1111
module Lab6_1(	clk,rst_n,display_ctl,display,pressed,row_out,col_out,col_n,row_n,scanf_in3
    );
input clk,rst_n;
input	[3:0] col_n;
output [14:0] display;
output [3:0] display_ctl; 
output pressed;
output [3:0] row_out,col_out,row_n;
output [3:0] scanf_in3;
wire clk_out;//1s
wire [1:0]clk_ctl;//for scan
wire clk_150;
wire  [3:0] bcd;
wire [3:0]scanf_in3;
assign col_out=~col_n;
assign row_out=~row_n;

freq_divider fl(
   .clk_out(clk_out), // divided clock output
	.clk_ctl(clk_ctl), // divided clock output for scan freq
	.clk_150(clk_150),
	.clk(clk), // global clock input
	.rst_n(rst_n) // active low reset
	); 

scanf(
   .ftsd_ctl(display_ctl), // ftsd display control signal 
	.ftsd_in(bcd), // output to ftsd display
	.in0(`zero), // 1st input
	.in1(`zero), // 2nd input
	.in2(`zero), // 3rd input
	.in3(scanf_in3), // 4th input
	.ftsd_ctl_en(clk_ctl) // divided clock for scan control
	);
bcd_d(
   .display(display), // 14-segment display output
	.bcd(bcd) // BCD input
	);
	
keypad_scan(
.clk(clk_150), // scan clock
.rst_n(rst_n), // active low reset
.col_n(col_n), // pressed column index
.row_n(row_n), // scanned row index
.key(scanf_in3), // returned pressed key
.pressed(pressed) // whether key pressed (1) or not (0)
);	
endmodule
