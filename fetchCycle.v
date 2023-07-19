

module fetchCycle(
    input clk,
    input rst,
    input [1:0] PC_Src,
    input [31:0] PC,
    input [31:0] Address,
    input [31:0] jumpAddress,
    input [31:0] branchAddress,
    output [31:0] Instruction,
    output [31:0] PC_Next
    );
    reg [31:0] Inst,PC_Reg;//Pipeline registers

    Muxm3to1 Pcsrc_MUX(.in0(PC_Next), .in1(jumpAddress), .in2(branchAddress), .sel(PC_Src), .out(Address));
    PCModule pc_mod(.clk(clk),.rst(rst), .address(Address), .PC(PC));
    InstructionMemory inst(.rst(rst),.address(PC),.instruction(Instruction));
    PC_Adder pc4(.PC(PC), .PC_Next(PC_Next));


    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            Inst <= 32'h00000000;
            PC_Reg <= 32'h00000000;
        end
        else begin
            Inst <= Instruction;
            PC_Reg <= PC;
        end
    end
    
endmodule

module PCModule(
    input clk,
    input rst,
    input [31:0]address,
    output reg [31:0] PC
    );
    //reg [31:0] PC;
    always @(posedge clk)
    begin
        if(rst == 1'b0)
            PC <= {32{1'b0}};
        else
            PC <= address;
    end
endmodule

module PC_Adder (
    input [31:0]PC,
    output [31:0]PC_Next
    );
    assign PC_Next =  PC + 32'h00000004;
endmodule

module InstructionMemory (
  input rst,
  input [31:0] address,
  output [31:0] instruction
);

  reg [31:0] memory [0:1023]; // Example: 1024 entries, each storing a 32-bit instruction

  // always @(address) begin
  assign instruction = (rst == 1'b0) ? {32{1'b0}} : memory[address[31:2]];
  // end
  // Initialize the memory with instructions
  initial begin
    // Load instructions into the memory
    memory[0] <= 32'h01234567; // Example instruction at address 0
    memory[1] <= 32'h89ABCDEF; // Example instruction at address 1
    // ...
  end

endmodule 

module Muxm3to1 (
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [1:0] sel,
    output reg [31:0] out
  );
  always @* begin
    case(sel)
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
    endcase
  end
endmodule
