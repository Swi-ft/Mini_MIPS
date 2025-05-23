`include "alu.v"
`include "mux.v"
`include "instruction_decode.v"
`include "register_file.v"
`include "control.v"
`include "memory.v"
`include "pcHandle.v"

module processor_top(clk, rst, inst_data_in, inst_write_addr, mem_data_in, mem_write_addr, processor_out, done);

    input clk, rst;
    input [31:0] inst_data_in, inst_write_addr;
    input [31:0] mem_data_in, mem_write_addr;
    output [31:0] processor_out;
    output reg done;
    
    
    assign processor_out = data_memory_out;

    wire [31:0] data_mem_write, data_mem_addr, data_mem_read_addr;
    wire data_mem_we;

    mux data_memory_write(read_data_2, mem_data_in, {1'b0, rst}, data_mem_write);
    mux data_memory_addr(ALU_out, mem_write_addr, {1'b0, rst}, data_mem_addr);
    
    mux data_memory_read_addr(ALU_out, mem_write_addr, {1'b0, done}, data_mem_read_addr);
    mux_2 data_memory_we(mem_write, rst, rst, data_mem_we);

    //memory(clk, write_enable, read_address, write_address, data_in, data_out);

   memory data_memory(clk, data_mem_we, data_mem_read_addr, data_mem_addr, data_mem_write, data_memory_out);
   memory inst_memory(clk, rst, PC, inst_write_addr, inst_data_in, inst_data_out);
    
    // memory_wrapper data_memory(clk, data_mem_we, data_mem_read_addr, data_mem_addr[8:0], data_mem_write, data_memory_out);
    // memory_wrapper inst_memory(clk, rst, PC, inst_write_addr[8:0], inst_data_in, inst_data_out);

    reg [31:0] PC;
    wire [31:0] instruction = inst_data_out;

    wire [4:0] rs, rt, rd, shamt;
    wire [5:0] opcode, funct;
    wire [31:0] imm;
    wire [25:0] addr;
    wire branch_yes, overflow, ALU_zero, write_enable, mem_read, mem_write, mem_to_reg, second_select, jump, we;
    wire [1:0] type, mul;
    wire [2:0] fp;


    wire [4:0] ALUCtrl;

    wire [31:0] read_address_1, read_address_2, write_address, write_data, immediate_value, write_address_final;

    wire [31:0] ALU_in_1, ALU_in_2, read_data_2, ALU_out, ALU_out_2;

    wire instruction_write_enable;

    wire [31:0] rs_in;

    wire [31:0] instruction_read_address, data_read_address, instruction_write_address, data_write_address, instruction_data_in, data_data_in, instruction_data_out, data_memory_out, reg_file_write_in_1, reg_file_write_in_2;


    
    instruction_decode instruction_decode_dut(instruction, rs, rt, rd, shamt, funct, imm, addr, type, opcode, jump, fp);

    control control_unit(opcode, funct, type, ALUCtrl, rs, rt, rd, read_address_1, read_address_2, shamt, imm, branch_yes, write_enable, mem_read, mem_write, mem_to_reg, immediate_value, mul, second_select);

    mux_3 uut8 ({27'b0, rd}, {27'b0, rt}, 31, type, write_address);


    register_file reg_file(clk, rst, we, read_address_1, read_address_2, write_address, ALU_in_1, read_data_2, rs_in, ALU_out_2, mul, fp);

    mux uut69(reg_file_write_in_1, (PC + 1), {1'b0, jump}, rs_in);

    mux_2  uut70(write_enable, (opcode == 3), jump, we);

    mux uut5(read_data_2, immediate_value, {1'b0, second_select}, ALU_in_2);

    ALU ALU(ALUCtrl, ALU_in_1, ALU_in_2, ALU_out, ALU_out_2, ALU_zero, overflow);

    mux uut6(ALU_out, data_memory_out , {1'b0, mem_to_reg}, reg_file_write_in_1);

    // wire inst_write_enable;
    wire [31:0] inst_read_address, inst_write_address, inst_data_in, inst_data_out;

    // assign inst_write_enable = 0;

    wire [31:0] store;

    pc_increment pci(PC, type, opcode, branch_yes, ALU_zero, imm, addr, ALU_in_1, store);


    always @(posedge clk) begin
        if(rst) begin
            PC <= 0;
            done <= 0;
        end
        else if (done) PC <= PC;
        else if(PC == 89) begin
            done <= 1;  
            PC <= PC;
        end    
        else PC <= store;
    end


    
endmodule