module even_pipe(clk,ra,rb,rc,op_code,i7,i8,i10,i16,rt,unit_id,reg_wr,latency,l7,flush3,flush4,reg_dest,out_reg_dest,reg_dest1,reg_dest2,reg_dest3,reg_dest4,reg_dest5,reg_dest6,reg_dest7,l1,l2,l3,l4,l5,l6,r_temp1,r_temp2,r_temp3,r_temp4,r_temp5,r_temp6,r_temp7);
input clk,flush3,flush4;
input signed [0:127] ra;
input signed [0:127] rb;
input signed [0:127] rc;
input unsigned [0:10] op_code;
input signed [0:6] i7;
input signed [0:7] i8;
input signed [0:9] i10;
input signed [0:15] i16;
input unsigned [0:6] reg_dest;
output logic signed [0:127] rt;
output logic unsigned [0:2] unit_id;
output logic unsigned reg_wr;
output logic unsigned [0:6] out_reg_dest;
output logic unsigned [0:2] latency;
output logic unsigned [0:6] reg_dest1,reg_dest2,reg_dest3,reg_dest4,reg_dest5,reg_dest6,reg_dest7;
output logic signed [0:127] r_temp1,r_temp2,r_temp3,r_temp4,r_temp5,r_temp6,r_temp7;
logic signed [0:7] b;
logic signed [0:9] b1,ra_r1,rb_r1;
logic signed [0:15] r,s,q,m1,m2;
logic signed [0:31] t,u,v;
logic unsigned flush3_done,flush4_done;
logic unsigned reg_wr1,reg_wr2,reg_wr3,reg_wr4,reg_wr5,reg_wr6,reg_wr7;
logic [0:31] S_min = 32'h0082ab1e;
logic [0:31] S_max = 32'h7fffffff;
logic [0:31] neg_S_max = 32'hffffffff;
logic unsigned [0:2] u1,unit_id1,unit_id2,unit_id3,unit_id4,unit_id5,unit_id6,unit_id7;
output logic unsigned [0:2] l1,l2,l3,l4,l5,l6,l7;
logic unsigned [0:2] l;
shortreal ra_real,rb_real,rc_real,rt_real,Smax,Smin,float;
parameter bytes = 8;
parameter halfword = 16;
parameter word = 32;
integer count = 0;
always_comb begin
for(int i=0;i<6;i++) begin //repelftbit(i10,16)
s[i] = i10[0];
end
s[6:15]=i10;
for(int i=0;i<22;i++) begin //repleftbit(i10,32)
t[i] = i10[0];

end
t[22:31]=i10;
Smax = $bitstoshortreal(S_max);
Smin = $bitstoshortreal(S_min);
case (op_code)
11'b00011001000: begin
for(int i =0;i< 8;i++) begin //add halfword//
r_temp1[i*halfword +: halfword] = ra[i*halfword +: halfword] + rb[i*halfword +: halfword];
end
u1 = 0;l = 2;reg_wr1 =1;//fflag_out = 0;
end
11'b00000011101: begin
for(int i =0;i< 8;i++) begin //add halfword immediate//
r_temp1[i*halfword +: halfword] = ra[i*halfword +: halfword] + s;
end
u1= 0;l = 2;reg_wr1 =1;
end
11'b00011000000: begin
for(int i =0;i< 4;i++) begin //add word//
r_temp1[i*word +: word] = ra[i*word +: word] + rb[i*word +: word];
end
u1= 0;l = 2;reg_wr1 =1;
end
11'b00000011100: begin
for(int i =0;i< 4;i++) begin //add word immediate//
r_temp1[i*word +: word] = ra[i*word +: word] + t;
end
u1= 0;l = 2;reg_wr1 =1;
end
11'b00001001000: begin
for(int i =0;i< 8;i++) begin //subtract halfword//
r_temp1[i*halfword +: halfword] = rb[i*halfword +: halfword] + (~ra[i*halfword +: halfword]) + 1;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00000001101: begin
for(int i =0;i< 8;i++) begin //subtract halfword immediate//
r_temp1[i*halfword +: halfword] = s + (~ra[i*halfword +: halfword]) + 1;

