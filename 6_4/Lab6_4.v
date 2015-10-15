`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:01:47 08/28/2015 
// Design Name: 
// Module Name:    Lab6_4 
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
module Lab6_4(
  button_equal,clk,rst_n,button_sel,display_ctl,display,pressed,row_out,col_out,col_n,row_n,sel_add,equal,sel_mode
    );
input clk,rst_n;
input	[3:0] col_n;
input button_sel;
input button_equal;//equal
output [14:0] display;
output [3:0] display_ctl; 
output pressed;
output [3:0] row_out,col_out,row_n;
output sel_add;
output equal;
output sel_mode;
wire clk_out;//1s
wire [1:0]clk_ctl;//for scan
wire clk_150;
wire  [3:0] bcd;
wire pressed;//new
wire [3:0]tmp;

wire sel_check;//new
wire pb_debounced_equal;//equal
wire fsm_in_equal;//equal
wire equal;//equal

reg [3:0]in_a;
reg [3:0]in_b;
reg [3:0]in1;
reg [3:0]in0;
reg [4:0]sum;
reg [3:0]result_a;
reg [3:0]result_b;
reg [3:0]in_a_tmp;
reg [3:0]in_b_tmp;
reg [3:0]result_a_tmp;
reg [3:0]result_b_tmp;
reg [3:0]Ce,Ct,Cw,Cm;
reg [3:0]z,S;
reg [3:0]w;//layer use
reg [7:0]m;
reg Co;
wire [1:0]sel_mode;//choose sel_mode
wire fsm_mode_in;

wire pb_debounced;
wire fsm_in;
assign col_out=~col_n;
assign row_out=~row_n;

//choose input is addend or augend
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		in_a<=4'd0;
		in_b<=4'd0;
	end
	else
	begin
		if(sel_add==0&&sel_check==1)
			begin
			if(tmp<=4'd9)
			begin
			in_a<=tmp;
			end
			else
			begin
			in_a<=4'd0;
			end
			end
		else if (sel_add==1&&sel_check==1)
			begin
			if(tmp<=4'd9)
			begin
			in_b<=tmp;
			end
			else
			begin
			in_b<=4'd0;
			end
			end
		else
			begin
			in_a<=in_a;
			in_b<=in_b;
			end
	end
end
always@(*)
begin
in_a_tmp<=in_a;
in_b_tmp<=in_b;
	if(sel_mode==2'b01)//add
		begin
		 z[0]= (in_a_tmp[0]^in_b_tmp[0])^0;
		 Ct[0]=(in_a_tmp[0]&in_b_tmp[0])|((in_a_tmp[0]^in_b_tmp[0])&0);
		 z[1]= in_a_tmp[1]^in_b_tmp[1]^Ct[0];
		 Ct[1]=(in_a_tmp[1]&in_b_tmp[1])|((in_a_tmp[1]^in_b_tmp[1])&Ct[0]);
		 z[2]= in_a_tmp[2]^in_b_tmp[2]^Ct[1];
		 Ct[2]=(in_a_tmp[2]&in_b_tmp[2])|((in_a_tmp[2]^in_b_tmp[2])&Ct[1]);
		 z[3]= in_a_tmp[3]^in_b_tmp[3]^Ct[2];
		 Ct[3]=(in_a_tmp[3]&in_b_tmp[3])|((in_a_tmp[3]^in_b_tmp[3])&Ct[2]);
		 Co=Ct[3]|(z[3]&z[1])|(z[3]&z[2]);
		 S[0]=z[0]^0;
		 Ce[0]=(z[0]&0)|((z[0]^0)&0);
		 S[1]=z[1]^Co^Ce[0];
		 Ce[1]=(z[1]&Co)|((z[1]^Co)&Ce[0]);
		 S[2]=z[2]^Co^Ce[1];
		 Ce[2]=(z[2]&Co)|((z[2]^Co)&Ce[1]);
		 S[3]=z[3]^0^Ce[2];
		 result_a_tmp<=Co;
		 result_b_tmp<=S;
		end
	else if (sel_mode==2'b10)//sub
		begin
		 if(in_a_tmp>=in_b_tmp)
		 begin
		 z[0]= (in_a_tmp[0]^(~in_b_tmp[0]))^1;
		 Ct[0]=(in_a_tmp[0]&(~in_b_tmp[0]))|((in_a_tmp[0]^(~in_b_tmp[0]))&1);
		 z[1]= in_a_tmp[1]^(~in_b_tmp[1])^Ct[0];
		 Ct[1]=(in_a_tmp[1]&(~in_b_tmp[1]))|((in_a_tmp[1]^(~in_b_tmp[1]))&Ct[0]);
		 z[2]= in_a_tmp[2]^(~in_b_tmp[2])^Ct[1];
		 Ct[2]=(in_a_tmp[2]&(~in_b_tmp[2]))|((in_a_tmp[2]^(~in_b_tmp[2]))&Ct[1]);
		 z[3]= in_a_tmp[3]^(~in_b_tmp[3])^Ct[2];
		 Ct[3]=(in_a_tmp[3]&(~in_b_tmp[3]))|((in_a_tmp[3]^(~in_b_tmp[3]))&Ct[2]);
		 /*Co=Ct[3]|(z[3]&z[1])|(z[3]&z[2]);
		 S[0]=z[0]^0;
		 Ce[0]=(z[0]&0)|((z[0]^0)&0);
		 S[1]=z[1]^0^Ce[0];
		 Ce[1]=(z[1]&0)|((z[1]^0)&Ce[0]);
		 S[2]=z[2]^0^Ce[1];
		 Ce[2]=(z[2]&0)|((z[2]^0)&Ce[1]);
		 S[3]=z[3]^0^Ce[2];*/
		 result_a_tmp<=4'd0;
		 result_b_tmp<=z;
		 end
		 else
		 begin
		 z[0]= (in_b_tmp[0]^(~in_a_tmp[0]))^1;
		 Ct[0]=(in_b_tmp[0]&(~in_a_tmp[0]))|((in_b_tmp[0]^(~in_a_tmp[0]))&1);
		 z[1]= in_b_tmp[1]^(~in_a_tmp[1])^Ct[0];
		 Ct[1]=(in_b_tmp[1]&(~in_a_tmp[1]))|((in_b_tmp[1]^(~in_a_tmp[1]))&Ct[0]);
		 z[2]= in_b_tmp[2]^(~in_a_tmp[2])^Ct[1];
		 Ct[2]=(in_b_tmp[2]&(~in_a_tmp[2]))|((in_b_tmp[2]^(~in_a_tmp[2]))&Ct[1]);
		 z[3]= in_b_tmp[3]^(~in_a_tmp[3])^Ct[2];
		 Ct[3]=(in_b_tmp[3]&(~in_a_tmp[3]))|((in_b_tmp[3]^(~in_a_tmp[3]))&Ct[2]);
		 result_a_tmp<=4'd15;
		 result_b_tmp<=z;
		 end
		end
	else if (sel_mode==2'b11)//mutiple
		begin
			m[0]= in_a_tmp[0]&in_b_tmp[0];
			//FA layer 1
			m[1]= ((in_a_tmp[1]&in_b_tmp[0])^(in_a_tmp[0]&in_b_tmp[1]))^0;
		   Ct[0]=((in_a_tmp[1]&in_b_tmp[0])&(in_a_tmp[0]&in_b_tmp[1]))|(((in_a_tmp[1]&in_b_tmp[0])^(in_a_tmp[0]&in_b_tmp[1]))&0);
			z[0]=	((in_a_tmp[2]&in_b_tmp[0])^(in_a_tmp[1]&in_b_tmp[1]))^0;
			Ct[1]=((in_a_tmp[2]&in_b_tmp[0])&(in_a_tmp[1]&in_b_tmp[1]))|(((in_a_tmp[2]&in_b_tmp[0])^(in_a_tmp[1]&in_b_tmp[1]))&0);
			z[1]=	((in_a_tmp[3]&in_b_tmp[0])^(in_a_tmp[2]&in_b_tmp[1]))^0;
			Ct[2]=((in_a_tmp[3]&in_b_tmp[0])&(in_a_tmp[2]&in_b_tmp[1]))|(((in_a_tmp[3]&in_b_tmp[0])^(in_a_tmp[2]&in_b_tmp[1]))&0);
			//FA layer 2
			m[2]= (z[0]^(in_a_tmp[0]&in_b_tmp[2]))^Ct[0];
		   Ce[0]=(z[0]&(in_a_tmp[0]&in_b_tmp[2]))|((z[0]^(in_a_tmp[0]&in_b_tmp[2]))&Ct[0]);
			S[0]=	(z[1]^(in_a_tmp[1]&in_b_tmp[2]))^Ct[1];
			Ce[1]=(z[1]&(in_a_tmp[1]&in_b_tmp[2]))|((z[1]^(in_a_tmp[1]&in_b_tmp[1]))&Ct[1]);
			S[1]=	((in_a_tmp[3]&in_b_tmp[1])^(in_a_tmp[2]&in_b_tmp[2]))^Ct[2];
			Ce[2]=((in_a_tmp[3]&in_b_tmp[1])&(in_a_tmp[2]&in_b_tmp[2]))|(((in_a_tmp[3]&in_b_tmp[1])^(in_a_tmp[2]&in_b_tmp[2]))&Ct[2]);
			//FA layer 3
			m[3]= (S[0]^(in_a_tmp[0]&in_b_tmp[3]))^Ce[0];
		   Cw[0]=(S[0]&(in_a_tmp[0]&in_b_tmp[3]))|((S[0]^(in_a_tmp[0]&in_b_tmp[3]))&Ce[0]);
			w[0]=	(S[1]^(in_a_tmp[1]&in_b_tmp[3]))^Ce[1];
			Cw[1]=(S[1]&(in_a_tmp[1]&in_b_tmp[3]))|((S[1]^(in_a_tmp[1]&in_b_tmp[3]))&Ce[1]);
			w[1]=	((in_a_tmp[3]&in_b_tmp[2])^(in_a_tmp[2]&in_b_tmp[3]))^Ce[2];
			Cw[2]=((in_a_tmp[3]&in_b_tmp[2])&(in_a_tmp[2]&in_b_tmp[3]))|(((in_a_tmp[3]&in_b_tmp[2])^(in_a_tmp[2]&in_b_tmp[3]))&Ce[2]);
			//FA layer 4
			m[4]= (w[0]^0)^Cw[0];
		   Cm[0]=(w[0]&0)|((w[0]^0)&Cw[0]);
			m[5]=	(w[1]^Cm[0])^Cw[1];
			Cm[1]=(w[1]&Cm[0])|((w[1]^Cm[0])&Cw[1]);
			m[6]=	((in_a_tmp[3]&in_b_tmp[3])^Cm[1])^Cw[2];
			m[7]=((in_a_tmp[3]&in_b_tmp[3])&Cm[1])|(((in_a_tmp[3]&in_b_tmp[3])^Cm[1])&Cw[2]);
			
			result_a_tmp<=m/10;
			result_b_tmp<=m%10;
		end	
	else
		begin
			in_a_tmp<=in_a_tmp;
			in_b_tmp<=in_b_tmp;
			result_a_tmp<=4'd0;
			result_b_tmp<=4'd0;
		end
end

always@(*)
begin
	if(equal==1)
	begin
	result_a<=result_a_tmp;
	result_b<=result_b_tmp;
	end
	else
	begin
	in0<=4'd0;
	in1<=4'd0;
	result_a<=4'd0;
	result_b<=4'd0;
	end
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
	.in0(in_a), // 1st input
	.in1(in_b), // 2nd input
	.in2(result_a), // 3rd input
	.in3(result_b), // 4th input
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

Pause_one Pl(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_debounced), // input trigger
.out_pulse(fsm_in) // output one pulse
);

Fsm Fl( 
    .rst(rst_n),
	 .clk(clk),
	 .sel_out(sel_add),
	 .in(fsm_in)
    );
add_zero azl( 
.pressed(pressed),
.sel_check(sel_check)
    );

debounce_equal del(
.clk(clk_150), // clock control
.rst_n(rst_n), // reset
.pb_in(button_equal), //push button input
.pb_debounced(pb_debounced_equal) // debounced push button output
);
one_pause_equal opel(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pb_debounced_equal), // input trigger
.out_pulse(fsm_in_equal) // output one pulse
);	 
fsm_equal fel(
  .rst(rst_n),
  .clk(clk),
  .sel_out(equal),
  .in(fsm_in_equal)
    );
/*one_pause_mode(
.clk(clk), // clock input
.rst_n(rst_n), //active low reset
.in_trig(pressed), // input trigger
.out_pulse(fsm_mode_in) // output one pulse
);*/
fsm_mode fml(
  .rst(rst_n),
  .clk(clk_150),
  .sel_out(sel_mode),
  .sel_state(tmp)
  //.in(fsm_mode_in)
    );
endmodule




