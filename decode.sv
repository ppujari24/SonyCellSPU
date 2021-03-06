`include "issue.sv"
module decode(clk,instruction1,instruction2,pc,even_first,fflag_done_fe,is_pc,pc_out,is_i7o,is_i10e,is_i10o,is_i16o,is_i18o,im_6,is_pres_addr_e1,is_pres_addr_e2,is_pres_addr_e3,is_pres_addr_o1,is_pres_addr_o2,is_pres_addr_o3,is_pres_dest_e,is_pres_dest_o,is_op_code_e,is_op_code_o,de_stall_is,de_stall,inst_block,fe_mem_out,de_mem_out);

input clk;
input unsigned [0:31] instruction1,instruction2;
input [0:14] pc;
input [0:32767][0:7] fe_mem_out;
output logic even_first,fflag_done_fe;
output logic [0:14] is_pc,pc_out;
output logic signed [0:6] is_i7o;
output logic signed [0:9] is_i10e,is_i10o;
output logic signed [0:15] is_i16o;
output logic signed [0:17] is_i18o;
output logic unsigned [0:6] is_pres_addr_e1,is_pres_addr_e2,is_pres_addr_e3,is_pres_addr_o1,is_pres_addr_o2,is_pres_addr_o3,is_pres_dest_e,is_pres_dest_o;
output logic unsigned [0:10] is_op_code_e,is_op_code_o;
output logic unsigned [0:2] de_stall_is ;
output logic unsigned de_stall,im_6;
output logic [0:1023] inst_block;
output logic [0:32767][0:7] de_mem_out;
logic unsigned [0:2] stall_e,stall_o;
logic de_stalle,de_stallo,de_stallww_e,de_stallww_o,de_even_first;
logic unsigned flag_e = 0,flag_o = 0,flag_ww_e = 0,flag_ww_o =0,flag_e1,flag_o1,flag_ww_e1,flag_ww_o1;
logic odd1,even1,odd2,even2;
logic unsigned [0:3] de_4bits1,de_4bits2;
logic unsigned [0:6] de_7bits1,de_7bits2;
logic unsigned [0:7] de_8bits1,de_8bits2;
logic unsigned [0:8] de_9bits1,de_9bits2;
logic unsigned [0:10]de_11bits1,de_11bits2;
logic unsigned [0:6] de_4bits0 = 7'b0000000,de_4bits10 = 7'b1000000;
logic unsigned [0:3] de_7bits0 = 4'b0000;
logic unsigned [0:2] de_8bits0 = 3'b000;
logic unsigned [0:1] de_9bits0 = 2'b00;
logic unsigned [0:31] de_instruction1,de_instruction2;
logic [0:14] de_pc;
logic signed [0:6] de_i7_1,de_i7_2;
logic signed [0:9] de_i10_1,de_i10_2;
logic signed [0:15] de_i16_1,de_i16_2;
logic signed [0:15] de_i18_1,de_i18_2;
logic unsigned [0:6] de_pres_addr_11,de_pres_addr_12,de_pres_addr_13,de_pres_addr_21,de_pres_addr_22,de_pres_addr_23;
logic unsigned [0:6] de_pres_dest_1,de_pres_dest_2;
logic unsigned [0:10] de_op_code_1,de_op_code_2;
logic unsigned [0:10] de_nop_opcode_e = 11'b01000000001;
logic unsigned [0:10] de_nop_opcode_o = 11'b00000000001;
logic [0:32767][0:7] is_mem_out;
logic [0:14] input_pc;
logic signed [0:6] input_i7o;
logic signed [0:9] input_i10e,input_i10o;
logic signed [0:15] input_i16o;
logic signed [0:17] input_i18o;
logic unsigned [0:6] pres_addr_e1,pres_addr_e2,pres_addr_e3,pres_addr_o1,pres_addr_o2,pres_addr_o3,pres_dest_e,pres_dest_o;
logic unsigned [0:10] op_code_e,op_code_o;
logic fflag_done_de,fflag_done_de1;

issue dut_is(clk,even_first,is_pc,pc_out,is_i7o,is_i10e,is_i10o,is_i16o,is_i18o,is_pres_addr_e1,is_pres_addr_e2,is_pres_addr_e3,is_pres_addr_o1,is_pres_addr_o2,is_pres_addr_o3,is_pres_dest_e,is_pres_dest_o,is_op_code_e,is_op_code_o,im_6,input_pc,pres_addr_e1,pres_addr_e2,pres_addr_e3,pres_addr_o1,pres_addr_o2,pres_addr_o3,pres_dest_e,pres_dest_o,input_i7o,input_i10e,input_i10o,input_i16o,input_i18o,op_code_e,op_code_o,stall_e,stall_o,fflag_done_de,fflag_done_fe,inst_block,de_mem_out,is_mem_out);
always_comb begin //for instruction1
if(flag_e == 0 && flag_o == 0 && flag_ww_e == 0 && flag_ww_o == 0)begin
de_instruction1 = instruction1;
de_4bits1 = de_instruction1[0:3];
de_7bits1 = de_instruction1[0:6];
de_8bits1 = de_instruction1[0:7];
de_9bits1 = de_instruction1[0:8];
de_11bits1 = de_instruction1[0:10];
if(de_4bits1 == 4'b1000 ||de_4bits1 == 4'b1110)begin //even
even1 = 1;odd1 = 0;
de_op_code_1 = {de_4bits0,de_4bits1};
de_pres_dest_1 = de_instruction1[4:10];
de_pres_addr_12 = de_instruction1[11:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_addr_13 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
end
else if(de_4bits1 == 4'b1100)begin
even1 = 1;odd1 = 0;
de_op_code_1 = {de_4bits10,de_4bits1};
de_pres_dest_1 = de_instruction1[4:10];
de_pres_addr_12 = de_instruction1[11:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_addr_13 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
end
else if(de_7bits1 == 7'b0100001)begin
odd1 = 1;even1 = 0;
de_op_code_1 = {de_7bits0,de_7bits1};
de_i18_1 = de_instruction1[7:24];
de_pres_dest_1 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_pres_addr_11 = 7'bz;

de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_8bits1 == 8'b00110100)begin
odd1 = 1;even1 = 0;
de_op_code_1 = {de_8bits0,de_8bits1};
de_i10_1 = de_instruction1[8:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_dest_1= de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_8bits1 == 8'b00100100)begin
odd1 = 1;even1 = 0;
de_op_code_1 = {de_8bits0,de_8bits1};
de_i10_1 = de_instruction1[8:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_addr_13 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_12 = 7'bz;
de_pres_dest_1= 7'bz;
end
else if(de_8bits1 == 8'b01111111)begin //halt if equal immediate
odd1 = 1;even1 = 0;
de_op_code_1 = {de_8bits0,de_8bits1};
de_i10_1 = de_instruction1[8:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_dest_1 = 7'bz;
de_i7_1 = 7'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_8bits1 == 8'b00011101 ||de_8bits1 == 8'b00011100 ||de_8bits1 == 8'b00001101 ||de_8bits1 == 8'b00001100||de_8bits1 == 8'b00010101 ||de_8bits1 == 8'b00010100 ||de_8bits1 == 8'b00000101 ||de_8bits1 == 8'b00000100 ||de_8bits1 == 8'b01000101 ||de_8bits1 == 8'b01000100 ||de_8bits1 == 8'b01110100)begin
even1 = 1;odd1 = 0;
de_op_code_1 = {de_8bits0,de_8bits1};
de_i10_1 = de_instruction1[8:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_dest_1 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_9bits1 == 9'b001100001||de_9bits1 == 9'b010000011||de_9bits1 == 9'b010000001)begin
odd1 = 1;even1 = 0;
de_op_code_1 = {de_9bits0,de_9bits1};

de_i16_1 = de_instruction1[9:24];
de_pres_dest_1 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i18_1 = 18'bz;
de_pres_addr_11 = 7'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_9bits1 == 9'b001000001||de_9bits1 == 9'b001000000 ||de_9bits1 == 9'b001000010)begin
odd1 = 1;even1 = 0;
de_op_code_1 = {de_9bits0,de_9bits1};
de_i16_1 = de_instruction1[9:24];
de_pres_addr_13 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i18_1 = 18'bz;
de_pres_addr_11 = 7'bz;
de_pres_addr_12 = 7'bz;
de_pres_dest_1 = 7'bz;
end
else if(de_9bits1 == 9'b001100100 || de_9bits1 == 9'b001100000)begin
odd1 =1;even1 = 0;
de_op_code_1 = {de_9bits0,de_9bits1};
de_i16_1 = de_instruction1[9:24];
de_pres_dest_1 = 7'bz; // RESERVED FIELD
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i18_1 = 18'bz;
de_pres_addr_11 = 7'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_11bits1 == 11'b00000000001) begin //nop load
odd1 = 1;even1 = 0;
de_op_code_1 = de_11bits1;
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_11 = 7'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
de_pres_dest_1 = 7'bz; //RESERVED FIELD
end
else if(de_11bits1 == 11'b01000000001) begin //nop execute
even1 = 1;odd1= 0;
de_op_code_1 = de_11bits1;
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_11 = 7'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
de_pres_dest_1 = 7'bz; //rt is FALSE TARGET
end
else if(de_11bits1 == 11'b11111111111) begin //instruction miss

odd1 = 1;even1 = 0;
de_op_code_1 = de_11bits1;
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_11 = 7'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
de_pres_dest_1 = 7'bz; //RESERVED FIELD
end
else if(de_11bits1 == 11'b01111011000) begin //halt if equal
odd1 = 1;even1 = 0;
de_pres_addr_12 = de_instruction1[11:17];
de_pres_addr_11 = de_instruction1[18:24];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_13 = 7'bz;
de_pres_dest_1 = 7'bz; //rt is FALSE TARGET
end
else if(de_11bits1 == 11'b00111111111 || de_11bits1 == 11'b00111111000)begin
odd1 =1; even1= 0;
de_op_code_1 = de_11bits1;
de_i7_1 = de_instruction1[11:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_dest_1 = de_instruction1[25:31];
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_11bits1 == 11'b01010100101 || de_11bits1 == 11'b01010110100)begin
even1 = 1; odd1=0;
de_op_code_1 = de_11bits1;
de_pres_addr_11 = de_instruction1[18:24];
de_pres_dest_1 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_13 = 7'bz;
end
else if(de_11bits1 == 11'b00111000100 || de_11bits1 == 11'b00111011011 ||de_11bits1 == 11'b00111011000)begin
odd1 =1; even1 = 0;
de_op_code_1 = de_11bits1;
de_pres_addr_12 = de_instruction1[11:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_dest_1 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_13 = 7'bz;

end
else if(de_11bits1 == 11'b00101000100)begin
odd1 =1; even1 = 0;
de_op_code_1 = de_11bits1;
de_pres_addr_12 = de_instruction1[11:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_addr_13 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_dest_1 = 7'bz;
end
else if(de_11bits1 !== 11'bx && de_11bits1 !== 11'bz)begin
even1 = 1;odd1 =0;
de_op_code_1 = de_11bits1;
de_pres_addr_12 = de_instruction1[11:17];
de_pres_addr_11 = de_instruction1[18:24];
de_pres_dest_1 = de_instruction1[25:31];
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_13 = 7'bz;
end
else begin
even1 = 1'bz;odd1 =1'bz;
de_op_code_1 = 11'bz;
de_pres_addr_12 = 7'bz;
de_pres_addr_11 = 7'bz;
de_pres_dest_1 = 7'bz;
de_i7_1 = 7'bz;
de_i10_1 = 10'bz;
de_i16_1 = 16'bz;
de_i18_1 = 18'bz;
de_pres_addr_13 = 7'bz;
end
end
end
always_comb begin //for instruction2
if(flag_e == 0 && flag_o == 0 && flag_ww_e == 0 && flag_ww_o == 0 )begin
de_instruction2 = instruction2;
de_4bits2 = de_instruction2[0:3];
de_7bits2 = de_instruction2[0:6];
de_8bits2 = de_instruction2[0:7];
de_9bits2 = de_instruction2[0:8];
de_11bits2 = de_instruction2[0:10];
if(de_4bits2 == 4'b1000 ||de_4bits2 == 4'b1110)begin //even
even2 = 1;odd2 = 0;

de_op_code_2 = {de_4bits0,de_4bits2};
de_pres_dest_2 = de_instruction2[4:10];
de_pres_addr_22 = de_instruction2[11:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_addr_23 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
end
else if(de_4bits2 == 4'b1100)begin
even2 = 1;odd2 = 0;
de_op_code_2 = {de_4bits10,de_4bits2};
de_pres_dest_2 = de_instruction2[4:10];
de_pres_addr_22 = de_instruction2[11:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_addr_23 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
end
else if(de_7bits2 == 7'b0100001)begin
odd2 = 1;even2 = 0;
de_op_code_2 = {de_7bits0,de_7bits2};
de_i18_2 = de_instruction2[7:24];
de_pres_dest_2 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_pres_addr_21 = 7'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_8bits2 == 8'b00110100)begin
odd2 = 1;even2 = 0;
de_op_code_2 = {de_8bits0,de_8bits2};
de_i10_2 = de_instruction2[8:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_dest_2= de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_8bits2 == 8'b00100100)begin
odd2 = 1;even2 = 0;
de_op_code_2 = {de_8bits0,de_8bits2};
de_i10_2 = de_instruction2[8:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_addr_23= de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_22 = 7'bz;
de_pres_dest_2 = 7'bz;
end
else if(de_8bits2 == 8'b01111111)begin //halt if equal immediate
odd2 = 1;even2 = 0;

de_op_code_2 = {de_8bits0,de_8bits2};
de_i10_2 = de_instruction2[8:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_dest_2 = 7'bz;
de_i7_2 = 7'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_8bits2 == 8'b00011101 ||de_8bits2 == 8'b00011100 ||de_8bits2 == 8'b00001101 ||de_8bits2 == 8'b00001100||de_8bits2 == 8'b00010101 ||de_8bits2 == 8'b00010100 ||de_8bits2 == 8'b00000101 ||de_8bits2 == 8'b00000100 ||de_8bits2 == 8'b01000101 ||de_8bits2 == 8'b01000100 ||de_8bits2 == 8'b01110100)begin
even2 = 1;odd2 = 0;
de_op_code_2 = {de_8bits0,de_8bits2};
de_i10_2 = de_instruction2[8:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_dest_2 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_9bits2 == 9'b001100001||de_9bits2 == 9'b010000011||de_9bits2 == 9'b010000001)begin
odd2 = 1;even2 = 0;
de_op_code_2 = {de_9bits0,de_9bits2};
de_i16_2 = de_instruction2[9:24];
de_pres_dest_2 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i18_2 = 18'bz;
de_pres_addr_21 = 7'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_9bits2 == 9'b001000001||de_9bits2 == 9'b001000010 ||de_9bits2 == 9'b001000000)begin
odd2 = 1;even2 = 0;
de_op_code_2 = {de_9bits0,de_9bits2};
de_i16_2 = de_instruction2[9:24];
de_pres_addr_23 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i18_2 = 18'bz;
de_pres_addr_21 = 7'bz;
de_pres_addr_22 = 7'bz;
de_pres_dest_2 = 7'bz;
end
else if(de_9bits2 == 9'b001100100 || de_9bits2 == 9'b001100000)begin
odd2 =1;even2 = 0;
de_op_code_2 = {de_9bits0,de_9bits2};
de_i16_2 = de_instruction2[9:24];
de_pres_dest_2 = 7'bz; // RESERVED FIELD
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;

de_i18_2 = 18'bz;
de_pres_addr_21 = 7'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_11bits2 == 11'b00000000001) begin //nop load
odd2 = 1;even2 = 0;
de_op_code_2 = de_11bits2;
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_21 = 7'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
de_pres_dest_2 = 7'bz; //RESERVED FIELD
end
else if(de_11bits2 == 11'b01000000001) begin //nop execute
even2 = 1;odd2= 0;
de_op_code_2 = de_11bits2;
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_21 = 7'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
de_pres_dest_2 = 7'bz; //rt is FALSE TARGET
end
else if(de_11bits2 == 11'b11111111111) begin //instruction miss
odd2 = 1;even2 = 0;
de_op_code_2 = de_11bits2;
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_21 = 7'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
de_pres_dest_2 = 7'bz; //RESERVED FIELD
end
else if(de_11bits2 == 11'b01111011000) begin //halt if equal
odd2 = 1;even2 = 0;
de_pres_addr_22 = de_instruction2[11:17];
de_pres_addr_21 = de_instruction2[18:24];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_23 = 7'bz;
de_pres_dest_2 = 7'bz; //rt is FALSE TARGET
end
else if(de_11bits2 == 11'b00111111111 || de_11bits2 == 11'b00111111000)begin
odd2 =1; even2= 0;
de_op_code_2 = de_11bits2;
de_i7_2 = de_instruction2[11:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_dest_2 = de_instruction2[25:31];

de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_11bits2 == 11'b01010100101 || de_11bits2 == 11'b01010110100)begin
even2 = 1; odd2=0;
de_op_code_2 = de_11bits2;
de_pres_addr_21 = de_instruction2[18:24];
de_pres_dest_2 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_11bits2 == 11'b00111000100 || de_11bits2 == 11'b00111011011 ||de_11bits2 == 11'b00111011000)begin
odd2 =1; even2 = 0;
de_op_code_2 = de_11bits2;
de_pres_addr_22 = de_instruction2[11:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_dest_2 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_23 = 7'bz;
end
else if(de_11bits2 == 11'b00101000100)begin
odd2 =1; even2 = 0;
de_op_code_2 = de_11bits2;
de_pres_addr_22 = de_instruction2[11:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_addr_23 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_dest_2 = 7'bz;
end
else if(de_11bits2 !== 11'bx && de_11bits2 !== 11'bz)begin
even2 = 1;odd2 =0;
de_op_code_2 = de_11bits2;
de_pres_addr_22 = de_instruction2[11:17];
de_pres_addr_21 = de_instruction2[18:24];
de_pres_dest_2 = de_instruction2[25:31];
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_23 = 7'bz;
end
else begin
even2 = 1'bz;odd2 =1'bz;
de_op_code_2 = 11'bz;
de_pres_addr_22 = 7'bz;
de_pres_addr_21 = 7'bz;

de_pres_dest_2 = 7'bz;
de_i7_2 = 7'bz;
de_i10_2 = 10'bz;
de_i16_2 = 16'bz;
de_i18_2 = 18'bz;
de_pres_addr_23 = 7'bz;
end
end
end //end of instruction 2
always_comb begin
de_mem_out = fe_mem_out;
if(stall_e >= stall_o)
de_stall_is = stall_e;
else de_stall_is = stall_o;
if(de_stall_is == 0)begin
if(fflag_done_de1 == 1)
de_stallo = 0;
else if(odd1 == 1 && odd2 == 0) //structural hazards
de_stallo = 0;
else if(odd1 ==0 && odd2 == 1)
de_stallo = 0;
else if(odd1 == 1 && odd2 == 1)begin
de_stallo = 1;
if(flag_o1 == 1)
de_stallo = 0;
end
else de_stallo = 0;
if(fflag_done_de1 == 1)
de_stallo = 0;
else if(even1 == 1 && even2 == 0) //structural hazards
de_stalle = 0;
else if(even1 ==0 && even2 == 1)
de_stalle = 0;
else if(even1 == 1 && even2 == 1)begin
de_stalle = 1;
if(flag_e1 == 1)
de_stalle = 0;
end
else de_stalle = 0;
if(fflag_done_de1 == 1)begin
de_stallww_e = 0;de_stallww_o =0;
end
else begin
if(de_stalle == 0 && de_stallo == 0)begin
if(de_pres_dest_1 === 7'bz || de_pres_dest_2 === 7'bz)begin //waw hazard
de_stallww_e = 0;de_stallww_o = 0;
end
else if(de_pres_dest_1 == de_pres_dest_2)begin
if(odd1 == 1 && even1 ==0)begin
de_stallww_o = 1;
if(flag_ww_o1 == 1)
de_stallww_o = 0;
end

else if(even1 ==1 && odd1 == 0)begin
de_stallww_e = 1;
if(flag_ww_e1 == 1)
de_stallww_e = 0;
end
end
else begin
de_stallww_e = 0;de_stallww_o = 0;
end
end
end
end
if(fflag_done_de1 == 1)
de_stall = 0;
else if(de_stallo ==1 || de_stalle == 1) //final decode stall value
de_stall = 1;
else if(de_stallww_e == 1 || de_stallww_o == 1)
de_stall = 1;
else de_stall = 0;
if(odd1 == 1 && odd2 == 0)begin //deciding which came first
de_even_first = 0;
de_pc = pc;
end
else if(odd2 == 1 && odd1 == 0)begin
de_even_first = 1;
de_pc = pc + 4;
end
else if(odd1 ==1 && odd2 == 1 )begin
if(flag_o ==0)begin
de_even_first = 0;
de_pc = pc;
end
else begin
de_even_first = 0;
de_pc = de_pc +4;
end
end
else if(odd1 ==0 && odd2 == 0)
de_even_first = 1;
else de_even_first = 1'bz;
end
always_ff @(posedge clk) begin
flag_e1 <= flag_e;
flag_o1 <= flag_o;
flag_ww_e1 <= flag_ww_e;
flag_ww_o1 <= flag_ww_o;
fflag_done_de1 <= fflag_done_de;
if(fflag_done_de == 1)begin
is_op_code_e <= de_nop_opcode_e;
is_i10e <= 10'bx;
is_pres_addr_e1 <= 7'bx;is_pres_addr_e2 <= 7'bx;is_pres_addr_e3 <= 7'bx;
is_pres_dest_e <= 7'bx;
is_op_code_o <= de_nop_opcode_o;

is_i7o <= 7'bx;
is_i10o <= 10'bx;
is_i16o <= 16'bx;
is_i18o <= 18'bx;
is_pres_addr_o1 <= 7'bx;is_pres_addr_o2 <= 7'bx;is_pres_addr_o3 <= 7'bx;
is_pres_dest_o <= 7'bx;
is_pc <= 15'bx;
even_first <= 1'bx;
end
else begin
if(de_stall_is != 0)begin
is_op_code_e <= de_nop_opcode_e;
is_i10e <= 10'bz;
is_pres_addr_e1 <= 7'bz;is_pres_addr_e2 <= 7'bz;is_pres_addr_e3 <= 7'bz;
is_pres_dest_e <= 7'bz;
is_op_code_o <= de_nop_opcode_o;
is_i7o <= 7'bz;
is_i10o <= 10'bz;
is_i16o <= 16'bz;
is_i18o <= 18'bz;
is_pres_addr_o1 <= 7'bz;is_pres_addr_o2 <= 7'bz;is_pres_addr_o3 <= 7'bz;
is_pres_dest_o <= 7'bz;
is_pc <= 15'bz;
end
else if(de_stall_is == 0)begin //issue has not stalls
if(de_stall == 0)begin
if(de_even_first == 1)begin //even is first
even_first <= de_even_first;
is_pc <= de_pc;
is_op_code_e <= de_op_code_1;
is_i10e <= de_i10_1;
is_pres_addr_e1 <= de_pres_addr_11;is_pres_addr_e2 <= de_pres_addr_12;is_pres_addr_e3 <= de_pres_addr_13;
is_pres_dest_e <=de_pres_dest_1;
is_op_code_o <= de_op_code_2;
is_i7o <= de_i7_2;
is_i10o <= de_i10_2;
is_i16o <= de_i16_2;
is_i18o <= de_i18_2;
is_pres_addr_o1 <= de_pres_addr_21;is_pres_addr_o2 <= de_pres_addr_22;is_pres_addr_o3 <= de_pres_addr_23;
is_pres_dest_o <= de_pres_dest_2;
end
else if(de_even_first == 0)begin //odd is first
even_first <= de_even_first;
is_pc <= de_pc;
is_op_code_e <= de_op_code_2;
is_i10e <= de_i10_2;
is_pres_addr_e1 <= de_pres_addr_21;is_pres_addr_e2 <= de_pres_addr_22;is_pres_addr_e3 <= de_pres_addr_23;
is_pres_dest_e <=de_pres_dest_2;
is_op_code_o <= de_op_code_1;
is_i7o <= de_i7_1;
is_i10o <= de_i10_1;

is_i16o <= de_i16_1;
is_i18o <= de_i18_1;
is_pres_addr_o1 <= de_pres_addr_11;is_pres_addr_o2 <= de_pres_addr_12;is_pres_addr_o3 <= de_pres_addr_13;
is_pres_dest_o <= de_pres_dest_1;
end
else begin
even_first <= 1'bz;
is_pc <= 15'bz;
is_op_code_e <= 11'bz;
is_i10e <= 10'bz;
is_pres_addr_e1 <= 7'bz;is_pres_addr_e2 <= 7'bz;is_pres_addr_e3 <= 7'bz;
is_pres_dest_e <= 7'bz;
is_op_code_o <= 11'bz;
is_i7o <= 7'bz;
is_i10o <= 10'bz;
is_i16o <= 16'bz;
is_i18o <= 18'bz;
is_pres_addr_o1 <= 7'bz;is_pres_addr_o2 <= 7'bz;is_pres_addr_o3 <= 7'bz;
is_pres_dest_o <= 7'bz;
end
end
else begin //structural hazard case
if(de_stalle == 1)begin
if(flag_e ==0)begin
even_first <= de_even_first;
is_op_code_e <= de_op_code_1;
is_i10e <= de_i10_1;
is_pres_addr_e1 <= de_pres_addr_11;is_pres_addr_e2 <= de_pres_addr_12;is_pres_addr_e3 <= de_pres_addr_13;
is_pres_dest_e <=de_pres_dest_1;
is_op_code_o <= de_nop_opcode_o;
is_i7o <= 7'bz;
is_i10o <= 10'bz;
is_i16o <= 16'bz;
is_i18o <= 18'bz;
is_pres_addr_o1 <= 7'bz;is_pres_addr_o2 <= 7'bz;is_pres_addr_o3 <= 7'bz;
is_pres_dest_o <= 7'bz;
is_pc = 15'bz;
flag_e = 1;
end
else if(flag_e == 1)begin
even_first <= de_even_first;
is_op_code_e <= de_op_code_2;
is_i10e <= de_i10_2;
is_pres_addr_e1 <= de_pres_addr_21;is_pres_addr_e2 <= de_pres_addr_22;is_pres_addr_e3 <= de_pres_addr_23;
is_pres_dest_e <=de_pres_dest_2;
is_op_code_o <= de_nop_opcode_o;
is_i7o <= 7'bz;
is_i10o <= 10'bz;
is_i16o <= 16'bz;
is_i18o <= 18'bz;
is_pres_addr_o1 <= 7'bz;is_pres_addr_o2 <= 7'bz;is_pres_addr_o3 <= 7'bz;

is_pres_dest_o <= 7'bz;
is_pc = 15'bz;
flag_e = 0;
end
end
else if(de_stallo == 1)begin
if(flag_o ==0)begin
even_first <= de_even_first;
is_pc = de_pc;
is_op_code_e <= de_nop_opcode_e;
is_i10e <= 10'bz;
is_pres_addr_e1 <= 7'bz ;is_pres_addr_e2 <= 7'bz;is_pres_addr_e3 <= 7'bz ;
is_pres_dest_e <= 7'bz;
is_op_code_o <= de_op_code_1;
is_i7o <= de_i7_1;
is_i10o <= de_i10_1;
is_i16o <= de_i16_1;
is_i18o <= de_i18_1;
is_pres_addr_o1 <= de_pres_addr_11;is_pres_addr_o2 <= de_pres_addr_12;is_pres_addr_o3 <= de_pres_addr_13 ;
is_pres_dest_o <= de_pres_dest_1;
flag_o = 1;
end
else if(flag_o == 1)begin
even_first <= de_even_first;
is_pc = de_pc;
is_op_code_e <= de_nop_opcode_e;
is_i10e <= 10'bz;
is_pres_addr_e1 <= 7'bz ;is_pres_addr_e2 <= 7'bz;is_pres_addr_e3 <= 7'bz ;
is_pres_dest_e <= 7'bz;
is_op_code_o <= de_op_code_2;
is_i7o <= de_i7_2;
is_i10o <= de_i10_2;
is_i16o <= de_i16_2;
is_i18o <= de_i18_2;
is_pres_addr_o1 <= de_pres_addr_21;is_pres_addr_o2 <= de_pres_addr_22;is_pres_addr_o3 <= de_pres_addr_23 ;
is_pres_dest_o <= de_pres_dest_2;
flag_o = 0;
end
end
else if(de_stallww_e == 1)begin //waw hazard case
if(flag_ww_e == 0)begin
even_first <= de_even_first;
is_op_code_e <= de_op_code_1;
is_i10e <= de_i10_1;
is_pres_addr_e1 <= de_pres_addr_11;is_pres_addr_e2 <= de_pres_addr_12;is_pres_addr_e3 <= de_pres_addr_13;
is_pres_dest_e <=de_pres_dest_1;
is_op_code_o <= de_nop_opcode_o;
is_i7o <= 7'bz;
is_i10o <= 10'bz;
is_i16o <= 16'bz;
is_i18o <= 18'bz;

is_pres_addr_o1 <= 7'bz;is_pres_addr_o2 <= 7'bz;is_pres_addr_o3 <= 7'bz;
is_pres_dest_o <= 7'bz;
is_pc <= 15'bz;
flag_ww_e = 1;
end
else if(flag_ww_e == 1)begin
even_first <= de_even_first;
is_pc <= de_pc;
is_op_code_e <= de_nop_opcode_e;
is_i10e <= 10'bz;
is_pres_addr_e1 <= 7'bz;is_pres_addr_e2 <= 7'bz;is_pres_addr_e3 <= 7'bz;
is_pres_dest_e <= 7'bz;
is_op_code_o <= de_op_code_2;
is_i7o <= de_i7_2;
is_i10o <= de_i10_2;
is_i16o <= de_i16_2;
is_i18o <= de_i18_2;
is_pres_addr_o1 <= de_pres_addr_21;is_pres_addr_o2 <= de_pres_addr_22;is_pres_addr_o3 <= de_pres_addr_23;
is_pres_dest_o <= de_pres_dest_2;
flag_ww_e = 0;
end
end
else if(de_stallww_o == 1)begin //odd is first
if(flag_ww_o == 0)begin
even_first <= de_even_first;
is_pc <= de_pc;
is_op_code_e <= de_nop_opcode_e;
is_i10e <= 10'bz;
is_pres_addr_e1 <= 7'bz;is_pres_addr_e2 <= 7'bz;is_pres_addr_e3 <= 7'bz;
is_pres_dest_e <= 7'bz;
is_op_code_o <= de_op_code_1;
is_i7o <= de_i7_1;
is_i10o <= de_i10_1;
is_i16o <= de_i16_1;
is_i18o <= de_i18_1;
is_pres_addr_o1 <= de_pres_addr_11;is_pres_addr_o2 <= de_pres_addr_12;is_pres_addr_o3 <= de_pres_addr_13;
is_pres_dest_o <= de_pres_dest_1;
flag_ww_o = 1;
end
else if(flag_ww_o == 1)begin
even_first <= de_even_first;
is_op_code_e <= de_op_code_2;
is_i10e <= de_i10_2;
is_pres_addr_e1 <= de_pres_addr_21;is_pres_addr_e2 <= de_pres_addr_22;is_pres_addr_e3 <= de_pres_addr_23;
is_pres_dest_e <=de_pres_dest_2;
is_op_code_o <= de_nop_opcode_o;
is_i7o <= 7'bz;
is_i10o <= 10'bz;
is_i16o <= 16'bz;
is_i18o <= 18'bz;

is_pres_addr_o1 <= 7'bz;is_pres_addr_o2 <= 7'bz;is_pres_addr_o3 <= 7'bz;
is_pres_dest_o <= 7'bz;
is_pc <= 15'bz;
flag_ww_o = 0;
end
else even_first <= 1'bz;
end
end
end
end
end
endmodule

