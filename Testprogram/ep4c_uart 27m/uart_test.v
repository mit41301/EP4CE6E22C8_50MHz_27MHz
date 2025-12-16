module uart_test(
    i_clk,
    i_rst_n,
    rx,
    tx
    
    );
    
input   i_clk;
input   i_rst_n;
input   rx;
output  tx;
 
 
 
wire    clk_out;
wire    wrsig;
wire    idle;
wire    tx;
wire    rx;
wire    [7:0] data_in;
wire    [7:0] data_out;
wire    rdsig;
wire    data_error;
wire    frame_error;
 
clk_div u1(
    .clk27(i_clk), 
    .rst_n(i_rst_n), 
    .clkout(clk_out)
    );
       
uart_tx u2(
    .clk(clk_out), 
    .rst_n(i_rst_n), 
    .datain(data_out), 
    .wrsig(rdsig), 
    .idle(idle), 
    .tx(tx)
    );
       
uart_rx u3(
    .clk(clk_out), 
    .rst_n(i_rst_n), 
    .rx(rx), 
    .dataout(data_out), 
    .rdsig(rdsig), 
    .dataerror(data_error), 
    .frameerror(frame_error)
    );      
    
endmodule