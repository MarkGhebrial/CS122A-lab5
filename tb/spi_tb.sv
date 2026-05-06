`include "src/spi.sv"
`timescale 1ns/1ps

module top_tb;

logic clk = 0;
logic spi_in = 0;

wire spi_we;
wire[7:0] waddr;
wire[15:0] wdata;

// Unit under test
spi_rx uut
(
    .sck(clk),
    .in(spi_in),
    .we(spi_we),
    .waddr(waddr),
    .wdata(wdata)
);

always begin 
    #1;
    clk =~ clk; // Toggle the clock
end

initial begin
    $dumpfile("build/spi.vcd"); // intermediate file for waveform generation
    $dumpvars(0, top_tb);       // capture all signals under top_tb
end

initial begin
    for (int i = 0; i < 6000; i = i + 1) begin
        spi_in = i % 3 == 0;
        #2;
    end

    $finish;            // end simulation, otherwise it runs indefinitely
end

endmodule
