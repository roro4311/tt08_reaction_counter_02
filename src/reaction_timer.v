`default_nettype none
`timescale 1ns / 1ps

module reaction_timer (
    input wire clk,
    input wire rst_n,
    input wire start_stop,
    output reg [15:0] reaction_time,
    output reg [6:0] seg0, seg1, seg2, seg3,
    output reg led
);

  reg [31:0] counter;
  reg running;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      counter <= 0;
      reaction_time <= 0;
      running <= 0;
      led <= 0;
      seg0 <= 7'b1111111;
      seg1 <= 7'b1111111;
      seg2 <= 7'b1111111;
      seg3 <= 7'b1111111;
    end else begin
      if (start_stop) begin
        if (running) begin
          reaction_time <= counter[15:0];
          running <= 0;
          led <= 0;
          counter <= 0;
        end else begin
          running <= 1;
          led <= 1;
        end
      end

      if (running) begin
        counter <= counter + 1;
      end

      // Update 7-segment displays
      seg0 <= decode_7segment(reaction_time[3:0]);
      seg1 <= decode_7segment(reaction_time[7:4]);
      seg2 <= decode_7segment(reaction_time[11:8]);
      seg3 <= decode_7segment(reaction_time[15:12]);
    end
  end

  function [6:0] decode_7segment;
    input [3:0] digit;
    begin
      case (digit)
        4'd0: decode_7segment = 7'b1000000;
        4'd1: decode_7segment = 7'b1111001;
        4'd2: decode_7segment = 7'b0100100;
        4'd3: decode_7segment = 7'b0110000;
        4'd4: decode_7segment = 7'b0011001;
        4'd5: decode_7segment = 7'b0010010;
        4'd6: decode_7segment = 7'b0000010;
        4'd7: decode_7segment = 7'b1111000;
        4'd8: decode_7segment = 7'b0000000;
        4'd9: decode_7segment = 7'b0010000;
        default: decode_7segment = 7'b1111111;
      endcase
    end
  endfunction

endmodule

