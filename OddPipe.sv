module oddPipe(clk,ra,rb,rc,opcode,i18,i10,i16,i7,ipc,rt,pc,Unit_ID,r_wr,im_6,latency,fflag_out,flush3,flush4,fflag_regfetch,fflag_done_is,fflag_done_de,fflag_done_fe,reg_dest,out_reg_dest,reg_dest1,reg_dest2,reg_dest3,reg_dest4,reg_dest5,reg_dest6,reg_dest7,l1,l2,l3,l4,l5,l6,l7,rt_1,rt_2, rt_3,rt_4,rt_5,rt_6,rt_7,inst_block,rg_mem_out);
input clk;
input signed [0:127] ra,rb,rc;
input [0:10] opcode;
input signed [0:9] i10;
input signed [0:15] i16;
input signed [0:17] i18;
input signed [0:6] i7;
input signed [0:14] ipc;
input unsigned [0:6] reg_dest;
input [0:32767][0:7] rg_mem_out;
output logic signed [0:127] rt;

output logic signed [0:14] pc = 14'b0;
output logic unsigned r_wr,im_6 = 0;
output logic unsigned [0:6] reg_dest1,reg_dest2,reg_dest3,reg_dest4,reg_dest5,reg_dest6,reg_dest7,out_reg_dest;
output logic flush3,flush4;
output logic fflag_out = 0,fflag_regfetch,fflag_done_is,fflag_done_de,fflag_done_fe;
output logic [0:2] l1,l2,l3,l4,l5,l6,l7,latency,Unit_ID;
output logic signed [0:127] rt_1,rt_2, rt_3, rt_4, rt_5,rt_6,rt_7;
output logic unsigned [0:1023] inst_block;
logic [0:31] LSLR = 32'h00007fff;
logic [0:31] mask = 32'hfffffff0;
logic [0:14] LSA;
logic [0:31] t;
logic [0:15] s;
logic [0:2] sh; //shift_count for bit
logic [0:7] b; //shift_count for byte
logic signed [0:31] imm_32;
logic signed [0:127] R;
logic signed [0:31] t0;
logic signed [0:14] pc_temp; //to hold output pc value
logic r_wr_temp;
logic [0:2] U_id;
logic [0:2] U1,U2,U3,U4,U5,U6,U7;
logic [0:2] Lat_tag;
logic r_wr_1,r_wr_2,r_wr_3,r_wr_4,r_wr_5,r_wr_6,r_wr_7;
logic signed [0:14] pc_1,pc_2,pc_3;
logic flush_flag =0 ,fflag0 = 0,fflag_done; //flags for branch flush
logic [0:14] ipc0,ipc1;
logic im_1 = 0,im_2,im_3,im_4,im_5;
logic signed [0:32767][0:7] mem;
integer i;
logic [0:127] datain;
logic [0:1023] dataout;
logic [0:14] addr;
memory m(clk,r_wr_temp,im_1,datain,dataout,addr,fflag0,fflag_out,fflag_done,rg_mem_out);
always_comb begin
if(opcode==11'b00000110100 || opcode==11'b00111000100 || opcode==11'b00001100001 || opcode==11'b00010000011 || opcode==11'b00010000001 || opcode==11'b00000100001) begin //Load
U_id = 3'b110;
Lat_tag = 3'd6;
end
else if(opcode==11'b00000100100 || opcode==11'b00101000100 || opcode==11'b0001000001) begin // for store
U_id = 3'b110;
Lat_tag = 3'd6;
end
else if(opcode==11'b00001100100 || opcode==11'b00001100000 || opcode==11'b00001000010 || opcode==11'b00001000000) begin //branch

U_id = 3'b111;
Lat_tag = 3'd4;
end
else if(opcode==11'b00111011011 || opcode==11'b00111111111 || opcode==11'b00111011000 || opcode==11'b00111111000) begin //permute
U_id = 3'b101;
Lat_tag = 3'd4;
end
r_wr_1 = r_wr_temp;
U1 = U_id;
if(fflag_done == 1)begin
l1 = 3'bx;
reg_dest1 = 7'bx;
pc_1 = 15'bx;
end
else begin
l1 = Lat_tag;
reg_dest1 = reg_dest;
pc_1 = pc_temp;
end
fflag_regfetch = fflag_out;fflag_done_is = fflag_regfetch;fflag_done_de = fflag_done_is;fflag_done_fe = fflag_done_de;
pc = pc_3;
out_reg_dest = reg_dest7;
rt = rt_7;
r_wr = r_wr_7;
end
always_ff @(posedge clk) begin
if(fflag_out == 1)begin
rt_2 <= 128'bx;
rt_3 <= 128'bx;
end
else begin
rt_2 <= rt_1;
rt_3 <= rt_2;
end
rt_4 <= rt_3;
rt_5 <= rt_4;
rt_6 <= rt_5;
rt_7 <= rt_6;
U2 <= U1; U3 <= U2; U4 <= U3; U5 <= U4; U6 <= U5; U7 <= U6;Unit_ID <= U7;
l2<=l1; l3<= l2; l4 <= l3; l5 <= l4; l6<= l5; l7 <= l6;latency <= l7;
if(fflag_out == 1)begin
reg_dest2<= 7'bx;
reg_dest3<= 7'bx;
pc_2 <= 15'bx; pc_3 <= 15'bx;
r_wr_2 <= 1'b0; r_wr_3 <= 1'b0;
im_2 <= 1'bx;im_3 <= 1'bx;
end
else begin
reg_dest2<= reg_dest1;
reg_dest3<= reg_dest2;
pc_2 <= pc_1; pc_3 <= pc_2;
r_wr_2 <= r_wr_1; r_wr_3 <= r_wr_2;
im_2 <= im_1;im_3 <= im_2;
end

reg_dest4<= reg_dest3;
reg_dest5<= reg_dest4;
reg_dest6<= reg_dest5;
reg_dest7<= reg_dest6;
// out_reg_dest<= reg_dest7;
r_wr_4 <= r_wr_3;
r_wr_5 <= r_wr_4; r_wr_6 <= r_wr_5; r_wr_7 <= r_wr_6;
//r_wr <= r_wr_7;
im_4 <= im_3;
im_5 <= im_4;
im_6 <= im_5;
ipc0 <= ipc;ipc1 <= ipc0;
fflag0 <= flush_flag;fflag_out<= fflag0; fflag_done <= fflag_out;
end
always_comb begin
if(fflag_out == 1 && ipc1[12] == 0)
flush4 = 1;
else flush4 = 0;
if(fflag_out == 1 && ipc1[12] == 1)
flush3 = 1;
else flush3 = 0;
end
always_comb begin
case(opcode)
11'b00000110100: begin //Load Quadword d-form
imm_32[28:31]=4'b0000;
imm_32[18:27]=i10[0:9];
for(i=0;i<18;i=i+1) begin
imm_32[i] = i10[0];
end
LSA = (imm_32[0:31] + ra[0:31])& LSLR & mask;
addr = LSA;
rt_1 = dataout[0:127];
r_wr_temp = 1'b1;
end
11'b00111000100: begin //Load Quadword x-form
LSA = (ra[0:31] + rb[0:31])& LSLR & mask;
addr = LSA;
rt_1 = dataout[0:127];
r_wr_temp = 1'b1;
end
11'b00001100001: begin //Load Quadword a-form
imm_32[30:31]=2'b00;
imm_32[14:29]=i16[0:15];
for(i=0;i<14;i=i+1)
imm_32[i]=i16[0];
LSA = imm_32 & LSLR & mask;
addr = LSA;
for(i=0;i<16;i=i+1)
rt_1 = dataout[0:127];

r_wr_temp = 1'b1;
end
11'b00000100100: begin //Store Quadword d-form
imm_32[28:31]=4'b0000;
imm_32[18:27]=i10[0:9];
for(i=0;i<18;i=i+1) begin
imm_32[i] = i10[0];
end
LSA = (imm_32[0:31] + ra[0:31])& LSLR & mask;
addr = LSA;
datain = rc;
r_wr_temp=1'b0;
end
11'b00101000100: begin //Store Quadword x-form
LSA = (ra[0:31] + rb[0:31])& LSLR & mask;
addr = LSA;
datain = rc;
r_wr_temp = 1'b0;
end
11'b0001000001: begin //Store Quadword a-form
imm_32[30:31]=2'b00;
imm_32[14:29]=i16[0:15];
for(i=0;i<14;i=i+1)
imm_32[i]=i16[0];
LSA = imm_32 & LSLR & mask;
addr = LSA;
datain = rc;
r_wr_temp = 1'b0;
end
11'b00010000011: begin //Immediate Load Halfword
s = i16;
for(i=0;i<16;i=i+2)
rt_1[i*8+:16] = s[0:15];
r_wr_temp = 1'b1;
end
11'b00010000001: begin //Immediate Load Word
t[16:31] = i16[0:15];
for(i=0;i<16;i=i+1)
t[i]=i16[0];
for(i=0;i<16;i=i+4)
rt_1[i*8+:32] = t[0:31];
r_wr_temp = 1'b1;
end
11'b00000100001: begin //Immediate Load Address
t[14:31] = i18;
for(i=0;i<14;i=i+1)
t[i] = 0;
for(i=0;i<16;i=i+4)
rt_1[i*8+:32] = t;
r_wr_temp = 1'b1;
end
//BRANCH
11'b00001100100: begin //Branch Relative
t0[30:31] = 2'b00;
t0[14:29] = i16;
for(i=0;i<14;i=i+1)
t0[i] = i16[0];
pc_temp = (ipc + t0) & LSLR;

if(pc_temp%8 != 0)
pc_temp = pc_temp - 4;
else pc_temp = pc_temp + 0;
r_wr_temp = 1'b0;
flush_flag = 1'b1; //branch taken
end
11'b00001100000: begin //Branch Absolute
t0[30:31] = 2'b00;
t0[14:29] = i16;
for(i=0;i<14;i=i+1)
t0[i] = i16[0];
pc_temp = t0 & LSLR;
r_wr_temp = 1'b0;
flush_flag = 1'b1; //branch taken
end
11'b00001000010: begin //Branch if not zero word
if(rc[0:31]!= 0) begin
t[30:31] = 2'b00;
t[14:29] = i16;
for(i=0;i<14;i=i+1)
t[i] = i16[0];
pc_temp = (ipc + t) & LSLR & 32'hfffffffc;
if(pc_temp%8 != 0)
pc_temp = pc_temp - 4;
else pc_temp = pc_temp + 0;
flush_flag = 1'b1; //branch taken
end
else begin
pc_temp = (ipc + 4) & LSLR;
flush_flag = 1'b0; //branch not taken
end
r_wr_temp = 1'b0;
end
11'b00001000000: begin //Branch if zero word
if(rc[0:31]==32'd0) begin
t[30:31] = 2'b00;
t[14:29] = i16[0:15];
for(i=0;i<14;i=i+1)
t[i] = i16[0];
pc_temp = (ipc + t) & LSLR & 32'hfffffffc;
if(pc_temp%8 != 0)
pc_temp = pc_temp - 4;
else pc_temp = pc_temp + 0;
flush_flag = 1'b1; //branch taken
end
else begin
pc_temp = (ipc + 4) & LSLR;
flush_flag = 1'b0; //branch not taken
end
r_wr_temp = 1'b0;
end
11'b00000000001: begin //No Operation (Load)
r_wr_temp = 1'b0;
rt_1 = 128'bz;
end
11'b00111011011: begin //Shift left Quadword by Bits
sh = rb[29:31];
for(i=0;i<128;i=i+1) begin

if((i+sh)<128)
R[i] = ra[i+sh];
else
R[i] = 1'b0;
end
rt_1 = R;
r_wr_temp = 1'b1;
end
11'b00111111111: begin //Shift left Quadword by Bytes Immediate
b = i7 & 8'h1f;
for(i=0;i<16;i=i+1) begin
if((b+i)<16)
R[i*8+:8] = ra[(b+i)*8+:8];
else
R[i*8+:8] = 8'd0;
end
rt_1[0:127] = R[0:127];
r_wr_temp = 1'b1;
end
11'b00111011000: begin //Rotate quadword by bits
sh[0:2] = rb[29:31];
for(i=0;i<128;i=i+1) begin
if((sh+i)<128)
R[i] = ra[sh+i];
else
R[i] = ra[sh+i-128];
end
rt_1[0:127] = R[0:127];
r_wr_temp = 1'b1;
end
11'b00111111000: begin //Rotate quadword by bits immediate
sh = i7[4:6];
for(i=0;i<128;i=i+1) begin
if((sh+i)<128)
R[i] = ra[sh+i];
else
R[i] = ra[sh+i-128];
end
rt_1[0:127] = R[0:127];
r_wr_temp = 1'b1;
end
11'b01111011000: begin //Halt if equal
if(ra[0:31] == rb[0:31]) begin
$stop;
end
r_wr_temp = 1'b0;
end
11'b00001111111: begin //Halt if equal immediate
t[22:31]=i10[0:9];
for(i=0;i<22;i=i+1)
t[i] = i10[0];
if(ra[0:31] == t[0:31]) begin
$stop;
end
r_wr_temp = 1'b0;
end

11'b11111111111: begin //Instruction miss
addr = ipc & 15'h7f80;
r_wr_temp = 1'b0;
im_1=1'b1;
inst_block = dataout;
end
default : rt_1 = 128'bz;
endcase
if(fflag0 == 1 || fflag_out == 1 || fflag_done == 1)
flush_flag = 1'b0;
if(fflag_done == 1)begin
rt_1 = 128'bx;
r_wr_temp = 1'b0;
im_1 = 1'bx;
end
if(im_2 == 1)
im_1 =0;
end
endmodule
module memory(clk,re,im,datain, dataout, addr,fflag0,fflag_out,fflag_done,m);
input clk;
input fflag0,fflag_out,fflag_done;
input re,im;
input [0:14] addr;
input signed [0:127] datain;
input signed [0:32767][0:7] m;
output logic [0:1023] dataout;
logic signed [0:32767][0:7] mem;
always_comb begin
for(int i=0;i< 256;i++)
mem[i] = m[i];
if (re==1'b0 && im == 1'b0) begin //write to memory
if(fflag0 == 0 && fflag_out == 0 && fflag_done == 0)begin
for(int i =0;i< 16;i++)begin
mem[addr + i]= datain[i*8 +:8];
end
end
end
else if(re == 1'b0 && im ==1'b1 )begin
for(int i =0;i< 128;i++)begin
dataout[i*8 +: 8] = mem[addr + i];
end
end
else if(re == 1'b1)begin
for(int i =0;i< 16;i++)begin
dataout[i*8 +: 8] = mem[addr + i];
end
end
end
endmodule // memory
