`include "OddPipe.sv"
`include "even_pipe.sv"
module write_back(clk,even_out,odd_out,even_dest,odd_dest,even_wb,odd_wb,out_even_dest,out_odd_dest,reg_wr_e,reg_wr_o,even_reg_wr,odd_reg_wr);
input clk;
input reg_wr_e,reg_wr_o;
input signed [0:127] even_out,odd_out; //output of pipes
input unsigned [0:6] even_dest,odd_dest; //output of pipes
output logic even_reg_wr,odd_reg_wr; //input to reg_fetch
output logic [0:127] even_wb, odd_wb; // input to reg_fetch
output logic [0:6] out_even_dest,out_odd_dest; // input to reg_fetch
always_ff@(posedge clk) begin
even_wb <= even_out;
odd_wb <= odd_out;
out_even_dest <= even_dest;
out_odd_dest <= odd_dest;
even_reg_wr <= reg_wr_e;
odd_reg_wr <= reg_wr_o;
end

endmodule
module reg_fetch(clk,input_pc,pc_out,input_i7o,input_i10e,input_i10o,input_i16o,input_i18o,i7o,i10e,i10o,i16o,i18o,im_6,fflag_done_is,fflag_done_de,fflag_done_fe,read_e1,read_e2,read_e3,read_o1,read_o2,read_o3,pres_addr_e1,pres_addr_e2,pres_addr_e3,pres_addr_o1,pres_addr_o2,pres_addr_o3,pres_dest_e,pres_dest_o,op_code_e,op_code_o,out_opcode_e,out_opcode_o,out_pres_dest_e,out_pres_dest_o,out_even_dest,out_odd_dest,reg_dest1_e,reg_dest2_e,reg_dest3_e,reg_dest4_e,reg_dest5_e,reg_dest6_e,reg_dest7_e,reg_dest1_o,reg_dest2_o,reg_dest3_o,reg_dest4_o,reg_dest5_o,reg_dest6_o,reg_dest7_o,l1_e,l2_e,l3_e,l4_e,l5_e,l6_e,l7_e,latency_e,l1_o,l2_o,l3_o,l4_o,l5_o,l6_o,l7_o,latency_o,inst_block,is_mem_out,rg_mem_out);
input clk;
input [0:14] input_pc;
input signed [0:6] input_i7o;
input signed [0:9] input_i10e,input_i10o;
input signed [0:15] input_i16o;
input signed [0:17] input_i18o;
input unsigned [0:6] pres_addr_e1,pres_addr_e2,pres_addr_e3,pres_addr_o1,pres_addr_o2,pres_addr_o3,pres_dest_e,pres_dest_o;
input unsigned [0:10] op_code_e,op_code_o;
input [0:32767][0:7] is_mem_out;
output logic [0:10] out_opcode_e,out_opcode_o; //input to pipes
output logic [0:127] read_e1,read_e2,read_e3,read_o1,read_o2,read_o3; //input to pipes
output logic [0:6] out_pres_dest_e,out_pres_dest_o; //input to pipes
output logic [0:14] pc_out;
output logic [0:6] i7o;
output logic [0:9] i10e,i10o;
output logic [0:15] i16o;
output logic [0:17] i18o;
output logic fflag_done_is,fflag_done_de,fflag_done_fe,im_6;
output logic unsigned [0:6] out_even_dest,out_odd_dest; //output from write back
output logic [0:6] reg_dest1_e,reg_dest2_e,reg_dest3_e,reg_dest4_e,reg_dest5_e,reg_dest6_e,reg_dest7_e; //output from even pipe
output logic [0:6] reg_dest1_o,reg_dest2_o,reg_dest3_o,reg_dest4_o,reg_dest5_o,reg_dest6_o,reg_dest7_o; //output from odd pipe
output logic [0:2] l1_e,l2_e,l3_e,l4_e,l5_e,l6_e,l7_e,latency_e; //output from even pipe
output logic [0:2] l1_o,l2_o,l3_o,l4_o,l5_o,l6_o,l7_o,latency_o; //output from odd pipe
output logic [0:1023] inst_block;
output logic [0:32767][0:7] rg_mem_out;
logic flush3,flush4,fflag_out,fflag_regfetch; //output from odd pipe
logic reg_wr,r_wr; //output from pipes
logic [0:127] rt_e,rt_o; //input to write back from pipes
logic [0:6] out_reg_dest_e,out_reg_dest_o;//input to write back from pipes
logic signed [0:127] even_wb,odd_wb; //output from write_back
logic [0:127] re_1,re_2,re_3; //logic values for read_e1,read_e2,read_e3
logic [0:127] ro_1,ro_2,ro_3; //logic values for read_o1,read_o2,read_o3

