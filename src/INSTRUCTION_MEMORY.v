module INSTRUCTION_MEMORY(
    input  [31:0] pc,
    output [31:0] instruction
    );

    reg [31:0] rom [0:63];

    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) rom[i] = 32'h00000033; // NOP for all roms
        
        // An Example
        rom[0] = 32'h00400293; // addi x5, x0, 4     
        rom[1] = 32'h00A00313; // addi x6, x0, 10     
        rom[2] = 32'h00C00393; // addi x7, x0, 12     
        
        // --- (PC = 0x0C) ---
        rom[3] = 32'h0063C663; // BLT x7, x6, offset = 12 (PC + 12 = 0x18)
        
        rom[4] = 32'h00530313; // addi x6, x6, 5      (x6 = x6 + 5)
        
        rom[5] = 32'h00000463; // BEQ x0, x0, offset = 8 (PC + 8 = 0x1C)
        
        // (PC = 0x18)
        rom[6] = 32'hFFE30313; // addi x6, x6, -2     (x6 = x6 - 2)
        
        // --- (PC = 0x1C) ---
        rom[7] = 32'hFFF28293; // addi x5, x5, -1     (x5 = x5 - 1)
        // If x5 != 0 then go to (PC = 0x0C)
        rom[8] = 32'hFE0296E3; // BNE x5, x0, offset = -20 (PC - 20 = 0x0C)
        
        // --- (PC = 0x24) ---
        rom[9] = 32'h02602023; // sw x6, 32(x0)       (The result will be in 0x20)
    
    end

    assign instruction = rom[pc[31:2]]; 

endmodule