end
u1= 0;l =2;reg_wr1 =1;
end
11'b00001000000: begin
for(int i =0;i< 4;i++) begin //subtract word//
r_temp1[i*word +: word] = rb[i*word +: word] + (~ra[i*word +: word]) + 1;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00000001100: begin
for(int i =0;i< 4;i++) begin //subtract word immediate//
r_temp1[i*word +: word] = t + (~ra[i*word +: word]) + 1;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01010100101: begin
for(int i =0;i<4;i++) begin //count leading zeroes//
count = 0;
u = ra[i*word +: word];
for(int j=0;j<word;j++) begin
if(u[j]== 0)
count = count +1;
else if(u[j] == 1)
break;
end
r_temp1[i*word +: word] = count;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00011000001: begin
for(int i =0;i< 4;i++) begin //and//
r_temp1[i*word +: word] = ra[i*word +: word] & rb[i*word +: word];
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01011000001: begin
for(int i =0;i< 4;i++) begin //and with compliment//
r_temp1[i*word +: word] = ra[i*word +: word] & (~rb[i*word +: word]);
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00000010101: begin
for(int i =0;i< 8;i++) begin //and halfword immediate//

r_temp1[i*halfword +: halfword] = ra[i*halfword +: halfword] & s;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00000010100: begin
for(int i =0;i< 4;i++) begin //and word immediate//
r_temp1[i*word +: word] = ra[i*word +: word] & t;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00001000001: begin
for(int i =0;i< 4;i++) begin //or//
r_temp1[i*word +: word] = ra[i*word +: word] | rb[i*word +: word];
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01011001001: begin
for(int i =0;i< 4;i++) begin //or with compliment//
r_temp1[i*word +: word] = ra[i*word +: word] | (~rb[i*word +: word]);
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00000000101: begin
for(int i =0;i< 8;i++) begin //or halfword immediate//
r_temp1[i*halfword +: halfword] = ra[i*halfword +: halfword] | s;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00000000100: begin
for(int i =0;i< 4;i++) begin //or word immediate//
r_temp1[i*word +: word] = ra[i*word +: word] | t;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01001000001: begin
for(int i =0;i< 4;i++) begin //exclusive or//
r_temp1[i*word +: word] = ra[i*word +: word] ^ rb[i*word +: word];
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00001000101: begin

for(int i =0;i< 8;i++) begin //exclusive or halfword immediate//
r_temp1[i*halfword +: halfword] = ra[i*halfword +: halfword] ^ s;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00001000100: begin
for(int i =0;i< 4;i++) begin //exclusive or word immediate//
r_temp1[i*word +: word] = ra[i*word +: word] ^ t;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00011001001: begin
for(int i =0;i< 4;i++) begin //nand//
r_temp1[i*word +: word] = ~(ra[i*word +: word] & rb[i*word +: word]);
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00001001001: begin
for(int i =0;i< 4;i++) begin //nor//
r_temp1[i*word +: word] = ~(ra[i*word +: word] | rb[i*word +: word]);
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01001001001: begin
for(int i =0;i< 4;i++) begin //equivalent//
r_temp1[i*word +: word] = ra[i*word +: word] ~^ rb[i*word +: word];
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00000001000: begin
for(int i =0;i< 1;i++) begin //select bits//
r_temp1[i*halfword +: halfword] = (rc[i*halfword +: halfword] & rb[i*halfword +: halfword])|(~(rc[i*halfword +: halfword]) & ra[i*halfword +: halfword]);
end
u1= 0;l =2;reg_wr1 =1;
end
11'b00001011111: begin
for(int i =0;i< 8;i++) begin //shift left halfword//
s = rb[i*halfword +: halfword] & 16'h001f;
q = ra[i*halfword +: halfword];
if(s == 0)

