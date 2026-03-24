module DATA_MEMORY(
    input clk,
    input mem_write,           // Store (sw) 
    input mem_read,            // Load (lw) 
    input [31:0] addr,         // ALU Result
    input [31:0] write_data,    // rs2 Register value
    output [31:0] read_data    // Read data from RAM
    );

    // 64 memory locations of 32-bits RAM 
    reg [31:0] ram [0:63];

    // Read
    assign read_data = (mem_read) ? ram[addr[7:2]] : 32'b0;

    // Write
    always @(posedge clk) begin
        if (mem_write) begin
            ram[addr[7:2]] <= write_data;
        end
    end
endmodule