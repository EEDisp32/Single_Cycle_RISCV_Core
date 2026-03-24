module REGISTER_FILE(
    input clk,
    input rst,
    input reg_write,          // Register Write Signal
    input [4:0] rs1_addr,     // First Input Register address
    input [4:0] rs2_addr,     // Second Input Register address
    input [4:0] rd_addr,      // Destination Register address
    input [31:0] write_data,  // Write Data
    output [31:0] rs1_data,   // First Input Register Value
    output [31:0] rs2_data    // Second Input Register Value
    );

    // 32 memory locations of 32-bits Registers
    reg [31:0] registers [31:0];

    // Reading
    // Return x0 = 0 always
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];
    
    // Writing
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset 
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (reg_write && rd_addr != 5'b0) begin
            registers[rd_addr] <= write_data;
        end
    end

endmodule