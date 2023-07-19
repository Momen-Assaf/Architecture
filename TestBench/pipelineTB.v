module pipeLine_tb;

  // Inputs
  reg clk;
  reg rst;

  // Outputs
  wire [31:0] ALU_Res;
  wire [31:0] WB_Data_out;

  // Instantiate the module under test
  pipeLine pipeLineTB (
    .clk(clk),
    .rst(rst),
    .ALU_Res(ALU_Res),
    .WB_Data_out(WB_Data_out)
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;

    // Apply reset
    #5 rst = 0;
    clk = 1;

    // Toggle clock
    #10 clk = ~clk;

    // Wait for some time to observe the outputs
    #35;

    // End simulation
    $finish;
  end
    initial begin
        $dumpfile("pipeline.vcd");
        $dumpvars(0);
    end

endmodule
