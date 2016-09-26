module fetch(clk,fe_mem,instruction1,instruction2,pc,fe_mem_out);
input clk;
input signed [0:32767][0:7] fe_mem;
output logic [0:31] instruction1,instruction2;
output logic [0:14] pc;
output logic [0:32767][0:7] fe_mem_out;
logic unsigned [0:31] fe_instruction1,fe_instruction2;
logic signed [0:14] fe_pc = 0,pc_out;
logic [0:1023] inst_block;
logic [0:255][0:7] cache; //block size is 256 bits
logic [0:7] block_number;
logic [0:6] block_offset;
logic hit,miss,waiting = 0,init = 1,init1;
logic [0:255][0:0] valid;
logic [0:7] block_tag1,block_tag2;
logic unsigned [0:10] fe_instruction_miss = 11'b11111111111;
logic unsigned [0:10] fe_nop_opcode_e = 11'b01000000001;
logic unsigned [0:10] fe_nop_opcode_o = 11'b00000000001;
logic recently_used = 0;
logic even_first,fflag_done_fe,im_6,im_7;
logic [0:14] is_pc;
logic signed [0:6] is_i7o;
logic signed [0:9] is_i10e,is_i10o;
logic signed [0:15] is_i16o;
logic signed [0:17] is_i18o;
logic unsigned [0:6] is_pres_addr_e1,is_pres_addr_e2,is_pres_addr_e3,is_pres_addr_o1,is_pres_addr_o2,is_pres_addr_o3,is_pres_dest_e,is_pres_dest_o;
logic unsigned [0:10] is_op_code_e,is_op_code_o;
logic unsigned [0:2] de_stall_is;
logic unsigned de_stall;
logic [0:32767][0:7] de_mem_out;
logic x = 0,x1;
// logic [0:1] calls = 0,calls1;
decode dut_de(clk,instruction1,instruction2,pc,even_first,fflag_done_fe,is_pc,pc_out,is_i7o,is_i10e,is_i10o,is_i16o,is_i18o,im_6,is_pres_addr_e1,is_pres_addr_e2,is_pres_addr_e3,is_pres_addr_o1,is_pres_addr_o2,is_pres_addr_o3,is_pres_dest_e,is_pres_dest_o,is_op_code_e,is_op_code_o,de_stall_is,de_stall,inst_block,fe_mem_out,de_mem_out);
always_comb begin

if(fflag_done_fe == 0)begin //branch target address is not there
if(waiting == 1 || de_stall == 1 || de_stall_is != 0 || init ==1)
fe_pc = fe_pc;
else if(waiting == 0 && de_stall == 0 && de_stall_is == 0)
if(fe_pc >= 248)
fe_pc = 15'bz;
else
fe_pc = fe_pc + 8;
else fe_pc = fe_pc;
block_number = fe_pc[0:7];
block_offset = fe_pc[8:14];
if(block_number == block_tag1)begin
if(valid[block_tag1 + block_offset] == 1 && valid[block_tag1 + block_offset +4] == 1)begin
hit = 1;miss =0;
for(int i=0;i<4;i++)begin
fe_instruction1[i*8 +: 8] = cache[block_tag1 + block_offset + i];
fe_instruction2[i*8 +: 8] = cache[(block_tag1 + block_offset +4) + i];
end
end
else begin
hit =0;miss =1;
fe_instruction1 = {11'bz,7'bz,7'bz,7'bz};
fe_instruction2 = {11'bz,7'bz,7'bz,7'bz};
end
end
else if(block_number == block_tag2)begin
if(valid[block_tag2 + block_offset] == 1 && valid[block_tag2 + block_offset +4] == 1)begin
hit = 1;miss =0;
for(int i=0;i<4;i++)begin
fe_instruction1[i*8 +: 8] = cache[block_tag2 + block_offset + i];
fe_instruction2[i*8 +: 8] = cache[(block_tag2 + block_offset +4) + i];
end
end
else begin
hit =0;miss =1;
fe_instruction1 = {11'bz,7'bz,7'bz,7'bz};
fe_instruction2 = {11'bz,7'bz,7'bz,7'bz};
end
end
else begin
hit =0;miss=1;
fe_instruction1 = {11'bz,7'bz,7'bz,7'bz};
fe_instruction2 = {11'bz,7'bz,7'bz,7'bz};
end
x1 = x;
end
else if(fflag_done_fe == 1) begin //branch target adress comes
fe_pc = pc_out;
block_number = fe_pc[0:7];

