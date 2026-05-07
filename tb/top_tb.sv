`include "src/top.sv"
`timescale 1ns/1ps

module top_tb;

logic clk = 0;
logic sck = 0;
logic spi_in = 0;

wire lcd_clk;
wire lcd_den;
wire[4:0] lcd_r;
wire[5:0] lcd_g;
wire[4:0] lcd_b;

// Unit under test
top uut
(
    .CLK(clk),

    .SCK(sck),
    .SPI_IN(spi_in),

    .LCD_CLK(lcd_clk),
    .LCD_DEN(lcd_den),
    .LCD_R(lcd_r),
    .LCD_G(lcd_g),
    .LCD_B(lcd_b)
);

always begin 
    #1;
    clk =~ clk; // Toggle the clock
end

initial begin
    $dumpfile("build/top.vcd"); // intermediate file for waveform generation
    $dumpvars(0, top_tb);       // capture all signals under top_tb
end

initial begin
    // Send some pixel data over SPI
    for (int i = 0; i < 256; i = i + 1) begin
        parameter[15:0] word = 16'hBEEF;
        for (int j = 0; j < 16; j = j + 1) begin
            // spi_in = j % 3 == 0;
            spi_in = word[15-j];
     
            // Tick the spi clock
            sck = 1;
            #1;
            sck = 0;
            #1;
        end

    end

    for (int i = 0; i < 150000; i = i + 1) begin
        #2;
    end

    $finish;
end

endmodule
