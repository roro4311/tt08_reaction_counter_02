`default_nettype none
`timescale 1ns / 1ps

module tt_um_reaction_timer (
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire ena,
    input wire clk,
    input wire rst_n
);

  wire [15:0] reaction_time;
  wire [6:0] seg0, seg1, seg2, seg3;
  wire led;

  reaction_timer rt (
    .clk(clk),
    .rst_n(rst_n),
    .start_stop(ui_in[0]),
    .reaction_time(reaction_time),
    .seg0(seg0),
    .seg1(seg1),
    .seg2(seg2),
    .seg3(seg3),
    .led(led)
  );

  assign uo_out[0] = led;

  // Map 7-segment displays to uio_out
  assign uio_out[7:0] = seg0;
  assign uio_out[15:8] = seg1;
  assign uio_out[23:16] = seg2;
  assign uio_out[31:24] = seg3;

  // Output enable for uio_out
  assign uio_oe = 8'hFF;

endmodule

