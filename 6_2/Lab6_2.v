`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:47:25 08/27/2015 
// Design Name: 
// Module Name:    Lab6_2 
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
module Lab6_2(
  clk,rst_n,button_sel,display_ctl,display,pressed,row_out,col_out,col_n,row_n,sel_add
    );
input clk,rst_n;
input	[3:0] col_n;
input button_sel;
output [14:0] display;
output [3:0] display_ctl; 
output pressed;
output [3:0] row_out,col_out,row_n;
output sel_add;
wire clk_out;//1s
wire [1:0]clk_ctl;//for scan
wire clk_150;
wire  [3:0] bcd;
wire pressed;//new
wire [3:0]tmp;
wire [3:0]a_tmp;
wire sel_check;//new
reg [3:0]addend;
reg [3:0]augend;
reg [4:0]sum;
reg [3:0]ten;
reg [3:0]single;
wire pb_debounced;
wire fsm_in;
assign col_out=~col_n;
assign row_out=~row_n;

//choose input is addend or augend
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		addend<=4'd0;
		augend<=4'd0;
	end
	else
	begin
		if(sel_add==0&&sel_check==1)
			begin
			addend<=tmp;
			end
		else if (sel_add==1&&sel_check==1)
			begin
			augend<=tmp;
			end
		else
			begin
			addend<=addend;
			augend<=augend;
			end
	end
end
//adder
always@(*)
begin
sum<=addend+augend;
end
always@(*)
begin
ten<=sum/10;
single<=sum%10;
end
freq_divider fl(
   .clk_out(clk_out), // divided clock output
	.clk_ctl(clk_ctl), // divided clock output for scan freq
	.clk_150(clk_150),
	.clk(clk), // global clock input
	.rst_n(rst_n) // active low reset
	); 

scanf sfl(
   .ftsd_ctl(display_ctl), // ftsd display control signal 
	.ftsd_in(bcd), // output to ftsd display
	.in0(addend), // 1st input
	.in1(augend), // 2nd input
	.in2(ten), // 3rd input
	.in3(single), // 4th input
	.ftsd_ctl_en(clk_ctl) // divided clock for scan control
	);
bcd_d bl(
   .display(display), // 14-segment display output
	.bcd(bcd) // BCD input
	);
	
keypad_scan ksl(
.clk(clk_150), // scan clock
.rst_n(rst_n), // active low reset
.col_n(col_n), // pressed column index
.row_n(row_n), // scanned row index
.key(tmp), // returned pressed key
.pressed(pressed) // whether key pressed (1) or not (0)
);	

debounce dl(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(button_sel), //push button input
.pb_debounced(pb_debounced) // debounced push button output
);

Pause_one(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_debounced), // input trigger
.out_pulse(fsm_in) // output one pulse
);

Fsm(
    .rst(rst_n),
	 .clk(clk),
	 .sel_out(sel_add),
	 .in(fsm_in)
    );
add_zero(
//.clk(clk_out),	
//.sel_add(sel_add),
.pressed(pressed),
//.tmp(tmp),
//.a_tmp(a_tmp),
.sel_check(sel_check)
    );	 
endmodule