logic signed [0:127] r_temp1e,r_temp2e,r_temp3e,r_temp4e,r_temp5e,r_temp6e,r_temp7e; //output from even pipe
logic signed [0:127] r_temp1o,r_temp2o,r_temp3o,r_temp4o,r_temp5o,r_temp6o,r_temp7o; //output from odd pipe
logic [0:14] ipc; //input to pipe and output from pipe
logic even_reg_wr,odd_reg_wr; //output from write back
logic unsigned [0:10] reg_nop_opcode_e = 11'b01000000001;
logic unsigned [0:10] reg_nop_opcode_o = 11'b00000000001;
logic [0:6] i7;
logic [0:7] i8;
logic [0:15] i16;
logic unsigned [0:2] unit_id,Unit_ID;
logic signed [0:127][0:127] reg_file;
write_back dut_wb(clk,rt_e,rt_o,out_reg_dest_e,out_reg_dest_o,even_wb,odd_wb,out_even_dest,out_odd_dest,reg_wr,r_wr,even_reg_wr,odd_reg_wr);
even_pipe dut_even(clk,read_e1,read_e2,read_e3,out_opcode_e,i7,i8,i10e,i16,rt_e,unit_id,reg_wr,latency_e,l7_e,flush3,flush4,out_pres_dest_e,out_reg_dest_e,reg_dest1_e,reg_dest2_e,reg_dest3_e,reg_dest4_e,reg_dest5_e,reg_dest6_e,reg_dest7_e,l1_e,l2_e,l3_e,l4_e,l5_e,l6_e,r_temp1e,r_temp2e,r_temp3e,r_temp4e,r_temp5e,r_temp6e,r_temp7e);
oddPipe dut_odd(clk,read_o1,read_o2,read_o3,out_opcode_o,i18o,i10o,i16o,i7o,ipc,rt_o,pc_out,Unit_ID,r_wr,im_6,latency_o,fflag_out,flush3,flush4,fflag_regfetch,fflag_done_is,fflag_done_de,fflag_done_fe,out_pres_dest_o,out_reg_dest_o,reg_dest1_o,reg_dest2_o,reg_dest3_o,reg_dest4_o,reg_dest5_o,reg_dest6_o,reg_dest7_o,l1_o,l2_o,l3_o,l4_o,l5_o,l6_o,l7_o,r_temp1o,r_temp2o,r_temp3o,r_temp4o,r_temp5o,r_temp6o,r_temp7o,inst_block,rg_mem_out);
always_comb begin //for re_1
if(pres_addr_e1 == reg_dest2_e && l2_e == 2)
re_1 = r_temp2e;
else if(pres_addr_e1 == reg_dest3_e && l3_e == 2)
re_1 = r_temp3e;
else if((pres_addr_e1 == reg_dest4_e) && (l4_e == 2 || l4_e == 4))
re_1 = r_temp4e;
else if((pres_addr_e1 == reg_dest5_e) && (l5_e == 2 || l5_e == 4))
re_1 = r_temp5e;
else if((pres_addr_e1 == reg_dest6_e) && (l6_e == 2 || l6_e == 4 || l6_e == 6))
re_1 = r_temp6e;
else if((pres_addr_e1 == reg_dest7_e) && (l7_e == 2 || l7_e == 4 || l7_e == 7))
re_1 = r_temp7e;
else if(pres_addr_e1 == out_even_dest)
re_1 = reg_file[out_even_dest];
else if(pres_addr_e1 == reg_dest4_o && l4_o == 4)
re_1 = r_temp4o;
else if(pres_addr_e1 == reg_dest5_o && l5_o == 4)
re_1 = r_temp5o;
else if((pres_addr_e1 == reg_dest6_o) && (l6_o == 4 || l6_o == 6))

