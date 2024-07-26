`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs
  reg clk;
  reg rst_n;
  reg [7:0] ui_in;
  wire [7:0] uo_out;
  wire [31:0] uio_out; // Updated width to 7
  wire [7:0] uio_oe;
  reg ena;

  // Instantiate the DUT (Device Under Test)
  tt_um_reaction_timer uut (
      .clk     (clk),
      .rst_n   (rst_n),
      .ui_in   (ui_in),
      .uo_out  (uo_out),
      .uio_in  (8'b0),   // Not used in this testbench
      .uio_out (uio_out),
      .uio_oe  (uio_oe),
      .ena     (ena)
  );

  // Generate clock
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // 50 MHz clock
  end

  // Initial conditions
  initial begin
    rst_n = 0;
    ui_in = 8'b0;
    ena = 1'b0;
    #100 rst_n = 1;
    ena = 1'b1;
    #300 ui_in[0] = 1;  // Press button
    #20 ui_in[0] = 0;   // Release button
    #30 rst_n = 0;      // Reset
    #30 rst_n = 1;      // Release reset
    #300 ui_in[0] = 1;  // Press button again
    #20 ui_in[0] = 0;   // Release button again
  end

  // Stop simulation after 10 seconds
  initial begin
    #100000000; // 10 seconds in nanoseconds (10 * 10^9 ns)
    $finish;
  end

endmodule

