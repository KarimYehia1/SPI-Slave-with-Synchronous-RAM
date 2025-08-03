module spi_wrapper(MOSI, MISO, SS_n, clk, rst_n);
input MOSI, SS_n, clk, rst_n;
output MISO;

wire [9:0] rx_data;
wire [7:0] tx_data;
wire rx_valid, tx_valid;

spi_slave spi(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_data, rx_valid);
synch_ram ram(clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
endmodule