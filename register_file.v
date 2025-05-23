module register_file(clk, rst, write_enable, read_address_1, read_address_2, write_address, read_data_1, read_data_2, write_data_1, write_data_2, mul, fp);
    input clk, rst , write_enable;
    input [2:0] fp;
    input [1:0] mul;
    input [31:0] read_address_1, read_address_2, write_address, write_data_1, write_data_2;
    output [31:0] read_data_1, read_data_2;

    reg [31:0] GPR[63:0];          //1st 32 registers are gpr next 32 are fpr      
    reg [31:0] FPR[63:0];          //1st 32 registers are gpr next 32 are fpr      


    

    always @ (posedge clk) begin
        if(rst) begin
            GPR[0] <= 0;
            // GPR[15] <= 8; 
            // GPR[14] <= 8; 
            GPR[29] <= 200;         //assume stack pointer starts at 500
            // GPR_FPR[31] <= 17;
            FPR[13] <= 32'hc1d9f1aa;
            FPR[14] <= 32'h427d5d2f;

        end
        
        else begin
            if(write_enable) begin
                if(mul == 1) begin
                    {GPR[26], GPR[27]} <=  {write_data_2, write_data_1};
                end    

                else if(mul == 2) begin
                    // {hi, lo} <= {hi, lo} + {write_data_2, write_data_1};
                    {GPR[26], GPR[27]} <= {GPR[26], GPR[27]} + {write_data_2, write_data_1};
                end   
                
                else begin 
                    if(fp[0]) FPR[write_address] <= write_data_1;
                    else GPR[write_address] <= write_data_1;
                end
            end     

        end
    end

    assign read_data_1 = fp[2] ? FPR[read_address_1] : GPR[read_address_1];
    assign read_data_2 = fp[1] ? FPR[read_address_2] : GPR[read_address_2];
    // assign read_data_2 = GPR_FPR[read_address_2];

endmodule
   