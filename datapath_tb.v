`timescale 1ns/1ps

module datapath_tb();
	
	reg clk, load, WE; 
	reg [3:0] input_value; 
	reg [1:0] SELA, SELB, SELD, opr;
	wire [3:0] final_result;
	wire ZF;

  datapath DUT (
    .clk(clk), .load(load), .WE(WE),
    .input_value(input_value),
    .SELA(SELA), .SELB(SELB), .SELD(SELD),
	.opr(opr),
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
	opr <= 2'b00; 
    load <= 0; SELD <= 2'b10; // R2 = R0 + R1 = 10 + 2 = 12 (c)
    @(posedge clk);
    

    // SUB TEST CASE
    SELA <= 2'b00; SELB <= 2'b01;
    opr <= 2'b01; 
    SELD <= 2'b11; // R4 = R0 - R1 = 8
    @(posedge clk);
    

    // AND TEST CASE
    load <= 1; WE <= 1; SELA = 2'b00; SELB = 2'b00;
    input_value <= 4'd15; SELD <= 2'b01; @(posedge clk);
    input_value <= 4'd10; SELD <= 2'b11; @(posedge clk);

    WE <= 0; SELA <= 2'b01; SELB <= 2'b11;
    opr <= 2'b10; 
    load <= 0; SELD <= 2'b00; // R0 = R1 & R3 = 15 & 10 = 10
    @(posedge clk);
    

    // OR TEST CASE
    SELA <= 2'b01; SELB <= 2'b11;
    opr <= 2'b11; 
    SELD <= 2'b00; // R0 = R1 | R3 = 15 | 10 = 1111
    @(posedge clk);
    

    WE <= 0;
    @(posedge clk);
    $finish;
  end

endmodule
