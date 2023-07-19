// iverilog -o out.vvp decodeCycleTB.v decodeCycle.v
// vvp out.vvp
// gtkwave decode.vcd


module decodeCycle_tb;

  // Inputs
  reg clk;
  reg rst;
  reg [31:0] Instruction;
  reg [31:0] PC;
  reg [31:0] DataW;

  // Outputs
  wire [31:0] PC_out;
  wire [31:0] ExImm;
  wire [31:0] Op1;
  wire [31:0] Op2;
  wire [31:0] ExSA;
  wire [4:0] Rd;
  wire [1:0] ALUSrc;
  wire [3:0] ALUOp;
  wire mem_R;
  wire mem_W;
  wire WB;
  wire RegW;
  wire [1:0] PC_Src;
  wire [31:0] jumpAddress;

  // Instantiate the module under test
  decodeCycle decodeCycTB (
    .clk(clk),
    .rst(rst),
    .Instruction(Instruction),
    .PC(PC),
    .DataW(DataW),
    .PC_out(PC_out),
    .ExImm(ExImm),
    .Op1(Op1),
    .Op2(Op2),
    .ExSA(ExSA),
    .Rd(Rd),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .mem_R(mem_R),
    .mem_W(mem_W),
    .WB(WB),
    .RegW(RegW),
    .PC_Src(PC_Src),
    .jumpAddress(jumpAddress)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Testbench stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    Instruction = 32'b11001010101010101010101010100000;
    PC = 32'h00000000;
    DataW = 32'h00000000;

    #10 rst = 0; // Deassert reset

    // Test case 1
    #10 Instruction = 32'b10101010101010101010101010100000; // Set instruction value
    #10 PC = 32'h10000000; // Set PC value
    #10 DataW = 32'hABCDEF01; // Set DataW value

    // Wait for some cycles to observe the outputs
    #20;

    // Test case 2
    #10 Instruction = 32'b11101010101010101010101010100000; // Set instruction value
    #10 PC = 32'h20000000; // Set PC value
    #10 DataW = 32'h01234567; // Set DataW value

    // Wait for some cycles to observe the outputs
    #20;

    // Add more test cases as needed

    // End simulation
    $finish;
  end
    initial begin
        $dumpfile("decode.vcd");
        $dumpvars(0);
    end

endmodule

