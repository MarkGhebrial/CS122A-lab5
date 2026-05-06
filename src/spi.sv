module spi_rx(
    // Input Ports
    input logic sck,
    input logic in,

    // Write enable
    output logic we = 0,
    // Write address
    output logic[7:0] waddr = 0,
    // Write data
    output logic[15:0] wdata
);

// Keeps track of how many bits we've received
logic[8:0] count = 0;

// Shift the input into the shift register
always @(posedge sck) begin
    wdata <= {wdata[14:0], in};
    
    if (we == 1) begin
        // Reset the write enable pin
        we <= 0;
        // Move to the next address
        if (waddr < 255) begin
            waddr <= waddr + 1;
        end else begin
            waddr <= 0;
        end
    end

    if (count < 15) begin
        // Increment the counter
        count <= count + 1;
    end else begin
        // Reset the counter
        count <= 0;
        // Set the write enable to be high
        we <= 1;
    end
end

endmodule