re_1 = r_temp6o;
else if((pres_addr_e1 == reg_dest7_o) && (l7_o == 4 || l7_o == 6))
re_1 = r_temp7o;
else if(pres_addr_e1 == out_odd_dest)
re_1 = reg_file[out_odd_dest];
else re_1 = reg_file[pres_addr_e1];
end
always_comb begin //for re_2
if(pres_addr_e2 == reg_dest2_e && l2_e == 2)
re_2 = r_temp2e;
else if(pres_addr_e2 == reg_dest3_e && l3_e == 2)
re_2 = r_temp3e;
else if((pres_addr_e2 == reg_dest4_e) && (l4_e == 2 || l4_e == 4))
re_2 = r_temp4e;
else if((pres_addr_e2 == reg_dest5_e) && (l5_e == 2 || l5_e == 4))
re_2 = r_temp5e;
else if((pres_addr_e2 == reg_dest6_e) && (l6_e == 2 || l6_e == 4 || l6_e == 6))
re_2 = r_temp6e;
else if((pres_addr_e2 == reg_dest7_e) && (l7_e == 2 || l7_e == 4 || l7_e == 7))
re_2 = r_temp7e;
else if(pres_addr_e2 == out_even_dest)
re_2 = reg_file[out_even_dest];
else if(pres_addr_e2 == reg_dest4_o && l4_o == 4)
re_2 = r_temp4o;
else if(pres_addr_e2 == reg_dest5_o && l5_o == 4)
re_2 = r_temp5o;
else if((pres_addr_e2 == reg_dest6_o) && (l6_o == 4 || l6_o == 6))
re_2 = r_temp6o;
else if((pres_addr_e2 == reg_dest7_o) && (l7_o == 4 || l7_o == 6))
re_2 = r_temp7o;
else if(pres_addr_e2 == out_odd_dest)
re_2 = reg_file[out_odd_dest];
else re_2 = reg_file[pres_addr_e2];
end
always_comb begin //for re_3
if(pres_addr_e3 == reg_dest2_e && l2_e == 2)
re_3 = r_temp2e;
else if(pres_addr_e3 == reg_dest3_e && l3_e == 2)
re_3 = r_temp3e;
else if((pres_addr_e3 == reg_dest4_e) && (l4_e == 2 || l4_e == 4))
re_3 = r_temp4e;
else if((pres_addr_e3 == reg_dest5_e) && (l5_e == 2 || l5_e == 4))
re_3 = r_temp5e;
else if((pres_addr_e3 == reg_dest6_e) && (l6_e == 2 || l6_e == 4 || l6_e == 6))
re_3 = r_temp6e;

