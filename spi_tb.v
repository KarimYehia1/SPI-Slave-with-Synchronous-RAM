module SPI_TB();
reg MOSI, SS_n, clk, rst_n;
wire MISO;
reg [9:0]data_to_be_relayed;//either the address or the actual data itself
reg [7:0]data_read_from_RAM;
reg [7:0]address=8'b0000011;
reg [7:0]actual_data_in=8'b10110111;
spi_wrapper k2(MOSI, MISO, SS_n, clk, rst_n);
initial begin
	clk=0;
	forever
	#1
	clk=~clk;
end
integer i;
initial begin
	/*Reset & Initiate Communication*/
	rst_n=0;
	SS_n=1;
	@(negedge clk);
	rst_n=1;
	SS_n=0;
	/*Initiate Writing Address*/
	MOSI=0;
	data_to_be_relayed[9:8]=2'b00;
	data_to_be_relayed[7:0]=address;
	repeat(2) @(negedge clk); // one cycle cs goes from IDLE -> CHK_CMD, 2nd cycle: CHK_CMD -> WRITE
	for(i=9;i>=0;i=i-1)begin
		MOSI = data_to_be_relayed[i];
		@(negedge clk);
	end
	@(negedge clk);
	SS_n=1;
	@(negedge clk);
	/*Initiate Writing Data*/
	SS_n=0;
	MOSI=0;
	data_to_be_relayed[9:8]=2'b01;
	data_to_be_relayed[7:0]=actual_data_in;
	repeat(2) @(negedge clk); // one cycle cs goes from IDLE -> CHK_CMD, 2nd cycle: CHK_CMD -> WRITE
	for(i=9;i>=0;i=i-1)begin
		MOSI = data_to_be_relayed[i];
		@(negedge clk);
	end
	@(negedge clk);
	SS_n=1;
	@(negedge clk);
	/*Initiate Reading Address*/
	MOSI=1;
	SS_n=0;
	data_to_be_relayed[9:8]=2'b10;
	data_to_be_relayed[7:0]=address;
	repeat(2)@(negedge clk);
	for(i=9;i>=0;i=i-1)begin
		MOSI=data_to_be_relayed[i];
		@(negedge clk);
	end
	@(negedge clk);
	SS_n=1;
	@(negedge clk);
	/*Initiate Reading Data*/
	MOSI=1;
	SS_n=0;
	data_to_be_relayed[9:8]=2'b11;
	data_to_be_relayed[7:0]=address;
	repeat(2)@(negedge clk);
	for(i=9;i>=0;i=i-1)begin
		MOSI=data_to_be_relayed[i];
		@(negedge clk);
	end
	@(negedge clk);
	repeat(8) @(negedge clk);
	SS_n=1;
	@(negedge clk);
	$stop;
end
endmodule
