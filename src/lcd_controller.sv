module lcd_controller
(
    input wire clk, // FPGA's clock

    // The data that's read from memory
    input wire [15:0] pixel,
    // The address to read from memory
    output logic [7:0] pixel_address, 

	output wire lcd_clk, // LCD clock. 
	output wire lcd_den,
	output logic[4:0] lcd_r,
	output logic[5:0] lcd_g,
	output logic[4:0] lcd_b
);

// The number of columns of pixels (width of the display)
parameter COLUMNS = 480;
// The size of the horizontal buffer
parameter COL_BUFFER = 45;

// The number of rows of pixels (height of the display)
parameter ROWS = 272;
// The size of the vertical buffer
parameter ROW_BUFFER = 13;

// Vertical position. Max value is COLUMNS + COL_BUFFER - 1. Min value is 0.
logic[8:0] cur_row = 0;
// Horizontal position. Max value is ROWS + ROW_BUFFER - 1. Min value is 0.
logic[9:0] cur_col = 0;

always @(posedge clk) begin
    // Scan from left to right
    if (cur_col < COLUMNS + COL_BUFFER - 1) begin
        cur_col <= cur_col + 1;
    end
    // Move to the next row
    else begin
        cur_col <= 0;
        if (cur_row < ROWS + ROW_BUFFER - 1) begin
            cur_row <= cur_row + 1;
        end else begin
            cur_row <= 0;
        end
    end

    // Sprite column = cur_col % 16
    // Sprite row = cur_row % 16
    pixel_address <= (cur_col % 16) + 16*(cur_row %16);

    lcd_r <= (pixel >> 11);
    lcd_g <= (pixel >> 5) & 6'b111111;
    lcd_b <= (pixel) & 5'b11111;
end

assign lcd_den = (cur_row < ROWS) && (cur_col < COLUMNS);

assign lcd_clk = ~clk;

endmodule 