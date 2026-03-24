`timescale 1ns / 1ps

module tb_RISCV_TOP();

    reg clk;
    reg rst;
    
    wire [31:0] tb_alu_result;
    wire tb_zero_flag;
    wire [31:0] tb_pc;

    // Unit Under Test (UUT)
    RISCV_TOP uut (
        .clk(clk),
        .rst(rst),
        .result(tb_alu_result),
        .zero_flag(tb_zero_flag),
        .current_pc(tb_pc) 
    );

    // CLOCK
    always #5 clk = ~clk;

  initial begin
        clk = 0;
        rst = 1;

        // Clear Reset at first clk
        #10 rst = 0; 
        
        // Sim Time
        #500;

        $stop;
    end

    initial begin
        $monitor("Time: %0t | PC: %h | Result (Hex): %h | Result (Dec): %d", 
                 $time, tb_pc, tb_alu_result, $signed(tb_alu_result));
    end

endmodule