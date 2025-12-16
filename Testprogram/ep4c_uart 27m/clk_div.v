`timescale 1ns / 1ps
//
// Module Name:    clkdiv 
//
module clk_div(clk27, rst_n, clkout);
input clk27;              //ϵͳʱ��
input rst_n;              //���븴λ�ź�
output clkout;            //����ʱ������
reg clkout;
reg [15:0] cnt;
 

always @(posedge clk27 or negedge rst_n)   
begin
  if (!rst_n) begin
     clkout <=1'b0;
	  cnt<=0;
  end	  
  else if(cnt == 16'd162) begin
    clkout <= 1'b1;
    cnt <= cnt + 16'd1;
  end
  else if(cnt == 16'd325) begin
    clkout <= 1'b0;
    cnt <= 16'd0;
  end
  else begin
    cnt <= cnt + 16'd1;
  end
end
endmodule