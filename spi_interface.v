module spi_slave(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_data, rx_valid);
input MOSI, SS_n, tx_valid, clk, rst_n;
input [7:0] tx_data;
output reg MISO, rx_valid;
output reg [9:0] rx_data;

parameter IDLE = 0, WRITE = 1, CHK_CMD = 2, READ_ADD = 3, READ_DATA = 4;

(* fsm_encoding = "sequential" *)
reg [2:0] cs, ns;
reg [3:0] rx_counter;
reg [2:0] tx_counter;
reg address_read;

// Next state memory
always @(posedge clk) begin
    if(!rst_n) begin
      cs <= IDLE;
      rx_counter <= 0;
      tx_counter <= 0;
      address_read <= 0;
      rx_valid <= 0;
      rx_data <= 0;
      MISO <= 0;
    end
    else begin
        cs <= ns;
    end
end

// Next state logic
always @(*) begin
    case (cs)
        IDLE: begin
          if(!SS_n) begin
            ns = CHK_CMD;
          end
          else begin
            ns = IDLE;
          end
        end
        CHK_CMD: begin
          if(!SS_n && !MOSI) begin
            ns = WRITE;
          end
          else if(!SS_n && MOSI) begin
            if(address_read) 
              ns = READ_DATA;
            else
              ns = READ_ADD;
          end
          else 
            ns = IDLE;
        end
        WRITE: begin
          if(SS_n)
            ns = IDLE;
          else
            ns = WRITE;
        end
        READ_ADD: begin
          if(SS_n)
            ns = IDLE;
          else
            ns = READ_ADD;        
        end
        READ_DATA: begin
          if(SS_n)
            ns = IDLE;
          else
            ns = READ_DATA;          
        end
    endcase
end

// output logic
always @(posedge clk) begin
    if(cs == WRITE ) begin
    rx_counter <= rx_counter + 1;
    rx_data <= {rx_data[8:0], MOSI};
    if(rx_counter == 9) begin
      rx_valid <= 1;
      rx_counter <= 0;
    end
    else begin
      rx_valid <= 0;
    end
    end
    else if(cs == READ_ADD) begin
      rx_counter <= rx_counter + 1;
      rx_data <= {rx_data[8:0], MOSI};
      if(rx_counter == 9) begin
        rx_counter <= 0;
        rx_valid <= 1;
        address_read <= 1;
    end
    else begin
      rx_valid <= 0;
    end
    end
    else if(cs == READ_DATA) begin
    rx_counter <= rx_counter + 1;
    rx_data <= {rx_data[8:0], MOSI};
    if(rx_counter == 9) begin
      rx_counter <= 0;
      rx_valid <= 1;
      address_read <= 0;
    end
    else begin
      rx_valid <= 0;
    end

    if(tx_valid) begin
      MISO <= tx_data[7 - tx_counter];
      tx_counter <= tx_counter + 1;
    end
    else begin
        MISO <= 0;
        tx_counter <= 0;
    end
end

else begin
  rx_counter <= 0;
  tx_counter <= 0;
  rx_valid <= 0;
  MISO <= 0;
end
end


endmodule