// iverilog -o out.vvp fetchCycleTB.v fetchCycle.v
// vvp out.vvp
// gtkwave dump.vcd
module TB();
    reg clk = 1,rst;
    reg [1:0] PC_Src;
    reg [31:0] Address,jumpAddress,branchAddress;
    wire [31:0] Instruction,PC_Next , PC;

    fetchCycle test(.clk(clk),.rst(rst), .PC_Src(PC_Src),.PC(PC), .jumpAddress(jumpAddress), .branchAddress(branchAddress), .Instruction(Instruction), .PC_Next(PC_Next));

    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b0;
        #200
        rst <= 1'b1;
        PC_Src <= 2'b00;
        Address <= 32'h00000000;
        #500
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

endmodule