module control(opcode, func, type, ALUCtrl, rs, rt, rd, read_address_1, read_address_2, shamt, imm, branch_yes, write_enable, mem_read, mem_write, mem_to_reg, immediate_value, mul, second_select);
    input [5:0] opcode;
    input [5:0] func;
    input [1:0] type;
    input [4:0] rs; 
    input [4:0] rt;  
    input [4:0] rd; 
    input [4:0] shamt; 
    input [31:0] imm;
//     input fp;
    
    output reg [4:0] ALUCtrl;
    output reg [31:0] read_address_1, read_address_2, immediate_value;
    output reg branch_yes, write_enable, mem_read, mem_write, mem_to_reg, second_select;
    output reg [1:0] mul;
    
    always @ (*) begin
        case(type) 
            0 : begin
                case(func)
                        6'h20: begin                    //  add r0, r1, r2 r0=r1+r2   
                                ALUCtrl <= 5'd2;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end                                                                        
                        6'h22: begin               //d   sub r0, r1, r2 r0=r1-r2  
                                ALUCtrl <= 5'd6;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end                                                            
                        6'h21: begin// addu r0, r1, r2 r0=r1+r2 (unsigned addition, not 2's complement)    
                                ALUCtrl <= 5'd8;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end               
                        6'h23: begin                         //subu r0,r1,r2 r0=r1-r2 (unsigned addition, not 2's complement)   
                                ALUCtrl <= 5'd9;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end                    
                        6'h28: begin // d             mul r0,r1 hi=z[63:32],lo=z[31:0], Z=r0*r1                     
                                ALUCtrl <= 5'd5;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 1;
                        end               
                        6'h24: begin //  and r0,r1,r2 r0= r1 & r2                                                               
                                ALUCtrl <= 5'd0;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end                
                        6'h25: begin     //   or r0,r1,r2 r0= r1 | r2  
                                ALUCtrl <= 5'd1;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end                                                                         
                        6'h26: begin    // xor r0,r1,r2 r0= r1 ^ r2   
                                ALUCtrl <= 5'd4;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end                                                        
                        6'h27: begin //  not r0, r1                                                              
                                ALUCtrl <= 5'd3;
                                read_address_1 <= rs;
                                read_address_2 <= 0;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end               
                        6'h0:  begin //sll r0, r1, 10 r0=r1<<10 (shift left logical)   
                                ALUCtrl <= 5'd13;
                                read_address_1 <= rs;
                                read_address_2 <= 0;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 1;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= {27'b0, shamt};
                                mul <= 0;
                        end           
                        6'h2:  begin // srl r0, r1, 10 r0=r1>>10 (shift right logical)                        
                                ALUCtrl <= 5'd14;
                                read_address_1 <= rs;
                                read_address_2 <= 0;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 1;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= {27'b0, shamt};
                                mul <= 0;
                        end                 
                        6'h3:  begin   //  sra r0, r1, 10 r0=r1>>10 (shift right arithmetic)                     
                                ALUCtrl <= 5'd12;
                                read_address_1 <= rs;
                                read_address_2 <= 0;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 1;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= {27'b0, shamt};
                                mul <= 0;
                        end               

                        6'h4:  begin
                                ALUCtrl <= 5'd15; //  sla r01,, r1, 10 r0=r1<<10 (shift left arithmetic)                       
                                read_address_1 <= rs;
                                read_address_2 <= 0;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 1;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= {27'b0, shamt};
                                mul <= 0;
                        end                
    
                        6'h2A: begin   //slt r0,r1,r2 if(r1<r2) r0=1 else r0=0                                 
                                 ALUCtrl <= 5'd7;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end             
                        6'h2B: begin    //seq r0, r1, r2      
                                 ALUCtrl <= 5'd11;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end     
                        //Floating Point Instructions

                        6'h10: begin    //mfcl r0, f0    
                                 ALUCtrl <= 5'd23;
                                 read_address_1 <= 0;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h11: begin    //mtc1 f0,r0   
                                 ALUCtrl <= 5'd23;
                                 read_address_1 <= 0;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h12: begin    //add.s f0,f1, f2 f0=f1+f2     
                                ALUCtrl <= 5'd23;
                                read_address_1 <= rs;
                                read_address_2 <= rt;
                                branch_yes <= 0;
                                write_enable <= 1;
                                second_select <= 0;
                                mem_read <= 0;
                                mem_write <= 0;
                                mem_to_reg <= 0;
                                immediate_value <= 0;
                                mul <= 0;
                        end      
                        6'h13: begin    //sub.s f0,f1, f2 f0=f1-f2      
                                 ALUCtrl <= 5'd24;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h14: begin    //c.eq.s cc f0, f1  
                                 ALUCtrl <= 5'd25;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h15: begin    //c.le.s cc f0, f1
                                 ALUCtrl <= 5'd26;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h16: begin    //c.lt.s cc f0, f1    
                                 ALUCtrl <= 5'd27;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h17: begin    //c.ge.s cc f0, f1 
                                 ALUCtrl <= 5'd28;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h18: begin    //c.gt.s cc f0, f1   
                                 ALUCtrl <= 5'd29;
                                 read_address_1 <= rs;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      
                        6'h19: begin    //mov.s cc f0, f1
                                 ALUCtrl <= 5'd23;
                                 read_address_1 <= 0;
                                 read_address_2 <= rt;
                                 branch_yes <= 0;
                                 write_enable <= 1;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;
                        end      

                        default: begin          //DO nothing

                                 ALUCtrl <= 5'd30;
                                 read_address_1 <= 0;
                                 read_address_2 <= 0;
                                 branch_yes <= 0;
                                 write_enable <= 0;
                                 second_select <= 0;
                                 mem_read <= 0;
                                 mem_write <= 0;
                                 mem_to_reg <= 0;
                                 immediate_value <= 0;
                                 mul <= 0;

                        end

                endcase 
             end
             
             1 : begin
                case(opcode) 
                    6'h8: begin         //addi r0,r1,1000 r0=r1+1000 
                            ALUCtrl <= 5'd2;
                            read_address_1 <= rs;
                            read_address_2 <= 0;   
                            branch_yes <= 0;      
                            write_enable <= 1; 
                            second_select <= 1;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= imm;
                            mul <= 0;
                    end   
                    
                    6'h9: begin         //addiu r0,r1, 1000 r0=r1+1000 (unsigned additon, not 2's complement) 
                            ALUCtrl <= 5'd8;
                            read_address_1 <= rs;
                            read_address_2 <= 0;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 1;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= imm;
                            mul <= 0;
                    end   
                    
                    6'hC: begin    //andi r0,r1, 1000 r0= r1 & 1000    
                            ALUCtrl <= 5'd0;
                            read_address_1 <= rs;
                            read_address_2 <= 0;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 1;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= imm;
                            mul <= 0;
                    end 
                        
                    6'hD: begin         //ori r0,r1, 1000 r0= r1 | 1000    
                            ALUCtrl <= 5'd1;
                            read_address_1 <= rs;
                            read_address_2 <= 0;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 1;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= imm;
                            mul <= 0;
                    end
                    
                    6'hE: begin                 //xori, r0,r1,1000 r0=r1 xor 1000        
                            ALUCtrl <= 5'd4;
                            read_address_1 <= rs;
                            read_address_2 <= 0;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 1;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= imm;
                            mul <= 0;
                    end  
                    
                    6'hA: begin         //slti r0,r1,100 if(r1<100) r0=1 else r0=0  
                            ALUCtrl <= 5'd7;
                            read_address_1 <= rs;
                            read_address_2 <= 0;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 1;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= imm;
                            mul <= 0;
                    end 
                
                    6'h4: begin //beq r0,r1,10 if(r0==r1) go to PC+4+10 (branch on equal)     
                            ALUCtrl <= 5'd11;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end 
                        
                    6'h5: begin         //bne r0,r1,10 if(r0!=r1) go to PC+4+10 (branch on not equal)    
                            ALUCtrl <= 5'd16;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end
                    
                    6'h12: begin        //bgte r0,r1, 10 if(r0>=r1) go to PC+4+10 (branch if greter than or equal)  
                            ALUCtrl <= 5'd18;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end  
                    
                    6'h13: begin        //ble r0,r1, 10 if(r0<r1) go to PC+4+10 (branch if less than)
                            ALUCtrl <= 5'd7;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end 
                    
                    6'h14: begin        //bleq r0,r1, 10 if(r0<=r1) go to PC+4+10 (branch if less than or equal) 
                            ALUCtrl <= 5'd19;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end

                    6'h15: begin        //bleu r0,r1, 10 unsigned version of ble      
                            ALUCtrl <= 5'd10;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end 
                    
                    6'h16: begin    //bgtu r0,r1, 10 unsigned version of bgt   
                            ALUCtrl <= 5'd17;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end

                    6'h17: begin  //bgt r0,r1,10 if(r0>r1) go to PC+4+10 (branch if greater than)  
                            ALUCtrl <= 5'd20;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 1;
                            write_enable <= 0;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 0;
                    end

                    6'h23: begin         //lw r0,10(r1) r0=Memory[r1+10] (load word)  
                            ALUCtrl <= 5'd2;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 1;
                            mem_read <= 1;
                            mem_write <= 0;
                            mem_to_reg <= 1;
                            immediate_value <= imm;
                            mul <= 0;
                    end 
                    6'h2B: begin          //sw r0,10(r1) Memory[r1+10]=r0 (store word) 
                            ALUCtrl <= 5'd2;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 0;
                            write_enable <= 0;
                            second_select <= 1;
                            mem_read <= 1;
                            mem_write <= 1;
                            mem_to_reg <= 0;
                            immediate_value <= imm;
                            mul <= 0;
                    end 

                    6'hF: begin      //lui r0, 1000 r0[31:16]=1000  
                            ALUCtrl <= 5'd2;
                            read_address_1 <= 0;
                            read_address_2 <= rt;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 1;
                            mem_read <= 1;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= (imm<<16);
                            mul <= 0;
                    end 

                    6'h1C: begin      //madd r0,r1 r0*r1 added with the value in the concatenated registers lo and hi. 
                            ALUCtrl <= 5'd5;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 2;
                    end 

                    6'h1D: begin      //maddu r0,r1 unsigned version of madd    
                            ALUCtrl <= 5'd21;
                            read_address_1 <= rs;
                            read_address_2 <= rt;  
                            branch_yes <= 0;
                            write_enable <= 1;
                            second_select <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                            mul <= 2;
                    end 

                    default: begin
                            ALUCtrl <= 5'd30;
                            read_address_1 <= 0;
                            read_address_2 <= 0;  
                            branch_yes <= 0;
                            write_enable <= 0;
                            mem_read <= 0;
                            mem_write <= 0;
                            mem_to_reg <= 0;
                            immediate_value <= 0;
                    end
                        
                endcase
             
             end   

           2: begin
                ALUCtrl <= 5'd22;
                read_address_1 <= rs;
                read_address_2 <= 0;  
                branch_yes <= 0;
                write_enable <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_to_reg <= 0;
                immediate_value <= 0;

             end
        endcase
    end
       
endmodule