`include "register_file.sv"
module issue(clk,even_first,is_pc,pc_out,is_i7o,is_i10e,is_i10o,is_i16o,is_i18o,is_pres_addr_e1,is_pres_addr_e2,is_pres_addr_e3,is_pres_addr_o1,is_pres_addr_o2,is_pres_addr_o3,is_pres_dest_e,is_pres_dest_o,is_op_code_e,is_op_code_o,im_6,input_pc,pres_addr_e1,pres_addr_e2,pres_addr_e3,pres_addr_o1,pres_addr_o2,pres_addr_o3,pres_dest_e,pres_dest_o,input_i7o,input_i10e,input_i10o,input_i16o,input_i18o,op_code_e,op_code_o,stall_e,stall_o,fflag_done_de,fflag_done_fe,inst_block,de_mem_out,is_mem_out);
input clk,even_first;
input [0:14] is_pc;
input [0:32767][0:7] de_mem_out;
input signed [0:6] is_i7o;
input signed [0:9] is_i10e,is_i10o;
input signed [0:15] is_i16o;
input signed [0:17] is_i18o;
input unsigned [0:6] is_pres_addr_e1,is_pres_addr_e2,is_pres_addr_e3,is_pres_addr_o1,is_pres_addr_o2,is_pres_addr_o3,is_pres_dest_e,is_pres_dest_o;
input unsigned [0:10] is_op_code_e,is_op_code_o;
output logic [0:14] input_pc,pc_out;
output logic signed [0:6] input_i7o;
output logic signed [0:9] input_i10e,input_i10o;
output logic signed [0:15] input_i16o;
output logic signed [0:17] input_i18o;
output logic unsigned [0:6] pres_addr_e1,pres_addr_e2,pres_addr_e3,pres_addr_o1,pres_addr_o2,pres_addr_o3,pres_dest_e,pres_dest_o;
output logic unsigned [0:10] op_code_e,op_code_o;
output logic unsigned [0:2] stall_e;
output logic unsigned [0:2] stall_o;
output logic fflag_done_de,fflag_done_fe,im_6;
output logic [0:1023] inst_block;
output logic [0:32767][0:7] is_mem_out;
logic unsigned [0:10] out_opcode_e,out_opcode_o; //input to pipes

logic [0:127] read_e1,read_e2,read_e3,read_o1,read_o2,read_o3; //input to pipes
logic unsigned [0:6] out_pres_dest_e,out_pres_dest_o; //input to pipes
logic [0:6] i7o;
logic [0:9] i10e,i10o;
logic [0:15] i16o;
logic [0:17] i18o;
logic fflag_done_is,fflag_done_is1;
logic unsigned [0:6] out_even_dest,out_odd_dest; //output from writeback
logic unsigned [0:6] reg_dest1_e,reg_dest2_e,reg_dest3_e,reg_dest4_e,reg_dest5_e,reg_dest6_e,reg_dest7_e; //output from even pipe
logic unsigned [0:6] reg_dest1_o,reg_dest2_o,reg_dest3_o,reg_dest4_o,reg_dest5_o,reg_dest6_o,reg_dest7_o; //output from odd pipe
logic unsigned [0:2] l1_e,l2_e,l3_e,l4_e,l5_e,l6_e,l7_e,latency_e; //output from even pipe
logic unsigned [0:2] l1_o,l2_o,l3_o,l4_o,l5_o,l6_o,l7_o,latency_o; //output from odd pipe
logic [0:32767][0:7] rg_mem_out;
logic unsigned [0:2] stall_e1 = 0,stall_e2 =0;
logic unsigned [0:2] stall_e3 = 0;
logic unsigned [0:2] stall_o1 = 0,stall_o2 = 0,stall_o3 =0;
logic unsigned [0:2] max_stall_e,max_stall_o;
logic unsigned [0:10] nop_opcode_e = 11'b01000000001;
logic unsigned [0:10] nop_opcode_o = 11'b00000000001;
logic unsigned [0:10] l_op_code_e,l_op_code_o;
logic [0:14] l_pc;
logic signed [0:6] l_i7o;
logic signed [0:9] l_i10e,l_i10o;
logic signed [0:15] l_i16o;
logic signed [0:17] l_i18o;
logic unsigned [0:6] l_pres_addr_e1,l_pres_addr_e2,l_pres_addr_e3,l_pres_addr_o1,l_pres_addr_o2,l_pres_addr_o3,l_pres_dest_e,l_pres_dest_o;
logic unsigned loop_e = 0,loop_o = 0;
reg_fetch dut_reg(clk,input_pc,pc_out,input_i7o,input_i10e,input_i10o,input_i16o,input_i18o,i7o,i10e,i10o,i16o,i18o,im_6,fflag_done_is,fflag_done_de,fflag_done_fe,read_e1,read_e2,read_e3,read_o1,read_o2,read_o3,pres_addr_e1,pres_addr_e2,pres_addr_e3,pres_addr_o1,pres_addr_o2,pres_addr_o3,pres_dest_e,pres_dest_o,op_code_e,op_code_o,out_opcode_e,out_opcode_o,out_pres_dest_e,out_pres_dest_o,out_even_dest,out_odd_dest,reg_dest1_e,reg_dest2_e,reg_dest3_e,reg_dest4_e,reg_dest5_e,reg_dest6_e,reg_dest7_e,reg_dest1_o,reg_dest2_o,reg_dest3_o,reg_dest4_o,reg_dest5_o,reg_dest6_o,reg_dest7_o,l1_e,l2_e,l3_e,l4_e,l5_e,l6_e,l7_e,latency_e,l1_o,l2_o,l3_o,l4_o,l5_o,l6_o,l7_o,latency_o,inst_block,is_mem_out,rg_mem_out);
always_ff@(posedge clk) begin //for even
fflag_done_is1 <= fflag_done_is;
if(fflag_done_is == 1)begin
input_i10e = 10'bx;
pres_addr_e1 = 7'bx;pres_addr_e2 = 7'bx;pres_addr_e3 = 7'bx;

pres_dest_e = 7'bx;
op_code_e = nop_opcode_e;
end
else if(fflag_done_is == 0)begin
if(stall_e != 0)begin
for(int i = 0;i < stall_e; i++)begin
op_code_e <= nop_opcode_e;
end
loop_e = 1;
input_i10e <= 10'bz;
pres_addr_e1 <= 7'bz;pres_addr_e2 <= 7'bz;pres_addr_e3 <= 7'bz ;
pres_dest_e <= 7'bz;
end
else begin
loop_e = 0;
op_code_e <= l_op_code_e;
input_i10e <= l_i10e;
pres_addr_e1 <= l_pres_addr_e1;pres_addr_e2 <= l_pres_addr_e2;pres_addr_e3 <= l_pres_addr_e3;
pres_dest_e <= l_pres_dest_e;
end
end
end
always_ff@(posedge clk) begin //for odd
if(fflag_done_is == 1)begin
input_pc = 15'bx;
input_i7o = 7'bx;
input_i10o = 10'bx;
input_i16o = 16'bx;
input_i18o = 18'bx;
pres_addr_o1 = 7'bx;pres_addr_o2 = 7'bx;pres_addr_o3 = 7'bx;
pres_dest_o = 7'bx;
op_code_o = nop_opcode_o;
end
else if(fflag_done_is == 0) begin
if(stall_o != 0)begin
for(int i = 0;i < stall_o; i++)begin
op_code_o <= nop_opcode_o;
end
loop_o = 1;
input_pc <= 15'bz;
input_i7o <= 7'bz;
input_i10o <= 10'bz;
input_i16o <= 16'bz;
input_i18o <= 18'bz;
pres_addr_o1 <= 7'bz;pres_addr_o2 <= 7'bz;pres_addr_o3 <= 7'bz ;
pres_dest_o <= 7'bz;
end
else begin
loop_o = 0;
op_code_o <= l_op_code_o;
input_pc <= l_pc;
input_i7o <= l_i7o;
input_i10o <= l_i10o;
input_i16o <= l_i16o;
input_i18o <= l_i18o;

pres_addr_o1 <= l_pres_addr_o1;pres_addr_o2 <= l_pres_addr_o2;pres_addr_o3 <= l_pres_addr_o3;
pres_dest_o <= l_pres_dest_o;
end
end
end
always_comb begin //for even
if(fflag_done_is1 == 1)begin
l_op_code_e = nop_opcode_e;
l_i10e = 10'bx;
l_pres_addr_e1 = 7'bx;l_pres_addr_e2 = 7'bx;l_pres_addr_e3 = 7'bx;
l_pres_dest_e = 7'bx;
end
else begin
if(loop_e == 1)begin
l_op_code_e = l_op_code_e;
l_i10e = l_i10e;
l_pres_addr_e1 = l_pres_addr_e1;l_pres_addr_e2 = l_pres_addr_e2;l_pres_addr_e3 = l_pres_addr_e3;
l_pres_dest_e = l_pres_dest_e;
end
else if(loop_e == 0)begin
l_op_code_e = is_op_code_e;
l_i10e = is_i10e;
l_pres_addr_e1 = is_pres_addr_e1;l_pres_addr_e2 = is_pres_addr_e2;l_pres_addr_e3 = is_pres_addr_e3;
l_pres_dest_e = is_pres_dest_e;
end
end
if(fflag_done_is1 == 1)
stall_e1 = 0;
if(l_pres_addr_e1 == is_pres_dest_o && even_first == 0) //odd is first and even source is odd destn
stall_e1 = 2;
else if(l_pres_addr_e1 == pres_dest_e) //matches with reg_fetch even
stall_e1 = 1;
else if(l_pres_addr_e1 == pres_dest_o)//matches with reg_fetch odd
stall_e1 = 1;
else if(l_pres_addr_e1 == reg_dest1_e)begin //for pres_addr_e1
if(l1_e == 4)
stall_e1 = 2;
else if(l1_e == 6)
stall_e1 = 4;
else if(l1_e == 7)
stall_e1 = 5;
end
else if(l_pres_addr_e1 == reg_dest2_e)begin
if(l2_e == 4)
stall_e1 = 1;
else if(l2_e == 6)
stall_e1 = 3;
else if(l2_e == 7)

stall_e1 = 4;
end
else if(l_pres_addr_e1 == reg_dest3_e)begin
if(l3_e == 6)
stall_e1 = 2;
else if(l3_e == 7)
stall_e1 = 3;
end
else if(l_pres_addr_e1 == reg_dest4_e)begin
if(l4_e == 6)
stall_e1 = 1;
else if(l4_e == 7)
stall_e1 = 2;
end
else if(l_pres_addr_e1 == reg_dest5_e)begin
if(l5_e == 7)
stall_e1 = 1;
end
else if(l_pres_addr_e1 == reg_dest6_e)begin
stall_e1 = 0;
end
else if(l_pres_addr_e1 == reg_dest1_o)begin
if(l1_o == 4)
stall_e1 = 2;
else if(l1_o == 6)
stall_e1 = 4;
end
else if(l_pres_addr_e1 == reg_dest2_o)begin
if(l2_o == 4)
stall_e1 = 1;
else if(l2_o == 6)
stall_e1 = 3;
end
else if(l_pres_addr_e1 == reg_dest3_o)begin
if(l3_o == 6)
stall_e1 = 2;
end
else if(l_pres_addr_e1 == reg_dest4_o)begin
if(l4_o == 6)
stall_e1 = 1;
end
else if(l_pres_addr_e1 == reg_dest5_o)begin
stall_e1 = 0;
end
if(fflag_done_is1 == 1)
stall_e2 = 0;
if(l_pres_addr_e2 == is_pres_dest_o && even_first == 0)
stall_e2 = 2;
else if(l_pres_addr_e2 == pres_dest_e) //matches with reg_fetch even
stall_e2 = 1;
else if(l_pres_addr_e2 == pres_dest_o)//matches with reg_fetch odd
stall_e2 = 1;
else if(l_pres_addr_e2 == reg_dest1_e)begin //for pres_addr_e1
if(l1_e == 4)
stall_e2 = 2;
else if(l1_e == 6)

stall_e2 = 4;
else if(l1_e == 7)
stall_e2 = 5;
end
else if(l_pres_addr_e2 == reg_dest2_e)begin
if(l2_e == 4)
stall_e2 = 1;
else if(l2_e == 6)
stall_e2 = 3;
else if(l2_e == 7)
stall_e2 = 4;
end
else if(l_pres_addr_e2 == reg_dest3_e)begin
if(l3_e == 6)
stall_e2 = 2;
else if(l3_e == 7)
stall_e2 = 3;
end
else if(l_pres_addr_e2 == reg_dest4_e)begin
if(l4_e == 6)
stall_e2 = 1;
else if(l4_e == 7)
stall_e2 = 2;
end
else if(l_pres_addr_e2 == reg_dest5_e)begin
if(l5_e == 7)
stall_e2 = 1;
end
else if(l_pres_addr_e2 == reg_dest6_e)begin
stall_e2 = 0;
end
else if(l_pres_addr_e2 == reg_dest1_o)begin
if(l1_o == 4)
stall_e2 = 2;
else if(l1_o == 6)
stall_e2 = 4;
end
else if(l_pres_addr_e2 == reg_dest2_o)begin
if(l2_o == 4)
stall_e2 = 1;
else if(l2_o == 6)
stall_e2 = 3;
end
else if(l_pres_addr_e2 == reg_dest3_o)begin
if(l3_o == 6)
stall_e2 = 2;
end
else if(l_pres_addr_e2 == reg_dest4_o)begin
if(l4_o == 6)
stall_e2 = 1;
end
else if(l_pres_addr_e2 == reg_dest5_o)begin
stall_e2 = 0;
end
if(fflag_done_is1 == 1)
stall_e3 = 0;
if(l_pres_addr_e3 == is_pres_dest_o && even_first == 0)
stall_e3 = 2;

else if(l_pres_addr_e3 == pres_dest_e) //matches with reg_fetch even
stall_e3 = 1;
else if(l_pres_addr_e3 == pres_dest_o)//matches with reg_fetch odd
stall_e3 = 1;
else if(l_pres_addr_e3 == reg_dest1_e)begin //for pres_addr_e1
if(l1_e == 4)
stall_e3 = 2;
else if(l1_e == 6)
stall_e3 = 4;
else if(l1_e == 7)
stall_e3 = 5;
end
else if(l_pres_addr_e3 == reg_dest2_e)begin
if(l2_e == 4)
stall_e3 = 1;
else if(l2_e == 6)
stall_e3 = 3;
else if(l2_e == 7)
stall_e3 = 4;
end
else if(l_pres_addr_e3 == reg_dest3_e)begin
if(l3_e == 6)
stall_e3 = 2;
else if(l3_e == 7)
stall_e3 = 3;
end
else if(l_pres_addr_e3 == reg_dest4_e)begin
if(l4_e == 6)
stall_e3 = 1;
else if(l4_e == 7)
stall_e3 = 2;
end
else if(l_pres_addr_e3 == reg_dest5_e)begin
if(l5_e == 7)
stall_e3 = 1;
end
else if(l_pres_addr_e3 == reg_dest6_e)begin
stall_e3 = 0;
end
else if(l_pres_addr_e3 == reg_dest1_o)begin
if(l1_o == 4)
stall_e3 = 2;
else if(l1_o == 6)
stall_e3 = 4;
end
else if(l_pres_addr_e3 == reg_dest2_o)begin
if(l2_o == 4)
stall_e3 = 1;
else if(l2_o == 6)
stall_e3 = 3;
end
else if(l_pres_addr_e3 == reg_dest3_o)begin
if(l3_o == 6)
stall_e3 = 2;
end
else if(l_pres_addr_e3 == reg_dest4_o)begin
if(l4_o == 6)
stall_e3 = 1;

end
else if(l_pres_addr_e3 == reg_dest5_o)begin
stall_e3 = 0;
end
if(fflag_done_is1 == 1)
max_stall_e = 0;
else begin
if(stall_e1 >= stall_e2)begin //if stalle1 is greater
max_stall_e = stall_e1;//max_stalle is stalle1
if(max_stall_e >= stall_e3)begin //if maxstalle is greater
max_stall_e = max_stall_e; //stalle is max stalle
end
else max_stall_e = stall_e3; //
end
else begin
max_stall_e = stall_e2;
if(max_stall_e >= stall_e3)
max_stall_e = max_stall_e;
else max_stall_e = stall_e3;
end
end
if(fflag_done_is1 == 1)
stall_e = 0;
else begin
if(even_first ==0)begin //if even is second
if(max_stall_o >= max_stall_e) //odd first and stallo is greater
stall_e = max_stall_o; //even will stall as much as odd
else stall_e = max_stall_e; //else is stallo is lesser , even will stall by stalle
end
else begin //if even is first
stall_e = max_stall_e;
end
end
end
always_comb begin //for odd
is_mem_out = de_mem_out;
if(fflag_done_is1 == 1)begin
l_op_code_o = nop_opcode_o;
l_pc = 15'bx;
l_i7o = 7'bx;
l_i10o = 10'bx;
l_i16o = 16'bx;
l_pres_addr_o1 = 7'bx;l_pres_addr_o2 = 7'bx;l_pres_addr_o3 = 7'bx;
l_pres_dest_o = 7'bx;
end
else begin
if(loop_o == 1)begin

l_op_code_o = l_op_code_o;
l_pc = l_pc;
l_i7o = l_i7o;
l_i10o = l_i10o;
l_i16o = l_i16o;
l_pres_addr_o1 = l_pres_addr_o1;l_pres_addr_o2 = l_pres_addr_o2;l_pres_addr_o3 = l_pres_addr_o3;
l_pres_dest_o = l_pres_dest_o;
end
else if(loop_o == 0)begin
l_op_code_o = is_op_code_o;
l_pc = is_pc;
l_i7o = is_i7o;
l_i10o = is_i10o;
l_i16o = is_i16o;
l_i18o = is_i18o;
l_pres_addr_o1 = is_pres_addr_o1;l_pres_addr_o2 = is_pres_addr_o2;l_pres_addr_o3 = is_pres_addr_o3;
l_pres_dest_o = is_pres_dest_o;
end
end
if(fflag_done_is1 == 1)
stall_o1 = 0;
else if(l_pres_addr_o1 == is_pres_dest_e && even_first == 1)
stall_o1 = 2;
else if(l_pres_addr_o1 == pres_dest_e) //matches with reg_fetch even
stall_o1 = 1;
else if(l_pres_addr_o1 == pres_dest_o)//matches with reg_fetch odd
stall_o1 = 1;
else if(l_pres_addr_o1 == reg_dest1_e)begin //for pres_addr_e1
if(l1_e == 4)
stall_o1 = 2;
else if(l1_e == 6)
stall_o1 = 4;
else if(l1_e == 7)
stall_o1 = 5;
end
else if(l_pres_addr_o1 == reg_dest2_e)begin
if(l2_e == 4)
stall_o1 = 1;
else if(l2_e == 6)
stall_o1 = 3;
else if(l2_e == 7)
stall_o1 = 4;
end
else if(l_pres_addr_o1 == reg_dest3_e)begin
if(l3_e == 6)
stall_o1 = 2;
else if(l3_e == 7)
stall_o1 = 3;
end
else if(l_pres_addr_o1 == reg_dest4_e)begin
if(l4_e == 6)
stall_o1 = 1;
else if(l4_e == 7)
stall_o1 = 2;
end

else if(l_pres_addr_o1 == reg_dest5_e)begin
if(l5_e == 7)
stall_o1 = 1;
end
else if(l_pres_addr_o1 == reg_dest6_e)begin
stall_o1 = 0;
end
else if(l_pres_addr_o1 == reg_dest1_o)begin
if(l1_o == 4)
stall_o1 = 2;
else if(l1_o == 6)
stall_o1 = 4;
end
else if(l_pres_addr_o1 == reg_dest2_o)begin
if(l2_o == 4)
stall_o1 = 1;
else if(l2_o == 6)
stall_o1 = 3;
end
else if(l_pres_addr_o1 == reg_dest3_o)begin
if(l3_o == 6)
stall_o1 = 2;
end
else if(l_pres_addr_o1 == reg_dest4_o)begin
if(l4_o == 6)
stall_o1 = 1;
end
else if(l_pres_addr_o1 == reg_dest5_o)begin
stall_o1 = 0;
end
if(fflag_done_is1 == 1)
stall_o2 = 0;
else if(l_pres_addr_o2 == is_pres_dest_e && even_first == 1)
stall_o2 = 2;
else if(l_pres_addr_o2 == pres_dest_e) //matches with reg_fetch even
stall_o2 = 1;
else if(l_pres_addr_o2 == pres_dest_o)//matches with reg_fetch odd
stall_o2 = 1;
else if(l_pres_addr_o2 == reg_dest1_e)begin //for pres_addr_e1
if(l1_e == 4)
stall_o2 = 2;
else if(l1_e == 6)
stall_o2 = 4;
else if(l1_e == 7)
stall_o2 = 5;
end
else if(l_pres_addr_o2 == reg_dest2_e)begin
if(l2_e == 4)
stall_o2 = 1;
else if(l2_e == 6)
stall_o2 = 3;
else if(l2_e == 7)
stall_o2 = 4;
end
else if(l_pres_addr_o2 == reg_dest3_e)begin
if(l3_e == 6)

stall_o2 = 2;
else if(l3_e == 7)
stall_o2 = 3;
end
else if(l_pres_addr_o2 == reg_dest4_e)begin
if(l4_e == 6)
stall_o2 = 1;
else if(l4_e == 7)
stall_o2 = 2;
end
else if(l_pres_addr_o2 == reg_dest5_e)begin
if(l5_e == 7)
stall_o2 = 1;
end
else if(l_pres_addr_o2 == reg_dest6_e)begin
stall_o2 = 0;
end
else if(l_pres_addr_o2 == reg_dest1_o)begin
if(l1_o == 4)
stall_o2 = 2;
else if(l1_o == 6)
stall_o2 = 4;
end
else if(l_pres_addr_o2 == reg_dest2_o)begin
if(l2_o == 4)
stall_o2 = 1;
else if(l2_o == 6)
stall_o2 = 3;
end
else if(l_pres_addr_o2 == reg_dest3_o)begin
if(l3_o == 6)
stall_o2 = 2;
end
else if(l_pres_addr_o2 == reg_dest4_o)begin
if(l4_o == 6)
stall_o2 = 1;
end
else if(l_pres_addr_o2 == reg_dest5_o)begin
stall_o2 = 0;
end
if(fflag_done_is1 == 1)
stall_o3 = 0;
else if(l_pres_addr_o3 == is_pres_dest_e && even_first == 1) //even is first and odd source is even dest
stall_o3 = 2;
else if(l_pres_addr_o3 == pres_dest_e) //matches with reg_fetch even
stall_o3 = 1;
else if(l_pres_addr_o3 == pres_dest_o)//matches with reg_fetch odd
stall_o3 = 1;
else if(l_pres_addr_o3 == reg_dest1_e)begin //for pres_addr_e1
if(l1_e == 4)
stall_o3 = 2;
else if(l1_e == 6)
stall_o3 = 4;
else if(l1_e == 7)
stall_o3 = 5;

end
else if(l_pres_addr_o3 == reg_dest2_e)begin
if(l2_e == 4)
stall_o3 = 1;
else if(l2_e == 6)
stall_o3 = 3;
else if(l2_e == 7)
stall_o3 = 4;
end
else if(l_pres_addr_o3 == reg_dest3_e)begin
if(l3_e == 6)
stall_o3 = 2;
else if(l3_e == 7)
stall_o3 = 3;
end
else if(l_pres_addr_o3 == reg_dest4_e)begin
if(l4_e == 6)
stall_o3 = 1;
else if(l4_e == 7)
stall_o3 = 2;
end
else if(l_pres_addr_o3 == reg_dest5_e)begin
if(l5_e == 7)
stall_o3 = 1;
end
else if(l_pres_addr_o3 == reg_dest6_e)begin
stall_o3 = 0;
end
else if(l_pres_addr_o3 == reg_dest1_o)begin
if(l1_o == 4)
stall_o3 = 2;
else if(l1_o == 6)
stall_o3 = 4;
end
else if(l_pres_addr_o3 == reg_dest2_o)begin
if(l2_o == 4)
stall_o3 = 1;
else if(l2_o == 6)
stall_o3 = 3;
end
else if(l_pres_addr_o3 == reg_dest3_o)begin
if(l3_o == 6)
stall_o3 = 2;
end
else if(l_pres_addr_o3 == reg_dest4_o)begin
if(l4_o == 6)
stall_o3 = 1;
end
else if(l_pres_addr_o3 == reg_dest5_o)begin
stall_o3 = 0;
end
if(fflag_done_is1 == 1)
max_stall_o = 0;
else begin
if(stall_o1 >= stall_o2)begin //if stalle1 is greater
max_stall_o = stall_o1;//max_stalle is stalle1
if(max_stall_o >= stall_o3)begin //if maxstalle is greater

max_stall_o = max_stall_o; //stalle is max stalle
end
else max_stall_o = stall_o3; //
end
else begin
max_stall_o = stall_o2;
if(max_stall_o >= stall_o3)
max_stall_o = max_stall_o;
else max_stall_o = stall_o3;
end
end
if(fflag_done_is1 == 1)
stall_o = 0;
else begin
if(even_first ==1)begin //if odd is second
if(max_stall_e >= max_stall_o) //even first and stalle is greater
stall_o = max_stall_e; //odd will stall as much as even
else stall_o = max_stall_o; //else is stallo is lesser , even will stall by stalle
end
else begin //if odd is first
stall_o = max_stall_o;
end
end
end
endmodule

