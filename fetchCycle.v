
`include "components.v"

module fetchCycle(
    input clk,
    input PC_Src,
    input [31:0] jumpAddress,
    input [31:0] branchAddress,
    output [31:0] Instruction,
    output [31:0] PC_Next
    );
    wire [31:0] Address, PC;
    reg [31:0] NPC,Inst;

    Mux3to1 Pcsrc_MUX(.in0(PC_Next), .in1(jumpAddress), .in2(branchAddress), .sel(PC_Src), .out(Address));
    PC pc_module(.clk(clk), .address(Address), .PC(PC));
    PC_Adder pc4(.PC(PC), .PC_Next(PC_Next));
    InstructionMemory inst(.address(PC),.instruction(Instruction));

    always @(posedge clk) begin
        NPC <= PC_Next;
        Inst <= Instruction;
    end
endmodule

module PC(
    input clk;
    input [31:0]address;
    output [31:0]PC;
    );
    always @(posedge clk)
    begin
        PC <= address;
    end
endmodule

module PC_Adder (
    input [31:0]PC,
    output [31:0]PC_Next
    );
    assign PC_Next = PC + 32'h00000004;
endmodule

module InstructionMemory (
  input [31:0] address,
  output reg [31:0] instruction
);

  reg [31:0] memory [0:1023]; // Example: 1024 entries, each storing a 32-bit instruction

  // Initialize the memory with instructions
  initial begin
    // Load instructions into the memory
    memory[0] <= 32'h01234567; // Example instruction at address 0
    memory[1] <= 32'h89ABCDEF; // Example instruction at address 1
    // ...
  end

  always @(address)
    instruction <= memory[address];

endmodule InstructionMemory