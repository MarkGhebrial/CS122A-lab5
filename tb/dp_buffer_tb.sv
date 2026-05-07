`include "src/dp_buffer.sv"
`timescale 1ns/1ps

module top_tb;

logic clk = 0;
logic we = 0;
logic[7:0] waddr = 0;
logic[15:0] wdata = 0;
logic[7:0] raddr = 16;
wire[15:0] rdata;

// Unit under test
dp_buffer uut
(
    .clk(clk),
    .we(we),
    .waddr(waddr),
    .wdata(wdata),
    .raddr(raddr),
    .rdata(rdata)
);

always begin 
    #1;
    clk =~ clk; // Toggle the clock
end

initial begin
    $dumpfile("build/dp_buffer.vcd"); // intermediate file for waveform generation
    $dumpvars(0, top_tb);       // capture all signals under top_tb
end

initial begin
    // Write data to the memory
    for (int i = 0; i < 256; i = i + 1) begin
        // Set the write address
        waddr = i;
        // Set the write data
        wdata = i * 2;
        // Set write enable
        we = 1;

        #2; // Wait for a clock cycle, then disable write enable
        we = 0;

        // Do nothing for a bit
        #10;
    end

    for (int i = 0; i < 256; i = i + 1) begin
        // Set the read address
        raddr = i;
        // Wait for a clock cycle
        #2;
        // Verify that the returned data is correct
        if (rdata != i * 2) $error("fail");

        // Do nothing for a bit
        #10;
    end

    $finish;
end

endmodule
