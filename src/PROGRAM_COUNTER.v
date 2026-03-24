module PROGRAM_COUNTER(
    input clk,
    input rst,
    input Branch,           
    input zero_flag,        
    input [31:0] alu_result,
    input [2:0] funct3,     
    input [31:0] imm_out,   
    output reg [31:0] pc_out
);

    wire [31:0] pc_next;
    reg take_branch;

    always @(*) begin
        case(funct3)
            3'b000: take_branch = Branch & zero_flag;      // BEQ
            3'b001: take_branch = Branch & !zero_flag;     // BNE
            3'b100: take_branch = Branch & alu_result[0]; // BLT 
            3'b101: take_branch = Branch & !alu_result[0];// BGE
            default: take_branch = 1'b0;
        endcase
    end

    assign pc_next = (take_branch) ? (pc_out + $signed(imm_out)) : (pc_out + 4);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 32'b0;
        else
            pc_out <= pc_next;
    end

endmodule