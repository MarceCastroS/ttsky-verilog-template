// Testbench automatically generated online
// at https://vhdl.lapinoo.net
// Generation date : Sat, 06 Sep 2025 05:10:59 GMT
// Request id : cfwk-fed377c2-68bbc2633af97

`timescale 1ns / 1ps

module tb_Cardjitsu;

    // Component declaration for Cardjitsu
    reg clk;
    reg rst;
    reg btn_0;
    reg btn_1;
    reg btn_2;
    reg [3:0] sw;
    wire [3:0] leds;
    wire led6_r;
    wire led6_g;
    wire led6_b;

    Cardjitsu dut (
        .clk(clk),
        .rst(rst),
        .btn_0(btn_0),
        .btn_1(btn_1),
        .btn_2(btn_2),
        .sw(sw),
        .leds(leds),
        .led6_r(led6_r),
        .led6_g(led6_g),
        .led6_b(led6_b)
    );

    parameter TbPeriod = 1000; // ***EDIT*** Put right period here
    reg TbClock = 0;
    reg TbSimEnded = 0;

    initial begin
        // Clock generation
        forever begin
            #(TbPeriod / 2) TbClock = ~TbClock;
            if (TbSimEnded) begin
                TbClock = 0;
            end
        end
    end

    // ***EDIT*** Check that clk is really your main clock signal
    always @(posedge TbClock) begin
        clk = TbClock;
    end

    initial begin
        // ***EDIT*** Adapt initialization as needed
        btn_0 = 0;
        btn_1 = 0;
        btn_2 = 0;
        sw = 4'b0000;

        // Reset generation
        // ***EDIT*** Check that rst is really your reset signal
        rst = 1;
        #100;
        rst = 0;
        #100;

        // ***EDIT*** Add stimuli here
        #(100 * TbPeriod);

        // Stop the clock and hence terminate the simulation
        TbSimEnded = 1;
        #1;
        $finish;
    end

endmodule

// Configuration block below is required by some simulators. Usually no need to edit.

`timescale 1ns / 1ps
module cfg_tb_Cardjitsu;
    // Configuration for tb_Cardjitsu
endmodule