r = q;
else if(1 <= s < halfword)
r = q << s;
else r = 0;
r_temp1[i*halfword +: halfword] = r;
end
u1= 1;l =4;reg_wr1 =1;
end
11'b00001011011: begin
for(int i =0;i< 4;i++) begin //shift left word//
t = rb[i*word +: word] & 32'h0000001f;
u = ra[i*word +: word];
if(t == 0)
v = u;
else if(1 <= t < word)
v = u << t;
else v = 0;
r_temp1[i*word +: word] = v;
end
u1= 1;l =4;reg_wr1 =1;
end
11'b00001011100: begin
for(int i =0;i< 8;i++) begin //rotate halfword//
s = rb[i*halfword +: halfword] & 16'h000f;
q = ra[i*halfword +: halfword];
if(s == 0)
r = q;
else if (s < 16)begin
for(int j =0;j< 16;j++)begin
if(j + s <16)
r[j] = q[j+s];
else r[j] = q[(j + s) - 16];
end
end
r_temp1[i*halfword +: halfword] = r;
end
u1= 1;l =4;reg_wr1 =1;
end
11'b00001011000: begin
for(int i =0;i< 4;i++) begin //rotate word//
t = rb[i*word +: word] & 16'h001f;
u = ra[i*word +: word];
if(t == 0)
v = u;
else if (t < 32)begin
for(int j =0;j< 32;j++)begin
if(j + t <32)

v[j] = u[j+t];
else v[j] = u[(j + t) - 32];
end
end
r_temp1[i*word +: word] = v;
end
u1= 1;l =4;reg_wr1 =1;
end
11'b01111010000: begin
for(int i =0;i< 16;i++) begin //compare equal byte//
if(ra[i*bytes +: bytes] == rb[i*bytes +: bytes])
r_temp1[i*bytes +: bytes] = 8'hff;
else r_temp1[i*bytes +: bytes] = 8'h00;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01111001000: begin
for(int i =0;i< 8;i++) begin //compare equal halfword//
if(ra[i*halfword +: halfword] == rb[i*halfword +: halfword])
r_temp1[i*halfword +: halfword] = 16'hffff;
else r_temp1[i*halfword +: halfword] = 16'h0000;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01001010000: begin
for(int i =0;i< 16;i++) begin //compare greater than byte//
if(ra[i*bytes +: bytes] > rb[i*bytes +: bytes])
r_temp1[i*bytes +: bytes] = 8'hff;
else r_temp1[i*bytes +: bytes] = 8'h00;
end
u1= 0;l =2;reg_wr1 =1;
end
11'b01001001000: begin
for(int i =0;i< 8;i++) begin //compare greater than halfword//
if(ra[i*halfword +: halfword] > rb[i*halfword +: halfword])
r_temp1[i*halfword +: halfword] = 16'hffff;
else r_temp1[i*halfword +: halfword] = 16'h0000;
end
u1= 0;l =2;reg_wr1 =1;
end

11'b01111000100: begin
for(int i=0;i<4;i++) begin //multiply//
m1 = ra[i*word + halfword +: halfword] ;m2= rb[i*word + halfword +: halfword];
r = m1*m2;
for(int i=0;i<16;i++) begin
t[i] = r[0];
end
t[16:31] = r;
r_temp1[i*word +: word] = t;
end
u1= 3;l =7;reg_wr1 =1;
end
11'b00001110100: begin
for(int i=0;i<4;i++) begin //multiply immediate//
m1 = ra[i*word + halfword +: halfword];
r = m1 * s;
for(int i=0;i<16;i++) begin
t[i] = r[0];
end
r_temp1[i*word +: word] = t;
end
u1= 3;l =7;reg_wr1 =1;
end
11'b10000001100: begin
for(int i=0;i<4;i++) begin //multiply and add//
m1 = ra[i*word + halfword +: halfword]; m2 = rb[i*word + halfword +: halfword];
r = m1*m2;
for(int i=0;i<16;i++) begin
t[i] = r[0];
end
t[16:31] = r;
r_temp1[i*word +: word] = t + rc[i*word +: word] ;
end
u1= 3;l =7;reg_wr1 =1;
end
11'b01010110100: begin
for(int i =0;i<16;i++) begin //count ones in bytes//
count = 0;
b = ra[i*bytes +: bytes];
for(int j=0;j<bytes;j++) begin
if(b[j]== 1)
count = count +1;
else if(b[j] == 0)
count = count +0;
end
r_temp1[i*bytes +: bytes] = count;

