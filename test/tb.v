`default_nettype none
`timescale 1ns/1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.

   Mapping:
     ui_in[0] -> btn_0
     ui_in[1] -> btn_1
     ui_in[2] -> btn_2
     uio_in[3:0] -> sw[3:0]
     rst_n (active-low) -> rst (active-high) for DUT
     uo_out[3:0] <- leds[3:0]
     uo_out[6:4] <- {led6_b, led6_g, led6_r}
     uio_out/uio_oe left unused (driven low)
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Harness-style I/O (driven by cocotb)
  reg        clk;
  reg        rst_n;
  reg        ena;
  reg  [7:0] ui_in;
  reg  [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  // Power pins (not used by Cardjitsu; keep here for format parity)
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Derived nets for DUT
  wire        rst    = ~rst_n;     // DUT reset is active-high
  wire        btn_0  = ui_in[0];
  wire        btn_1  = ui_in[1];
  wire        btn_2  = ui_in[2];
  wire [3:0]  sw     = uio_in[3:0];

  // DUT outputs
  wire [3:0]  leds;
  wire        led6_r, led6_g, led6_b;

  // Map DUT outputs into harness buses
  assign uo_out[3:0] = leds;
  assign uo_out[4]   = led6_r;
  assign uo_out[5]   = led6_g;
  assign uo_out[6]   = led6_b;
  assign uo_out[7]   = 1'b0;

  // Unused bidirectional bus in this project
  assign uio_out = 8'h00;
  assign uio_oe  = 8'h00;

  // Replace tt_um_example with your module name:
  tt_um_cardjitsu user_project (
`ifdef GL_TEST
    // Cardjitsu has no power pins; ensure GL_TEST isn't required for this DUT.
    // (Do NOT pass .VPWR/.VGND here.)
`endif
    .clk    (clk),
    .rst    (rst),
    .btn_0  (btn_0),
    .btn_1  (btn_1),
    .btn_2  (btn_2),
    .sw     (sw),
    .leds   (leds),
    .led6_r (led6_r),
    .led6_g (led6_g),
    .led6_b (led6_b)
  );

endmodule