else if((pres_addr_e3 == reg_dest7_e) && (l7_e == 2 || l7_e == 4 || l7_e == 7))
re_3 = r_temp7e;
else if(pres_addr_e3 == out_even_dest)
re_3 = reg_file[out_even_dest];
else if(pres_addr_e3 == reg_dest4_o && l4_o == 4)
re_3 = r_temp4o;
else if(pres_addr_e3 == reg_dest5_o && l5_o == 4)
re_3 = r_temp5o;
else if((pres_addr_e3 == reg_dest6_o) && (l6_o == 4 || l6_o == 6))
re_3 = r_temp6o;
else if((pres_addr_e3 == reg_dest7_o) && (l7_o == 4 || l7_o == 6))
re_3 = r_temp7o;
else if(pres_addr_e3 == out_odd_dest)
re_3 = reg_file[out_odd_dest];
else re_3 = reg_file[pres_addr_e3];
end
always_comb begin //for ro_1
if(pres_addr_o1 == reg_dest2_e && l2_e == 2)
ro_1 = r_temp2e;
else if(pres_addr_o1 == reg_dest3_e && l3_e == 2)
ro_1 = r_temp3e;
else if((pres_addr_o1 == reg_dest4_e) && (l4_e == 2 || l4_e == 4))
ro_1 = r_temp4e;
else if((pres_addr_o1 == reg_dest5_e) && (l5_e == 2 || l5_e == 4))
ro_1 = r_temp5e;
else if((pres_addr_o1 == reg_dest6_e) && (l6_e == 2 || l6_e == 4 || l6_e == 6))
ro_1 = r_temp6e;
else if((pres_addr_o1 == reg_dest7_e) && (l7_e == 2 || l7_e == 4 || l7_e == 7))
ro_1 = r_temp7e;
else if(pres_addr_o1 == out_even_dest)
ro_1 = reg_file[out_even_dest];
else if(pres_addr_o1 == reg_dest4_o && l4_o == 4)
ro_1 = r_temp4o;
else if(pres_addr_o1 == reg_dest5_o && l5_o == 4)
ro_1 = r_temp5o;
else if((pres_addr_o1 == reg_dest6_o) && (l6_o == 4 || l6_o == 6))
ro_1 = r_temp6o;
else if((pres_addr_o1 == reg_dest7_o) && (l7_o == 4 || l7_o == 6))
ro_1 = r_temp7o;
else if(pres_addr_o1 == out_odd_dest)
ro_1 = reg_file[out_odd_dest];
else ro_1 = reg_file[pres_addr_o1];
end
always_comb begin //for ro_2
if(pres_addr_o2 == reg_dest2_e && l2_e == 2)

ro_2 = r_temp2e;
else if(pres_addr_o2 == reg_dest3_e && l3_e == 2)
ro_2 = r_temp3e;
else if((pres_addr_o2 == reg_dest4_e) && (l4_e == 2 || l4_e == 4))
ro_2 = r_temp4e;
else if((pres_addr_o2 == reg_dest5_e) && (l5_e == 2 || l5_e == 4))
ro_2 = r_temp5e;
else if((pres_addr_o2 == reg_dest6_e) && (l6_e == 2 || l6_e == 4 || l6_e == 6))
ro_2 = r_temp6e;
else if((pres_addr_o2 == reg_dest7_e) && (l7_e == 2 || l7_e == 4 || l7_e == 7))
ro_2 = r_temp7e;
else if(pres_addr_o2 == out_even_dest)
ro_2 = reg_file[out_even_dest];
else if(pres_addr_o2 == reg_dest4_o && l4_o == 4)
ro_2 = r_temp4o;
else if(pres_addr_o2 == reg_dest5_o && l5_o == 4)
ro_2 = r_temp5o;
else if((pres_addr_o2 == reg_dest6_o) && (l6_o == 4 || l6_o == 6))
ro_2 = r_temp6o;
else if((pres_addr_o2 == reg_dest7_o) && (l7_o == 4 || l7_o == 6))
ro_2 = r_temp7o;
else if(pres_addr_o2 == out_odd_dest)
ro_2 = reg_file[out_odd_dest];
else ro_2 = reg_file[pres_addr_o2];
end
always_comb begin //for ro_3
if(pres_addr_o3 == reg_dest2_e && l2_e == 2)
ro_3 = r_temp2e;
else if(pres_addr_o3 == reg_dest3_e && l3_e == 2)
ro_3 = r_temp3e;
else if((pres_addr_o3 == reg_dest4_e) && (l4_e == 2 || l4_e == 4))
ro_3 = r_temp4e;
else if((pres_addr_o3 == reg_dest5_e) && (l5_e == 2 || l5_e == 4))
ro_3 = r_temp5e;
else if((pres_addr_o3 == reg_dest6_e) && (l6_e == 2 || l6_e == 4 || l6_e == 6))
ro_3 = r_temp6e;
else if((pres_addr_o3 == reg_dest7_e) && (l7_e == 2 || l7_e == 4 || l7_e == 7))
ro_3 = r_temp7e;
else if(pres_addr_o3 == out_even_dest)
ro_3 = reg_file[out_even_dest];
else if(pres_addr_o3 == reg_dest4_o && l4_o == 4)
ro_3 = r_temp4o;
else if(pres_addr_o3 == reg_dest5_o && l5_o == 4)
ro_3 = r_temp5o;
else if((pres_addr_o3 == reg_dest6_o) && (l6_o == 4 || l6_o == 6))
ro_3 = r_temp6o;

