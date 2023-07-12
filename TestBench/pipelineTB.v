module pipeLine_tb;

  // Inputs
  reg clk;
  reg rst;

  // Outputs
  wire [31:0] WB_Data;

  // Instantiate the module under test
  pipeLine pipeLineTB (
    .clk(clk),
    .rst(rst),
    .WB_Data(WB_Data)
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;

    // Apply reset
    #5 rst = 0;

    // Toggle clock
    forever #10 clk = ~clk;

    // Wait for some time to observe the outputs
    #100;

    // End simulation
    $finish;
  end
    initial begin
        $dumpfile("pipeline.vcd");
        $dumpvars(0);
    end

endmodule
