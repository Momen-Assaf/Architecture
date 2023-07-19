// iverilog -o out.vvp executeCycleTB.v executeCycle.v
// vvp out.vvp
// gtkwave execute.vcd

module executeCycle_tb;

  // Inputs
  reg clk;
  reg rst;
  reg [31:0] PC;
  reg [31:0] ExImm;
  reg [31:0] Op1;
  reg [31:0] Op2;
  reg [31:0] SA;
  reg [4:0] Rd1;
  reg [1:0] ALUSrc;
  reg [3:0] ALUOp;
  reg mem_R;
  reg mem_W;
  reg WB;
  reg RegW;
  reg [1:0] PC_Src;

  // Outputs
  wire [31:0] branchAddress;
  wire [31:0] Alu_Res;
  wire [4:0] Rd2;
  wire mem_R_out;
  wire mem_W_out;
  wire WB_out;
  wire RegW_out;
  wire [1:0] PC_Src_out;

  // Instantiate the module under test
  executeCycle exeCycleTB (
    .clk(clk),
    .rst(rst),
    .PC(PC),
    .ExImm(ExImm),
    .Op1(Op1),
    .Op2(Op2),
    .SA(SA),
    .Rd1(Rd1),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .mem_R(mem_R),
    .mem_W(mem_W),
    .WB(WB),
    .RegW(RegW),
    .PC_Src(PC_Src),
    .branchAddress(branchAddress),
    .Alu_Res(Alu_Res),
    .Rd2(Rd2),
    .mem_R_out(mem_R_out),
    .mem_W_out(mem_W_out),
    .WB_out(WB_out),
    .RegW_out(RegW_out),
    .PC_Src_out(PC_Src_out)
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    PC = 32'h00000004;
    ExImm = 0;
    Op1 = 32'h00000000;
    Op2 = 32'h01111111;
    SA = 0;
    Rd1 = 0;
    ALUSrc = 0;
    ALUOp = 4'b0010;
    mem_R = 0;
    mem_W = 0;
    WB = 0;
    RegW = 0;
    PC_Src = 0;

    // Wait for some time to observe the outputs
    #5;
    clk = 1;
    rst = 0;
    PC = 32'h00000008;
    ExImm = 32'h01111111;
    Op1 = 32'h00000000;
    Op2 = 32'h01111111;
    SA = 0;
    Rd1 = 0;
    ALUSrc = 2'b01;
    ALUOp = 4'b0100;

    // Toggle clock
    forever #2 clk = ~clk;

    // End simulation
    $finish;
  end
    initial begin
        $dumpfile("execute.vcd");
        $dumpvars(0);
    end
endmodule