block_offset = fe_pc[8:14];
if((block_number != block_tag1) && (block_number != block_tag2))begin //it is NOT INSIDE cache
hit= 0;miss =1;
fe_instruction1 = {11'bz,7'bz,7'bz,7'bz};
fe_instruction2 = {11'bz,7'bz,7'bz,7'bz};
end
else if(block_number == block_tag1)begin //it is INSIDE cache
if(valid[block_tag1 + block_offset] == 1 && valid[block_tag1 + block_offset + 4] == 1)begin
hit = 1;miss =0;
for(int i=0;i<4;i++)begin
fe_instruction1[i*8 +: 8] = cache[block_tag1 + block_offset + i];
fe_instruction2[i*8 +: 8] = cache[(block_tag1 + block_offset +4) + i];
end
end
else begin
hit=0;miss =1;
fe_instruction1 = {11'bz,7'bz,7'bz,7'bz};
fe_instruction2 = {11'bz,7'bz,7'bz,7'bz};
end
end
else if(block_number == block_tag2)begin //it is INSIDE cache
if(valid[block_tag2 + block_offset] == 1 && valid[block_tag2 + block_offset + 4] == 1)begin
hit = 1;miss =0;
for(int i=0;i<4;i++)begin
fe_instruction1[i*8 +: 8] = cache[block_tag2 + block_offset + i];
fe_instruction2[i*8 +: 8] = cache[(block_tag2 + block_offset +4) + i];
end
end
else begin
hit=0;miss =1;
fe_instruction1 = {11'bz,7'bz,7'bz,7'bz};
fe_instruction2 = {11'bz,7'bz,7'bz,7'bz};
end
end
else begin
hit =0;miss=1;
fe_instruction1 = {11'bz,7'bz,7'bz,7'bz};
fe_instruction2 = {11'bz,7'bz,7'bz,7'bz};
end
end
end
always_comb begin //writing to cache
if(im_6 == 1)begin
if(recently_used == 0)begin
block_tag1 = pc[0:7];
block_tag2 = 8'bx;
for(int i = 0;i<128;i++)begin
cache[block_tag1 + i] = inst_block[i*8 +: 8];
valid[block_tag1 + i] = 1;
end

end
else if(recently_used == 1)begin
block_tag2 = pc[0:7];
block_tag1 = 8'bx;
for(int i = 0;i<128;i++)begin
cache[block_tag2 + i] = inst_block[i*8 +: 8];
valid[block_tag2 + i] = 1;
end
end
end
fe_mem_out = fe_mem;
end
always_ff@(posedge clk) begin
init1 <= init;
im_7 <= im_6;
// calls1 <= calls;
if(init1 == 1)
init = 0;
if(im_6 == 1 || fflag_done_fe == 1)
waiting = 0;
if(im_7 == 1)begin
if(recently_used == 0)
recently_used = 1;
else if(recently_used == 1)
recently_used =0;
end
if(hit == 1 && miss == 0)begin
instruction1 = fe_instruction1;
instruction2 = fe_instruction2;
pc = fe_pc;
end
else if(hit == 0 && miss == 1)begin
if(waiting ==0)begin
// if(calls < 2)begin
instruction1 = {fe_instruction_miss,7'b0,7'b0,7'b0};
instruction2 = {fe_nop_opcode_e,7'b0,7'b0,7'b0};
pc = fe_pc;
waiting = 1;
// calls = calls + 1;
// end
// else begin
// instruction1 = {11'bz,7'bz,7'bz,7'bz};
// instruction2 = {11'bz,7'bz,7'bz,7'bz};
// pc = 15'bz;
// waiting = 0;
// end
end
else if(waiting == 1) begin
// if(calls1 <= 2)begin
instruction1 = {fe_nop_opcode_o,7'b0,7'b0,7'b0};

instruction2 = {fe_nop_opcode_e,7'b0,7'b0,7'b0};
// end
// else begin
// instruction1 = {11'bz,7'bz,7'bz,7'bz};
// instruction2 = {11'bz,7'bz,7'bz,7'bz};
// end
end
end
if(x == 0)
x = 1;
else if(x == 1)
x = 0;
end
endmodule
module final_test();
logic clk;
logic [0:31] instruction1,instruction2;
logic [0:14] pc;
logic unsigned [0:31] testData[0:63];
logic signed [0:32767][0:7] fe_mem,fe_mem_out;
initial clk = 0;
always #5 clk = ~clk; //defining clock signal
fetch dut_fe(clk,fe_mem,instruction1,instruction2,pc,fe_mem_out);
initial $readmemb("Instructions.txt",testData);
initial begin
for (int i=0; i< 64; i++) begin
for(int j = 0;j< 4;j++)
fe_mem[4*i + j] = testData[i][j*8 +:8];
end
#700;
$finish;
end
endmodule
