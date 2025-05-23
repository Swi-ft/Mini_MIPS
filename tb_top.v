module tb_top;
    reg [31:0] instruction;
    reg clk, rst;
    reg [31:0] inst_data_in, inst_addr;
    reg [31:0] mem_data_in, mem_addr;
    wire [31:0] processor_out;
    wire done;
    
    processor_top uut (clk, rst, inst_data_in, inst_addr, mem_data_in, mem_addr, processor_out, done);

    
    initial begin
        clk <= 0;
        forever #10 clk <= ~clk; 
    end


    initial begin
         rst <= 1;

        #20 inst_data_in = 32'h20080064;     inst_addr <= 0;
        #20 inst_data_in = 32'h20090000;     inst_addr <= 1;
        #20 inst_data_in = 32'h200a000a;     inst_addr <= 2;

        //init_loop
        #20 inst_data_in = 32'had000000;     inst_addr <= 3;
        #20 inst_data_in = 32'h21080015;     inst_addr <= 4;
        #20 inst_data_in = 32'h21290001;     inst_addr <= 5;
        #20 inst_data_in = 32'h4d2afffc;     inst_addr <= 6;

        #20 inst_data_in = 32'h20100000;     inst_addr <= 7;
        #20 inst_data_in = 32'h2011000a;     inst_addr <= 8;
        #20 inst_data_in = 32'h20120000;     inst_addr <= 9;

        //dist_loop
        #20 inst_data_in = 32'h4a510018;     inst_addr <= 10;
        #20 inst_data_in = 32'h8e040000;     inst_addr <= 11;

        #20 inst_data_in = 32'h20090000;     inst_addr <= 12;
        #20 inst_data_in = 32'h0004c020;     inst_addr <= 13;
        #20 inst_data_in = 32'h2019000a;     inst_addr <= 14;

        //bucket_calc
        #20 inst_data_in = 32'h4f190003;     inst_addr <= 15;
        #20 inst_data_in = 32'h21290001;     inst_addr <= 16;
        #20 inst_data_in = 32'h2318fff6;     inst_addr <= 17;
        #20 inst_data_in = 32'h0800000f;     inst_addr <= 18;

        //end_bucket_calc
        #20 inst_data_in = 32'h200a0064;     inst_addr <= 19;
        #20 inst_data_in = 32'h20170015;     inst_addr <= 20;            
        #20 inst_data_in = 32'h01370028;     inst_addr <= 21;
        #20 inst_data_in = 32'h236b0000;     inst_addr <= 22;
        #20 inst_data_in = 32'h014b5020;     inst_addr <= 23;
        #20 inst_data_in = 32'h8d4c0000;     inst_addr <= 24;
        #20 inst_data_in = 32'h200d0014;     inst_addr <= 25;
        #20 inst_data_in = 32'h498d0005;     inst_addr <= 26;

        #20 inst_data_in = 32'h214e0001;     inst_addr <= 27;
        #20 inst_data_in = 32'h018e7020;     inst_addr <= 28;
        #20 inst_data_in = 32'hadc40000;     inst_addr <= 29;
        #20 inst_data_in = 32'h218c0001;     inst_addr <= 30;
        #20 inst_data_in = 32'had4c0000;     inst_addr <= 31;

        //skip_element
        #20 inst_data_in = 32'h22100001;     inst_addr <= 32;
        #20 inst_data_in = 32'h22520001;     inst_addr <= 33;
        #20 inst_data_in = 32'h0800000a;     inst_addr <= 34;

        //end_dist
        #20 inst_data_in = 32'h20160064;     inst_addr <= 35;
        #20 inst_data_in = 32'h20180000;     inst_addr <= 36;
        #20 inst_data_in = 32'h2019000a;     inst_addr <= 37;

        //sort_loop
        #20 inst_data_in = 32'h4b190009;     inst_addr <= 38;
        #20 inst_data_in = 32'h8ecb0000;     inst_addr <= 39;
        #20 inst_data_in = 32'h200f0001;     inst_addr <= 40;           
        #20 inst_data_in = 32'h516f0003;     inst_addr <= 41;

        #20 inst_data_in = 32'h22c40001;     inst_addr <= 42;
        #20 inst_data_in = 32'h21650000;     inst_addr <= 43;
        #20 inst_data_in = 32'h0c000045;     inst_addr <= 44;

        //next_bucket
        #20 inst_data_in = 32'h22d60015;     inst_addr <= 45;
        #20 inst_data_in = 32'h23180001;     inst_addr <= 46;
        #20 inst_data_in = 32'h08000026;     inst_addr <= 47;

        //end_sort
        #20 inst_data_in = 32'h20130000;     inst_addr <= 48;
        #20 inst_data_in = 32'h20140000;     inst_addr <= 49;
        #20 inst_data_in = 32'h2015000a;     inst_addr <= 50;

        //concat_loop
        #20 inst_data_in = 32'h4a950024;     inst_addr <= 51;
        #20 inst_data_in = 32'h20080064;     inst_addr <= 52;
        #20 inst_data_in = 32'h02970028;     inst_addr <= 53;     
        #20 inst_data_in = 32'h23690000;     inst_addr <= 54;           
        #20 inst_data_in = 32'h01094020;     inst_addr <= 55;
        #20 inst_data_in = 32'h8d0a0000;     inst_addr <= 56;
        #20 inst_data_in = 32'h100a0009;     inst_addr <= 57;

        #20 inst_data_in = 32'h21080001;     inst_addr <= 58;
        #20 inst_data_in = 32'h200b0000;     inst_addr <= 59;

        //copy_loop
        #20 inst_data_in = 32'h496a0006;     inst_addr <= 60;
        #20 inst_data_in = 32'h010b6020;     inst_addr <= 61;
        #20 inst_data_in = 32'h8d8d0000;     inst_addr <= 62;
        #20 inst_data_in = 32'hae6d0000;     inst_addr <= 63;
        #20 inst_data_in = 32'h22730001;     inst_addr <= 64;
        #20 inst_data_in = 32'h216b0001;     inst_addr <= 65;
        #20 inst_data_in = 32'h0800003c;     inst_addr <= 66;
        //next_concat
        #20 inst_data_in = 32'h22940001;     inst_addr <= 67;
        #20 inst_data_in = 32'h08000033;     inst_addr <= 68;

        //insertion_sort
        #20 inst_data_in = 32'h20080001;     inst_addr <= 69;

        //insertion_loop
        #20 inst_data_in = 32'h49050010;     inst_addr <= 70;
        #20 inst_data_in = 32'h01044820;     inst_addr <= 71;
        #20 inst_data_in = 32'h8d2a0000;     inst_addr <= 72;
        #20 inst_data_in = 32'h210bffff;     inst_addr <= 73;

        //inner_loop
        #20 inst_data_in = 32'h4d600007;     inst_addr <= 74;
        #20 inst_data_in = 32'h01646020;     inst_addr <= 75;
        #20 inst_data_in = 32'h8d8d0000;     inst_addr <= 76;
        #20 inst_data_in = 32'h51aa0004;     inst_addr <= 77;

        #20 inst_data_in = 32'h218e0001;     inst_addr <= 78;
        #20 inst_data_in = 32'hadcd0000;     inst_addr <= 79;
        #20 inst_data_in = 32'h216bffff;     inst_addr <= 80;
        #20 inst_data_in = 32'h0800004a;     inst_addr <= 81;

        //end_inner
        #20 inst_data_in = 32'h216b0001;     inst_addr <= 82;
        #20 inst_data_in = 32'h01646020;     inst_addr <= 83;
        #20 inst_data_in = 32'had8a0000;     inst_addr <= 84;
        #20 inst_data_in = 32'h21080001;     inst_addr <= 85;
        #20 inst_data_in = 32'h08000046;     inst_addr <= 86;

        //end_insertion
        #20 inst_data_in = 32'h07e00000;     inst_addr <= 87;
        #20 inst_data_in = 32'h22d60001;     inst_addr <= 88;


        #20 mem_addr <= 0 ; mem_data_in <= 19; 
        #20 mem_addr <= 1 ; mem_data_in <= 9; 
        #20 mem_addr <= 2 ; mem_data_in <= 61; 
        #20 mem_addr <= 3 ; mem_data_in <= 2; 
        #20 mem_addr <= 4 ; mem_data_in <= 3; 
        #20 mem_addr <= 5 ; mem_data_in <= 43; 
        #20 mem_addr <= 6 ; mem_data_in <= 19; 
        #20 mem_addr <= 7 ; mem_data_in <= 10; 
        #20 mem_addr <= 8 ; mem_data_in <= 5; 
        #20 mem_addr <= 9 ; mem_data_in <= 86; 

        #30;
        rst <= 0;
        
        wait(done);
        
        #10; mem_addr <= 0;
        #30; mem_addr <= 1;
            $display(processor_out);
        #30; mem_addr <= 2;
            $display(processor_out);
        #30; mem_addr <= 3;
            $display(processor_out);
        #30; mem_addr <= 4;
            $display(processor_out);
        #30; mem_addr <= 5;
            $display(processor_out);
        #30; mem_addr <= 6;
            $display(processor_out);
        #30; mem_addr <= 7;
            $display(processor_out);
        #30; mem_addr <= 8;
            $display(processor_out);
        #30; mem_addr <= 9;
            $display(processor_out);
        #30 
            $display(processor_out);

       $finish;
    end

endmodule