end
u1= 4;l =4;reg_wr1 =1;
end
11'b00011010011: begin //average bytes//
for(int i=0;i<16;i++)begin
ra_r1 = {00,ra[i*bytes +: bytes]}; rb_r1 = {00,rb[i*bytes +: bytes]};
b1 = ra_r1 + rb_r1 + 1;
b1 = b1 >> 1;
b = b1[2:9];
r_temp1[i*bytes +: bytes] = b;
end
u1= 4;l =4;reg_wr1 =1;
end
11'b01011000100: begin
for(int i =0;i< 4;i++) begin //floating add//
ra_real = $bitstoshortreal(ra[i*word +: word]);
rb_real = $bitstoshortreal(rb[i*word +: word]);
rt_real= ra_real + rb_real;
t = $shortrealtobits(rt_real);
if(t[0]==1)begin
t[0] = 0;
float = $bitstoshortreal(t);
if(float > Smax)
r_temp1[i*word +: word] = neg_S_max;
else if(Smin > float)
r_temp1[i*word +: word] = 0;
else
r_temp1[i*word +: word] = $shortrealtobits(rt_real);
end
else begin
if(rt_real > Smax)
r_temp1[i*word +: word] = $shortrealtobits(Smax);
else if(Smin > rt_real)
r_temp1[i*word +: word] = 0;
else
r_temp1[i*word +: word] = t;
end
end
u1= 2;l = 6;reg_wr1 =1;
end
11'b01011000101: begin
for(int i =0;i< 4;i++) begin //floating subtract//
ra_real = $bitstoshortreal(ra[i*word +: word]);

rb_real = $bitstoshortreal(rb[i*word +: word]);
rt_real= rb_real - ra_real;
t = $shortrealtobits(rt_real);
if(t[0]==1)begin
t[0] = 0;
float = $bitstoshortreal(t);
if(float > Smax)
r_temp1[i*word +: word] = neg_S_max;
else if(Smin > float)
r_temp1[i*word +: word] =0;
else
r_temp1[i*word +: word] = $shortrealtobits(rt_real);
end
else begin
if(rt_real > Smax)
r_temp1[i*word +: word] = $shortrealtobits(Smax);
else if(Smin >rt_real)
r_temp1[i*word +: word] = 0;
else
r_temp1[i*word +: word] = t;
end
end
u1= 2;l = 6;reg_wr1 =1;
end
11'b01011000110: begin
for(int i =0;i< 4;i++) begin //floating multiply//
ra_real = $bitstoshortreal(ra[i*word +: word]);
rb_real = $bitstoshortreal(rb[i*word +: word]);
rt_real= rb_real * ra_real;
t = $shortrealtobits(rt_real);
if(t[0]==1)begin
t[0] = 0;
float = $bitstoshortreal(t);
if(float > Smax)
r_temp1[i*word +: word] = neg_S_max;
else if(Smin > float)
r_temp1[i*word +: word] = 0;
else
r_temp1[i*word +: word] = $shortrealtobits(rt_real);
end
else begin
if(rt_real > Smax)
r_temp1[i*word +: word] = $shortrealtobits(Smax);

