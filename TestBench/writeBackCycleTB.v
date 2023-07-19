// iverilog -o out.vvp writeBackCycleTB.v writeBackCycle.v
// vvp out.vvp
// gtkwave WB.vcd
module writeBackCycle_tb;

  // Inputs
  reg clk;
  reg rst;
  reg ResW;
  reg [31:0] Data;
  reg [4:0] Rd3;

  // Outputs
  wire ResW_out;
  wire [4:0] Rd4;
  wire [31:0] WB_Data;

  // Instantiate the module under test
  writeBackCycle wbCycleTB (
    .clk(clk),
    .rst(rst),
    .ResW(ResW),
    .Data(Data),
    .Rd3(Rd3),
    .ResW_out(ResW_out),
    .Rd4(Rd4),
    .WB_Data(WB_Data)
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    clk = 1;
    rst = 1;
    ResW = 0;
    Data = 32'hA5A5A5A5;
    Rd3 = 5'b01010;

    // Apply reset
    #5 rst = 0;

    // Wait for some time to observe the outputs
    #20;
    clk = 1;
    rst = 0;
    ResW = 0;
    Data = 32'h95632214;
    Rd3 = 5'b01010;

    #35;
    // End simulation
    $finish;
  end
  
    initial begin
        $dumpfile("WB.vcd");
        $dumpvars(0);
    end

endmodule

