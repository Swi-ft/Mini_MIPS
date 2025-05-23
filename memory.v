module memory(
    input clk,
    input write_enable,
    input [31:0] read_address,
    input [31:0] write_address,
    input [31:0] data_in,
    output [31:0] data_out
);

    reg [31:0] mem [0:1023];

    always @(posedge clk) begin
        if (write_enable)
            mem[write_address] <= data_in;
    end

    assign data_out = mem[read_address];  // asynchronous read

endmodule


module inst_memory(
    input clk,
    input write_enable,
    input [31:0] read_address,
    input [31:0] write_address,
    input [31:0] data_in,
    output [31:0] data_out
);

    reg [31:0] mem [0:1023];
    reg [31:0] data_read;

    always @(posedge clk) begin
        if (write_enable)
            mem[write_address] <= data_in;

        data_read <= mem[read_address];  // synchronous read
    end

    assign data_out = data_read;

endmodule
