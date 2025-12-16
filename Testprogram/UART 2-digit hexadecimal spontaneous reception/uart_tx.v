module uart_tx(
	input 			sys_clk,	//50Mϵͳʱ��
	input 			sys_rst_n,	//ϵͳ��λ
	input	[7:0] 	uart_data,	//���͵�8λ������
	input			uart_tx_en,	//����ʹ���ź�
	output reg 		uart_txd	//���ڷ���������
 
);
 
parameter 	SYS_CLK_FRE=50_000_000;    //50Mϵͳʱ�� 
parameter 	BPS=57600;                 //������9600bps���ɸ���
localparam	BPS_CNT=SYS_CLK_FRE/BPS;   //����һλ��������Ҫ��ʱ�Ӹ���
 
reg	uart_tx_en_d0;			//�Ĵ�1��
reg uart_tx_en_d1;			//�Ĵ�2��
reg tx_flag;				//���ͱ�־λ
reg [7:0]  uart_data_reg;	//�������ݼĴ���
reg [15:0] clk_cnt;			//ʱ�Ӽ�����
reg [3:0]  tx_cnt;			//���͸���������
 
wire pos_uart_en_txd;		//ʹ���źŵ�������
//��׽ʹ�ܶ˵��������źţ������־������ʼ����
assign pos_uart_en_txd= uart_tx_en_d0 && (~uart_tx_en_d1);
 
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		uart_tx_en_d0<=1'b0;
		uart_tx_en_d1<=1'b0;		
	end
	else begin
		uart_tx_en_d0<=uart_tx_en;
		uart_tx_en_d1<=uart_tx_en_d0;
	end	
end
//������ʹ�ܶ˵��������źţ���ߴ��俪ʼ��־λ�����ڵ�9�����ݣ���ֹλ���Ĵ����������У����ݱȽ��ȶ����ٽ����俪ʼ��־λ��ͣ���־��������
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		tx_flag<=1'b0;
		uart_data_reg<=8'd0;
	end
	else if(pos_uart_en_txd)begin
		uart_data_reg<=uart_data;
		tx_flag<=1'b1;
	end
	else if((tx_cnt==4'd9) && (clk_cnt==BPS_CNT/2))begin//�ڵ�9�����ݣ���ֹλ���Ĵ����������У����ݱȽ��ȶ����ٽ����俪ʼ��־λ��ͣ���־��������
		tx_flag<=1'b0;
		uart_data_reg<=8'd0;
	end
	else begin
		uart_data_reg<=uart_data_reg;
		tx_flag<=tx_flag;	
	end
end
//ʱ��ÿ����һ��BPS_CNT������һλ��������Ҫ��ʱ�Ӹ��������������ݼ�������1��������ʱ�Ӽ�����
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		clk_cnt<=16'd0;
		tx_cnt <=4'd0;
	end
	else if(tx_flag) begin
		if(clk_cnt<BPS_CNT-1)begin
			clk_cnt<=clk_cnt+1'b1;
			tx_cnt <=tx_cnt;
		end
		else begin
			clk_cnt<=16'd0;
			tx_cnt <=tx_cnt+1'b1;
		end
	end
	else begin
		clk_cnt<=16'd0;
		tx_cnt<=4'd0;
	end
end
//��ÿ�����ݵĴ����������У����ݱȽ��ȶ��������ݼĴ��������ݸ�ֵ��������
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		uart_txd<=1'b1;
	else if(tx_flag)
		case(tx_cnt)
			4'd0:	uart_txd<=1'b0;
			4'd1:	uart_txd<=uart_data_reg[0];
			4'd2:	uart_txd<=uart_data_reg[1];
			4'd3:	uart_txd<=uart_data_reg[2];
			4'd4:	uart_txd<=uart_data_reg[3];
			4'd5:	uart_txd<=uart_data_reg[4];
			4'd6:	uart_txd<=uart_data_reg[5];
			4'd7:	uart_txd<=uart_data_reg[6];
			4'd8:	uart_txd<=uart_data_reg[7];
			4'd9:	uart_txd<=1'b1;
			default:;
		endcase
	else 	
		uart_txd<=1'b1;
end
endmodule
