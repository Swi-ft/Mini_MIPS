`include "fp_operation.v"

module opSelect(B, ctrl, B_out);
   input [31:0] B;
   input [4:0] ctrl;

   output reg [31:0] B_out;

   always @ (*) begin
      if(ctrl == 24) B_out <= {~B[31], B[30:0]}; 
      else B_out <= B;

   end

endmodule

module ALU(ALUCtrl, A, B, out, out_high, zero, overflow);
    input [4:0] ALUCtrl;
    input [31:0] A, B;
    output reg [31:0] out;
    output reg  [31:0] out_high;
    output zero;
    output reg overflow;
    
    
    reg [63:0] product;
    wire [31:0] B_out;

    wire[31:0] adder_out;

    wire eq, lt, gt, ge, le;

    fp_comparator comp(A, B, eq, lt, gt, le, ge);

    opSelect op(B, ALUCtrl, B_out);

       
    fp_adder adder(A, B_out, adder_out);
    

    assign zero = out ? 0 : 1;


    always @(*) begin
        case(ALUCtrl) 
             0 : begin 
                    out <= A & B;          // AND
                    out_high <= 0; 
                    overflow <= 0;
                end

             1 : begin
                    out <= A | B;          // OR
                    out_high <= 0; 
                    overflow <= 0;
                    
                end
             
             2 : begin                  //ADD
                out = A + B;
                if((A[31] == B[31]) && (out[31] != A[31])) overflow <=1;
                else overflow <=0;
                out_high <= 0;
             end
             
             3 : begin
                    out <= ~A;             //NOT
                    out_high <= 0;
                    overflow <= 0;
                end
             4 : begin
                    out <= A ^ B;          //XOR
                    out_high <= 0;
                    overflow <= 0;
                end
             
             5 : begin                  //MUL
                product = ($signed(A) * $signed(B));
                out <= product[31:0];
                out_high <= product[63:32];
                overflow <= 0;
             end
             
             6 : begin
                out = A - B;          // SUB
                if((A[31] != B[31]) && (out[31] != A[31])) overflow <=1;
                else overflow <= 0;
                out_high <= 0;
             end
             
             7 : begin
                  out <= ($signed(A) < $signed(B));  //SLT
                  out_high <= 0;
                  overflow <= 0;
                end
             8 : begin
                  out <= A + B;          // ADDU
                  out_high <= 0;
                  overflow <= 0;
                end
             9 : begin
                    out <= A - B;          //SUBU
                    out_high <= 0;
                    overflow <= 0;
                end
                
             10 : begin
                     out <= A < B ? 1 : 0;   //SLTU
                    out_high <= 0;    
                    overflow <= 0;
                end
                
             11 : begin
                    out <= (A == B);      // SEQ
                    out_high <= 0;
                    overflow <= 0;
                end    
            
             12 : begin
                    out <= (A >>> B);      // SRA
                    out_high <= 0;
                    overflow <= 0;
                end
                
             13 : begin
                     // $display(A, B);
                    out <= (A << B);        //SLL
                    out_high <= 0;
                    overflow <= 0;
                end
                
             14 : begin
                    out <= (A >> B);        //SRL
                    out_high <= 0;
                    overflow <= 0;
                end
                
             15 : begin
                    out <= (A <<< B);        //SLA
                    out_high <= 0;
                    overflow <= 0;
                end

             16 : begin
                    out <= (A != B);        //SNE
                    out_high <= 0;
                    overflow <= 0;
                end

             17 : begin
                  out <= A > B ? 1 : 0;  //SGTU
                  out_high <= 0;
                  overflow <= 0;
                end    

             18 : begin
                  out <= ($signed(A) >= $signed(B))  ? 1 : 0;  //SGTE
                  out_high <= 0;
                  overflow <= 0;
                end

             19 : begin
                  out <= ($signed(A) <= $signed(B)) ? 1 : 0;  //SLTE
                  out_high <= 0;
                  overflow <= 0;
                end    

             20 : begin
                  out <= ($signed(A) > $signed(B));         //SGT
                  out_high <= 0;
                  overflow <= 0;
                end    

             21 : begin                                     //MULU
                  product = (A * B);
                  out <= product[31:0];
                  out_high <= product[63:32];
                  overflow <= 0;
                end 

             22 : begin              //Buffer
                  out <= A;
                  out_high <= 0;
                  overflow <= 0;
                end 

            23: begin                  //add.s
                  out <= adder_out;
                  out_high <= 0;
                  overflow <= 0;
            end
            
            24: begin            //sub.s
                  out <= adder_out;
                  out_high <= 0;
                  overflow <= 0;
            end

            25: begin            //cc.eq
                  out <= eq;
                  out_high <= 0;
                  overflow <= 0;
            end


            26: begin         //cc.le
                  out <= le;
                  out_high <= 0;
                  overflow <= 0;
            end

            27: begin         //cc.lt
                  out <= lt;
                  out_high <= 0;
                  overflow <= 0;
            end


            28: begin         //cc.ge  
                  out <= ge;
                  out_high <= 0;
                  overflow <= 0;
            end


            29: begin         //cc.le
                  out <= gt;
                  out_high <= 0;
                  overflow <= 0;
            end
                    
             default : begin
                  out <= 0;
                  out_high <= 0;
                  overflow <= 0;
                end    
        endcase
    end

endmodule