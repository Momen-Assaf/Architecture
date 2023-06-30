`include "components.v"

module fetchCycle(
    input clk,
    input rst,
    input [1:0] PC_Src,
    input [31:0] Address,
    input [31:0] jumpAddress,
    input [31:0] branchAddress,
    output [31:0] Instruction,
    output [31:0] PC_Next
    );
    wire [31:0] PC;
    reg [31:0] NPC,Inst;

    Mux3to1 Pcsrc_MUX(.in0(PC_Next), .in1(jumpAddress), .in2(branchAddress), .sel(PC_Src), .out(Address));
    PCModule pc_mod(.clk(clk),.rst(rst), .address(Address), .PC(PC));
    InstructionMemory inst(.rst(rst),.address(PC),.instruction(Instruction));
    PC_Adder pc4(.PC(PC), .PC_Next(PC_Next));


    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            NPC <= 32'h00000000;
            Inst <= 32'h00000000;
        end
        else begin
            NPC <= PC_Next;
            Inst <= Instruction;
        end
    end

    //Assigning Registers Value to the Output port
    // assign  PC_Next = (rst == 1'b0) ? 32'h00000000 : NPC;
    // assign  Instruction = (rst == 1'b0) ? 32'h00000000 : Inst;
    
endmodule

module PCModule(
    input clk,
    input rst,
    input [31:0]address,
    output [31:0] PC
    );
    reg [31:0] PC;
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