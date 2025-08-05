vlib work
vlog SPI_TB_2.v
vlog spi_interface.v
vlog ram.v
vlog spi_wrapper.v
vsim -voptargs=+acc work.SPI_TB
add wave *
add wave -position insertpoint sim:/SPI_TB/k2/ram/*
add wave -position insertpoint  \
sim:/SPI_TB/k2/spi/address_read
run -all
#quit -sim