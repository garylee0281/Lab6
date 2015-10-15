`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:44:44 08/28/2015 
// Design Name: 
// Module Name:    Lab6_3 
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
`define ne 4'd10
module Lab6_3(
     sel_add_sub,clk,rst_n,button_sel,display_ctl,display,pressed,row_out,col_out,col_n,row_n,add_sub,sel_add,sel_ten
    );
output sel_ten;	 
input sel_add_sub;	 
input clk,rst_n;
input	[3:0] col_n;
input button_sel;
//input sel_ten;
output [14:0] display;
output [3:0] display_ctl; 
output pressed;
output [3:0] row_out,col_out,row_n;
output add_sub;
output sel_add;
wire clk_out;//1s
wire [1:0]clk_ctl;//for scan
wire clk_150;
wire  [3:0] bcd;
wire pressed;//new
wire [3:0]tmp;
wire equal;//equal flag
wire sel_check;//new
wire sel_ten;
wire fsm_ten;
wire [4:0]cnt_h; 

reg [3:0]addend;
reg [3:0]augend;

reg [3:0]addend_ten;
reg [3:0]augend_ten;

reg [7:0]sum;
reg [3:0]hun;
reg [3:0]ten;
reg [3:0]single;
wire pb_debounced;
wire fsm_in;
assign col_out=~col_n;
assign row_out=~row_n;
reg [3:0]in0,in1,in2,in3;
//reg [1:0] counter;
//reg counter_tmp;
reg [6:0] result;
reg [3:0] result_single,result_ten;
reg [6:0] sub,dsub;
reg [3:0] sub_s,sub_ten,dsub_s,dsub_ten;
wire add_sub;
wire pd_add_sub;
wire fsm_add_sub; 
//choose input is addend or augend
always@(posedge clk_150 or negedge rst_n)
begin
	if(~rst_n)
	begin
		addend<=4'd0;
		augend<=4'd0;
		addend_ten<=4'd0;
		augend_ten<=4'd0;
		sub_s<=4'd0;
		dsub_s<=4'd0;
		sub_ten<=4'd0;
		dsub_ten<=4'd0;
	end
	else
	begin
		if(sel_add==0&&sel_check==1&&sel_ten==0&&add_sub==0)
			begin
			addend<=tmp;
			end
		else if (sel_add==0&&sel_check==1&&sel_ten==1&&add_sub==0)
			begin
			addend_ten<=tmp;
			end
		else if (sel_add==1&&sel_check==1&&sel_ten==0&&add_sub==0)
			begin
			augend<=tmp;
			end
		else if (sel_add==1&&sel_check==1&&sel_ten==1&&add_sub==0)
			begin
			augend_ten<=tmp;
			end
			
			else if (sel_add==0&&sel_check==1&&sel_ten==0&&add_sub==1)
			begin
			sub_s<=tmp;
			end
			else if (sel_add==0&&sel_check==1&&sel_ten==1&&add_sub==1)
			begin
			sub_ten<=tmp;
			end
			else if (sel_add==1&&sel_check==1&&sel_ten==0&&add_sub==1)
			begin
			dsub_s<=tmp;
			end
			else if (sel_add==1&&sel_check==1&&sel_ten==1&&add_sub==1)
			begin
			dsub_ten<=tmp;
			end			
		else
			begin
			addend<=addend;
			augend<=augend;
			sub_s<=sub_s;
			dsub_s<=dsub_s;
			end
	end
end

//adder-sub
always@(*)
begin
	if(add_sub==0)
	begin
		sum<=(addend_ten*10)+addend+(augend_ten*10)+augend;
	end
	else 
		begin
			sub<=sub_s+sub_ten*10;
			dsub<=dsub_s+dsub_ten*10;
		end
end	
		//add
		always@(*)
		begin
		hun<=sum/100;
		ten<=(sum%100)/10;
		single<=sum%100%10;
		end
		//sub
		always@(*)
		begin
			if(sub<dsub)
			result=dsub-sub;	
			else
			result=sub-dsub;
		end
		always@(*)
		begin
			result_ten<=result/10;
			result_single<=result%10;
		end
		//¿é¥XÅã¥Ü
		always@(*)
		begin
		if(sel_add==0&&equal==1&&add_sub==0)
			begin
				in0<=4'd0;
				in1<=4'd0;
				in2<=addend_ten;
				in3<=addend;
			end
		else if (sel_add==1&&equal==1&&add_sub==0)
			begin
				in0<=4'd0;
				in1<=4'd0;
				in2<=augend_ten;
				in3<=augend;
			end
		else if (equal==0&&add_sub==0)
			begin
				in0<=4'd0;
				in1<=hun;
				in2<=ten;
				in3<=single;
			end
			
		else if(sel_add==0&&equal==1&&add_sub==1)
			begin
				in0<=4'd0;
				in1<=4'd0;
				in2<=sub_ten;
				in3<=sub_s;
			end
		else if (sel_add==1&&equal==1&&add_sub==1)
			begin
				in0<=4'd0;
				in1<=4'd0;
				in2<=dsub_ten;
				in3<=dsub_s;
			end
		else if (equal==0&&add_sub==1&&sub<dsub)
			begin
				in0<=4'd0;
				in1<=`ne;
				in2<=result_ten;
				in3<=result_single;
			end
		else if (equal==0&&add_sub==1&&sub>dsub)
			begin
				in0<=4'd0;
				in1<=4'd0;
				in2<=result_ten;
				in3<=result_single;
			end		
		else
			begin
				in0<=4'd0;
				in1<=4'd0;
				in2<=4'd0;
				in3<=4'd0;
			end
	end	

freq_divider fl(
   .clk_out(clk_out), // divided clock output
	.clk_ctl(clk_ctl), // divided clock output for scan freq
	.clk_150(clk_150),
	.clk(clk), // global clock input
	.rst_n(rst_n), // active low reset
	.cnt_h(cnt_h)
	); 

scanf sfl(
   .ftsd_ctl(display_ctl), // ftsd display control signal 
	.ftsd_in(bcd), // output to ftsd display
	.in0(in0), // 1st input
	.in1(in1), // 2nd input
	.in2(in2), // 3rd input
	.in3(in3), // 4th input
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
.pressed(pressed),
.sel_check(sel_check)
    );
	 
equal(
    .clk(clk_out),
	 .in_trigger(~button_sel),
	 .equal_out(equal),
	 .rst_n(rst_n)
    );

deboun d_add_sub(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(sel_add_sub), //push button input
.pb_debounced(pd_add_sub) // debounced push button output
);
pause p_add_sub(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pd_add_sub), // input trigger
.out_pulse(fsm_add_sub) // output one pulse
);	 
fsm_add_sub(
   .rst(rst_n),
	.clk(clk),
	.sel_out(add_sub),
	.in(fsm_add_sub)
    );
	 
one_pause_ten(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pressed), // input trigger
.out_pulse(fsm_ten) // output one pulse
);

fsm_ten(
.rst(rst_n),
.clk(clk),
.sel_out(sel_ten),
.in(fsm_ten)
    );

endmodule