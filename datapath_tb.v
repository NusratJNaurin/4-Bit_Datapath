`timescale 1ns/1ps

module datapath_tb();
	
  reg clk, load, WE;
  reg [3:0] input_value;
  reg [1:0] SELA, SELB, SELD, opcode;
  wire [3:0] final_result;
  wire ZF;

  datapath DUT (
    .clk(clk), .load(load), .WE(WE),
    .input_value(input_value),
    .SELA(SELA), .SELB(SELB), .SELD(SELD),
    .opcode(opcode),
    .final_result(final_result), .ZF(ZF)
  );

  initial begin clk = 0; forever #10 clk = ~clk; end

  initial begin
    $dumpfile("datapath.vcd");
    $dumpvars(0, datapath_tb);
  end

  initial begin
    load = 0; WE = 0;
    @(posedge clk); 

    // ADD TEST CASE
    load <= 1; WE <= 1;
    input_value <= 4'd10; SELD <= 2'b00; @(posedge clk); 
    input_value <= 4'd2;  SELD <= 2'b01; @(posedge clk);

    WE <= 0; SELA <= 2'b00; SELB <= 2'b01;
	opcode <= 2'b00; load <= 0; SELD <= 2'b10; // R3 = R1 + R0 = 10 + 2 = 12 (c)
    @(posedge clk);
    

    // SUB TEST CASE
    WE <= 0; SELA <= 2'b00; SELB <= 2'b01;
    opcode <= 2'b01; load <= 0; SELD <= 2'b11; // R4 = R1 - R2 = 8
    @(posedge clk);
    

    // AND TEST CASE
    load <= 1; WE <= 1;
    input_value <= 4'd10; SELD <= 2'b10; @(posedge clk); 
    input_value <= 4'd5; SELD <= 2'b11; @(posedge clk);

    WE <= 0; SELA <= 2'b10; SELB <= 2'b11;
    opcode <=2'b10; load <= 0; SELD <= 2'b01; // R2 = R3 & R4 = 10 & 5 = 0
    @(posedge clk);
    

    // OR TEST CASE
    load <= 1; WE <= 1;
    input_value <= 4'b1111; SELD <= 2'b01; @(posedge clk);
    input_value <= 4'b1010; SELD <= 2'b11; @(posedge clk);

    WE <= 0; SELA <= 2'b01; SELB <= 2'b11;
    opcode <= 2'b11; load <= 0; SELD <= 2'b00; // R1 = R2 | R4 = 15 | 10 = 1111
    @(posedge clk);
    

    WE <= 0;
    @(posedge clk);
    $finish;
  end

endmodule
