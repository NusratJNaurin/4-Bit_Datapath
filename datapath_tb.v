`timescale 1ns/1ps

// Testbench: Datapath
// - Initializes the register file with two values, performs an ALU ADD,
//   and writes the ALU result back to a destination register.
// - Produces `datapath.vcd` for waveform viewing.
module datapath_tb();

  reg clk;
  reg load;
  reg [3:0] input_value;
  reg [1:0] SELA;
  reg [1:0] SELB;
  reg [1:0] SELD;
  reg [1:0] opcode;
  
  wire [3:0] final_result;
  wire ZF;

  // DUT instantiation
  datapath DUT (
    .clk(clk),
    .load(load),
    .input_value(input_value),
    .SELA(SELA),
    .SELB(SELB),
    .SELD(SELD),
    .opcode(opcode),
    .final_result(final_result),
    .ZF(ZF)
  );
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
	$dumpfile("datapath.vcd");
    $dumpvars(0, datapath_tb);
    $dumpvars(0, DUT);
  end

  initial begin
    load = 0;
    input_value = 0;
    SELA = 0;
    SELB = 0;
    SELD = 0;
    opcode = 0;
   	@(posedge clk);

    load = 1;
    input_value = 4'd4;
    SELD = 2'b00;
    @(posedge clk);

    
    input_value = 4'd2;
    SELD = 2'b01;
    @(posedge clk);
   
    SELA = 2'b00;
    SELB = 2'b01;
    opcode = 2'b00;   // ADD
   	@(posedge clk);

    
    load = 0;
    SELD = 2'b11;
    @(posedge clk);

    $finish;

  end

endmodule