else if(Smin > rt_real)
r_temp1[i*word +: word] = 0;
else
r_temp1[i*word +: word] = t;
end
end
u1= 2;l = 6;reg_wr1 =1;
end
11'b00000001110: begin
for(int i =0;i< 4;i++) begin //floating multiply and add//
ra_real = $bitstoshortreal(ra[i*word +: word]);
rb_real = $bitstoshortreal(rb[i*word +: word]);
rc_real = $bitstoshortreal(rc[i*word +: word]);
rt_real= (rb_real * ra_real) + rc_real;
t = $shortrealtobits(rt_real);
if(t[0]==1)begin
t[0] = 0;
float = $bitstoshortreal(t);
if(float > Smax)
r_temp1[i*word +: word] = neg_S_max;
else if(Smin > float)
r_temp1[i*word +: word] = 0;
else
r_temp1[i*word +: word] = $shortrealtobits(rt_real);
end
else begin
if(rt_real > Smax)
r_temp1[i*word +: word] = $shortrealtobits(Smax);
else if(Smin > rt_real )
r_temp1[i*word +: word] = 0;
else
r_temp1[i*word +: word] = t;
end
end
u1= 2;l = 6;reg_wr1 =1;
end
11'b01000000001: begin //nop(execute)
r_temp1 = 128'bz;
reg_wr1 = 0;
end

default: r_temp1 = 128'bz;
endcase
reg_dest1 = reg_dest;
unit_id1 = u1;
l1 = l;
rt = r_temp7;
out_reg_dest = reg_dest7;
reg_wr = reg_wr7;
if(flush3_done == 1 || flush4_done == 1)begin
r_temp1 = 128'bx;
reg_dest1 = 7'bx;
l1 = 3'bx;
reg_wr1 = 1'b0;
end
end
always_ff @(posedge clk) begin
flush3_done <= flush3;flush4_done <= flush4;
if(flush3 == 1)begin
r_temp2 <= 128'bx;
r_temp3 <= 128'bx;
r_temp4 <= r_temp3;
l2 <= 3'bx;
l3 <= 3'bx;
l4 <= l3;
reg_dest2<= 7'bx;
reg_dest3<= 7'bx;
reg_dest4 <= reg_dest3;
reg_wr2 <= 1'b0;
reg_wr3 <= 1'b0;
reg_wr4 <= reg_wr3;
end
else if(flush4 == 1)begin
r_temp2 <= 128'bx;
r_temp3 <= 128'bx;
r_temp4 <= 128'bx;
l2 <= 3'bx;
l3 <= 3'bx;
l4 <= 3'bx;
reg_dest2<= 7'bx;
reg_dest3<= 7'bx;
reg_dest4<= 7'bx;
reg_wr2 <= 1'b0;
reg_wr3 <= 1'b0;
reg_wr4 <= 1'b0;
end
else begin

r_temp2 <= r_temp1;
r_temp3 <= r_temp2;
r_temp4 <= r_temp3;
l2 <= l1;
l3 <= l2;
l4 <= l3;
reg_dest2<= reg_dest1;
reg_dest3<= reg_dest2;
reg_dest4<= reg_dest3;
reg_wr2 <= reg_wr1;
reg_wr3 <= reg_wr2;
reg_wr4 <= reg_wr3;
end
r_temp5 <= r_temp4;
r_temp6 <= r_temp5;
r_temp7 <= r_temp6;
reg_dest5<= reg_dest4;
reg_dest6<= reg_dest5;
reg_dest7<= reg_dest6;
// out_reg_dest<= reg_dest7;
unit_id2 <= unit_id1;
unit_id3 <= unit_id2;
unit_id4 <= unit_id3;
unit_id5 <= unit_id4;
unit_id6 <= unit_id5;
unit_id7 <= unit_id6;
unit_id <= unit_id7;
l5 <= l4;
l6 <= l5;
l7 <= l6;
latency <= l7;
reg_wr5 <= reg_wr4;
reg_wr6 <= reg_wr5;
reg_wr7 <= reg_wr6;
// reg_wr <= reg_wr7;
end
endmodule

