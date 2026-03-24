module RISCV_TOP(
    input clk,
    input rst,
    output [31:0] result, //ALU result
    output zero_flag,        
    output [31:0] current_pc
    );
    
    //Wire interconnections for modules 
    wire [31:0] pc_next;
    wire [31:0] instruction;
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    wire [3:0] alu_ctrl;
    wire ALUsrc;
    wire [31:0] reg_data1, reg_data2,dataselect2,immediate;
    wire [31:0] mem_read_data;
    wire [31:0] final_result;
    wire mem_write, mem_read, MemtoReg;
    wire [2:0] funct3_out;
    wire Branch, Regwrite;
    
    assign reg_data2 = (ALUsrc) ? immediate : dataselect2 ; //Select immediate or r2 before ALU

    //Module: Program Counter(PC)
    PROGRAM_COUNTER pc_inst (
        .clk(clk),
        .rst(rst),
        .Branch(Branch),
        .zero_flag(zero_flag),
        .alu_result(result),
        .funct3(funct3_out),
        .imm_out(immediate),
        .pc_out(current_pc)
      );
    
    //Module: Instruction Memory
    INSTRUCTION_MEMORY imem_inst (
        .pc(current_pc),
        .instruction(instruction)
    );
    
    //Module: DECODER
    ALU_DECODER decoder_inst (
        .instruction(instruction),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .rd(rd_addr),
        .alu_control(alu_ctrl),
        .imm_out(immediate),
        .ALUsrc(ALUsrc),
        .mem_write(mem_write),
        .mem_read(mem_read), 
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .RegWrite(Regwrite),
        .funct3(funct3_out)
    );

    //Module: REGISTER FILE 
    REGISTER_FILE reg_file_inst (
        .clk(clk),
        .rst(rst),
        .reg_write(Regwrite),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .write_data(final_result), 
        .rs1_data(reg_data1),
        .rs2_data(dataselect2)
    );

    //Module: ALU 
    ALU alu_inst (
        .a(reg_data1),
        .b(reg_data2),
        .alu_control(alu_ctrl),
        .result(result),
        .zero(zero_flag)
    );

    DATA_MEMORY data_memory_inst (
    .clk(clk),
    .mem_write(mem_write),           
    .mem_read(mem_read),            
    .addr(result),         
    .write_data(dataselect2),    
    .read_data(mem_read_data) 
);
assign final_result = (MemtoReg) ? mem_read_data : result;
endmodule