else if((pres_addr_o3 == reg_dest7_o) && (l7_o == 4 || l7_o == 6))
ro_3 = r_temp7o;
else if(pres_addr_o3 == out_odd_dest)
ro_3 = reg_file[out_odd_dest];
else ro_3 = reg_file[pres_addr_o3];
end
always_ff @(posedge clk) begin
if(fflag_regfetch == 0)begin
i10e <= input_i10e;
i10o <= input_i10o;
i7o <= input_i7o;
i16o <= input_i16o;
i18o <= input_i18o;
ipc <= input_pc; //to propagate pc by 1 cycle
out_pres_dest_e <= pres_dest_e; //to propagate reg_dest by 1 cycle
out_pres_dest_o <= pres_dest_o;
out_opcode_e <= op_code_e; // to propagate opcode by 1 cycle
out_opcode_o <= op_code_o;
read_e1 <= re_1;read_e2 <= re_2;read_e3 <= re_3; //read ports for even pipe
read_o1 <= ro_1;read_o2 <= ro_2;read_o3 <= ro_3; //read ports for odd pipe
end
else if(fflag_regfetch == 1)begin
i10e <= 10'bx;
i10o <= 10'bx;
i7o <= 7'bx;
i16o <= 16'bx;
i18o <= 18'bx;
ipc <= 15'bx;
out_pres_dest_e <= 7'bx;
out_pres_dest_o <= 7'bx;
out_opcode_e <= reg_nop_opcode_e;
out_opcode_o <= reg_nop_opcode_o;
read_e1 <= 128'bx;read_e2 <= 128'bx;read_e3 <= 128'bx; //read ports for even pipe
read_o1 <= 128'bx;read_o2 <= 128'bx;read_o3 <= 128'bx; //read ports for odd pipe
end
end
always_comb begin
rg_mem_out = is_mem_out;
reg_file[1] = 20000; reg_file[2] = 40000;
reg_file[3] = 128'h00000000000000000000000000000011;

reg_file[4] = 20000;
reg_file[5] = 128'h0000000000000011 ;reg_file[6] = 7;
reg_file[7] = 5000000;reg_file[8] = 9000000 ;
reg_file[9] = 15000;reg_file[10] = 60000;
reg_file[11] = 2;
reg_file[12] = 128'hffffffffffffffffffffffffffffffff;reg_file[13]= 128'hffffffffffffffffffffffffffffffff;
reg_file[14] = 100;reg_file[15] = 128'h00000000ffffffffffffffffffffffff;
reg_file[16] = 0;
reg_file[17] = 262143;
reg_file[18] = 128'hffffffff0000000000000000ffffffff;reg_file[19] = 128'hffffffff000000000000000000000000;
reg_file[20] = 200;reg_file[21] =128'h0000011000000000ffffffff00000000 ;
reg_file[22] = 300;
reg_file[23] = 15;reg_file[24] = 50;
reg_file[25] = 65535;
reg_file[26] = 128'd8589934591;reg_file[27] = 1;
reg_file[28] = 128'h40200000000000000000000040200000; reg_file[29] = 128'h40866666000000000000000040866666;
reg_file[30] = 128'hefffffff0000000000000000efffffff;reg_file[31] = 128'hefffffff000000000000000040866666;
reg_file[32] = 128'h40000000000000000000000040000000;
reg_file[33] = 128'hfffffffffffffffffffffffffffffffa;
reg_file[34] = 255;
reg_file[37] = 128'hffffffff000000000000000000000000;
if(even_reg_wr == 1)
reg_file[out_even_dest] <= even_wb; //write port for even
if(odd_reg_wr == 1)
reg_file[out_odd_dest] <= odd_wb; //write port for odd
end
endmodule
