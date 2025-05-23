module pc_increment(PC, type, opcode, branch, zero, imm, addr, ALU_in_1, out);

    input [31:0] PC;
    input [1:0] type;
    input [31:0] imm;
    input [25:0] addr;
    input [31:0] ALU_in_1;
    input [5:0] opcode;
    input branch, zero;
    output reg [31:0] out;


    always @(*) begin
        if(type == 2) begin 
            case(opcode)
                2 : out <= addr;                 //j addr
                3 : out <= addr;                 //jal 10
                1 : out <= ALU_in_1;             // jr r0
            endcase
        end
        else begin
            if (branch && !zero) out <= PC + 1 + imm;
            else out <= PC + 1;
        end
    end

endmodule