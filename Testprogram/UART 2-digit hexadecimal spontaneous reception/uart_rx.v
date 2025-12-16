module uart_rx(
	input 			sys_clk,			//50Mϵͳʱ��
	input 			sys_rst_n,			//ϵͳ��λ
	input 			uart_rxd,			//����������
	output reg 		uart_rx_done,		//���ݽ������ɱ�־
	output reg [7:0]uart_rx_data		//���յ�������
);
//����������ʣ��ɸ���
parameter	BPS=57600;					//������9600bps���ɸ���
parameter	SYS_CLK_FRE=50_000_000;		//50Mϵͳʱ��
localparam	BPS_CNT=SYS_CLK_FRE/BPS;	//����һλ��������Ҫ��ʱ�Ӹ���
 
reg 			uart_rx_d0;		//�Ĵ�1��
reg 			uart_rx_d1;		//�Ĵ�2��
reg [15:0]		clk_cnt;				//ʱ�Ӽ�����
reg [3:0]		rx_cnt;					//���ռ�����
reg 			rx_flag;				//���ձ�־λ
reg [7:0]		uart_rx_data_reg;		//���ݼĴ�
	
wire 			neg_uart_rx_data;		//���ݵ��½���
 
assign	neg_uart_rx_data=uart_rx_d1 & (~uart_rx_d0);  //���������ߵ��½��أ������־���ݴ��俪ʼ
//�������ߴ���ģ�����1��ͬ����ͬʱ�����źţ���ֹ����̬������2�����Բ����½���
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		uart_rx_d0<=1'b0;
		uart_rx_d1<=1'b0;
	end
	else begin
		uart_rx_d0<=uart_rxd;
		uart_rx_d1<=uart_rx_d0;
	end		
end
//�����������½��أ���ʼλ0��������ߴ��俪ʼ��־λ�����ڵ�9�����ݣ���ֹλ���Ĵ����������У����ݱȽ��ȶ����ٽ����俪ʼ��־λ��ͣ���־��������
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		rx_flag<=1'b0;
	else begin 
		if(neg_uart_rx_data)
			rx_flag<=1'b1;
		else if((rx_cnt==4'd9)&&(clk_cnt==BPS_CNT/2))//�ڵ�9�����ݣ���ֹλ���Ĵ����������У����ݱȽ��ȶ����ٽ����俪ʼ��־λ��ͣ���־��������
			rx_flag<=1'b0;
		else 
			rx_flag<=rx_flag;			
	end
end
//ʱ��ÿ����һ��BPS_CNT������һλ��������Ҫ��ʱ�Ӹ��������������ݼ�������1��������ʱ�Ӽ�����
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		rx_cnt<=4'd0;
		clk_cnt<=16'd0;
	end
	else if(rx_flag)begin
		if(clk_cnt<BPS_CNT-1'b1)begin
			clk_cnt<=clk_cnt+1'b1;
			rx_cnt<=rx_cnt;
		end
		else begin
			clk_cnt<=16'd0;
			rx_cnt<=rx_cnt+1'b1;
		end
	end
	else begin
		rx_cnt<=4'd0;
		clk_cnt<=16'd0;
	end		
end
//��ÿ�����ݵĴ����������У����ݱȽ��ȶ������������ϵ����ݸ�ֵ�����ݼĴ���
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_rx_data_reg<=8'd0;
	else if(rx_flag)
		if(clk_cnt==BPS_CNT/2) begin
			case(rx_cnt)			
				4'd1:uart_rx_data_reg[0]<=uart_rxd;
				4'd2:uart_rx_data_reg[1]<=uart_rxd;
				4'd3:uart_rx_data_reg[2]<=uart_rxd;
				4'd4:uart_rx_data_reg[3]<=uart_rxd;
				4'd5:uart_rx_data_reg[4]<=uart_rxd;
				4'd6:uart_rx_data_reg[5]<=uart_rxd;
				4'd7:uart_rx_data_reg[6]<=uart_rxd;
				4'd8:uart_rx_data_reg[7]<=uart_rxd;
				default:;
			endcase
		end
		else
			uart_rx_data_reg<=uart_rx_data_reg;
	else
		uart_rx_data_reg<=8'd0;
end	
//�����ݴ��䵽��ֹλʱ����ߴ������ɱ�־λ��������������
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		uart_rx_done<=1'b0;
		uart_rx_data<=8'd0;
	end	
	else if(rx_cnt==4'd9)begin
		uart_rx_done<=1'b1;
		uart_rx_data<=uart_rx_data_reg;
	end		
	else begin
		uart_rx_done<=1'b0;
		uart_rx_data<=8'd0;
	end
end
endmodule
