module memoryCycle_tb;
  reg clk;
  reg rst;
  reg Mem_R;
  reg Mem_W;
  reg WB;
  reg RegW;
  reg [31:0] Alu_Res;
  reg [31:0] Data_in;
  reg [4:0] Rd2;
  wire RegW_out;
  wire [31:0] WB_Data;
  wire [4:0] Rd3;

  memoryCycle dut(
    .clk(clk),
    .rst(rst),
    .Mem_R(Mem_R),
    .Mem_W(Mem_W),
    .WB(WB),
    .RegW(RegW),
    .Alu_Res(Alu_Res),
    .Data_in(Data_in),
    .Rd2(Rd2),
    .RegW_out(RegW_out),
    .WB_Data(WB_Data),
    .Rd3(Rd3)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    Mem_R = 0;
    Mem_W = 0;
    WB = 0;
    RegW = 0;
    Alu_Res = 0;
    Data_in = 0;
    Rd2 = 0;

    // Testcase 1
    #10;
    rst = 1;
    #5;
    rst = 0;
    Mem_W = 1;
    Alu_Res = 10;
    Data_in = 100;
    #10;
    Mem_W = 0;
    #5;
    Mem_R = 1;
    Alu_Res = 10;
    #10;

    // Testcase 2
    #10;
    Mem_W = 1;
    Alu_Res = 20;
    Data_in = 200;
    #10;
    Mem_W = 0;
    #5;
    Mem_R = 1;
    Alu_Res = 20;
    #10;

    // Add more testcases as needed

    $finish;
  end
    initial begin
        $dumpfile("memory.vcd");
        $dumpvars(0);
    end
endmodule
