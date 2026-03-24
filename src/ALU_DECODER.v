`timescale 1ns / 1ps

module ALU_DECODER(
    input  [31:0] instruction, //Instruction
    output [4:0]  rs1, rs2, rd, // Registers
    output reg [3:0] alu_control, // ALU 
    output reg [31:0] imm_out,  //Immediate value that generated
    output reg ALUsrc,// ALU input selector
    output reg mem_write, mem_read, MemtoReg, // Signals For Data memory
    output reg Branch, // Signal For B-type
    output reg RegWrite, // For write rd
    output wire [2:0] funct3 //For Program Counter to Selecting Branch 
    );
    
    wire [6:0] opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    
    assign rd  = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    
    always @(*) begin
        // Default
        alu_control = 4'b1111;
        imm_out     = 32'b0;
        ALUsrc      = 0;
        mem_write   = 0;
        mem_read    = 0;
        MemtoReg    = 0;
        Branch      = 0;
        RegWrite    = 0; 
    
        case(opcode)
            // --- R-TYPE (ADD, SUB, AND, OR...) ---
            7'b0110011: begin
                ALUsrc   = 0;
                RegWrite = 1; 
                case(funct3)
                    3'b000: alu_control = (funct7[5]) ? 4'b0011 : 4'b0010; // SUB : ADD
                    3'b111: alu_control = 4'b0000; // AND
                    3'b110: alu_control = 4'b0001; // OR
                    3'b010: alu_control = 4'b0100; // SLT
                endcase
            end
            
            // --- I-TYPE (ADDI, ANDI, ORI) ---
            7'b0010011: begin
                ALUsrc   = 1;
                RegWrite = 1;
                imm_out  = {{20{instruction[31]}}, instruction[31:20]};
                case(funct3)
                    3'b000: alu_control = 4'b0010; // ADDI
                    3'b111: alu_control = 4'b0000; // ANDI
                    3'b110: alu_control = 4'b0001; // ORI
                endcase
            end
            
            // --- LOAD (LW) ---
            7'b0000011: begin
                ALUsrc      = 1;
                mem_read    = 1;
                MemtoReg    = 1;
                RegWrite    = 1;
                imm_out     = {{20{instruction[31]}}, instruction[31:20]};
                alu_control = 4'b0010; 
            end
            
            // --- STORE (SW) ---
            7'b0100011: begin
                ALUsrc      = 1;
                mem_write   = 1;
                RegWrite    = 0; 
                imm_out     = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                alu_control = 4'b0010; 
            end
            
            // --- BRANCH ---
            7'b1100011: begin
                ALUsrc      = 0;   
                Branch      = 1;  
                RegWrite    = 0;   
                imm_out = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};          
                  
            case(funct3)
                3'b000: alu_control = 4'b0011; // BEQ
                3'b001: alu_control = 4'b0011; // BNE 
                3'b100: alu_control = 4'b0100; // BLT
                3'b101: alu_control = 4'b0100; // BGE
                default: alu_control = 4'b0011;
            endcase
            end

            default: alu_control = 4'b1111;
        endcase
    end
endmodule