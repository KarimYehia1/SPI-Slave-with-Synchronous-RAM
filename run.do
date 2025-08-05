vlib work
vlog spi_tb.v
vlog spi_interface.v
vlog ram.v
vlog spi_wrapper.v
vsim -voptargs=+acc work.SPI_TB
add wave -position insertpoint  \
sim:/SPI_TB/MOSI \
sim:/SPI_TB/SS_n \
sim:/SPI_TB/clk \
sim:/SPI_TB/rst_n \
sim:/SPI_TB/MISO \
sim:/SPI_TB/data_to_be_relayed \
sim:/SPI_TB/address \
sim:/SPI_TB/actual_data_in
add wave -position insertpoint  \
sim:/SPI_TB/k2/spi/cs \
sim:/SPI_TB/k2/spi/ns
add wave -position insertpoint  \
sim:/SPI_TB/k2/ram/mem
run -all
#quit -sim
