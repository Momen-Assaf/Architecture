module instructionDecoder_TB;
    reg [31:0] instruction;
    wire [4:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [13:0] immediate;
    wire [1:0] type;
    wire stop;
    wire [23:0] signedimmediate;
    wire [4:0] SA;

    instructionDecoder instDecode_TB(.instruction(instruction),.opcode(opcode),.rs1(rs1),.rs2(rs2),.rd(rd),.immediate(immediate),.type(type),.stop(stop),.signedimmediate(signedimmediate),.SA(SA));

    initial begin
        instruction <= 32'b11001010101010101010101010100000;
        #500
        $finish;
    end

    initial begin
        $dumpfile("instructionDecoder.vcd");
        $dumpvars(0);
    end

endmodule

module mainController_TB;

  // Inputs
  reg [4:0] op;
  reg [1:0] type;

  // Outputs
  wire extOp;
  wire [1:0] ALUSrc;
  wire regW;
  wire mem_R;
  wire mem_W;
  wire WB;
  wire [1:0] pcSrc;

  // Instantiate the module under test
  mainController mc_TB (
    .op(op),
    .type(type),
    .extOp(extOp),
    .ALUSrc(ALUSrc),
    .regW(regW),
    .mem_R(mem_R),
    .mem_W(mem_W),
    .WB(WB),
    .pcSrc(pcSrc)
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    op = 5'b00000;
    type = 2'b00;

    #10 op = 5'b00100; // Set op value
    #10 type = 2'b10; // Set type value

    // Wait for some time to observe the outputs
    #20;

    // Add more test cases as needed

    // End simulation
    $finish;
  end

    initial begin
        $dumpfile("mainController.vcd");
        $dumpvars(0);
    end

endmodule

module controlUnit_tb;

  // Inputs
  reg [4:0] op;
  reg [1:0] type;

  // Outputs
  wire extOp;
  wire [1:0] ALUSrc;
  wire regW;
  wire mem_R;
  wire mem_W;
  wire WB;
  wire [1:0] pcSrc;
  wire [3:0] ALUOp;

  // Instantiate the module under test
  controlUnit dut (
    .op(op),
    .type(type),
    .extOp(extOp),
    .ALUSrc(ALUSrc),
    .regW(regW),
    .mem_R(mem_R),
    .mem_W(mem_W),
    .WB(WB),
    .pcSrc(pcSrc),
    .ALUOp(ALUOp)
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    op = 5'b00000;
    type = 2'b00;

    #10 op = 5'b00100; // Set op value
    #10 type = 2'b10; // Set type value

    // Wait for some time to observe the outputs
    #20;

    // Add more test cases as needed

    // End simulation
    $finish;
  end
    initial begin
        $dumpfile("controlUnit.vcd");
        $dumpvars(0);
    end
endmodule
