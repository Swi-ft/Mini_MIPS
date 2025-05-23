module mux(a, b, sel, out);
    input [31:0] a,b;
    input [1:0] sel;
    output [31:0] out;

    assign out = sel ? b : a;

endmodule

module mux_3(a, b, c, sel, out);
    input [31:0] a, b, c;
    input [1:0] sel;
    output reg [31:0] out;

    always @ (*) begin
        case (sel) 
            0: out <= a; 
            1: out <= b; 
            2: out <= c; 
        endcase
    end

endmodule

module mux_2(a, b, sel, out);
    input a, b;
    input sel;
    output out;

    assign out = sel ? b : a;

endmodule