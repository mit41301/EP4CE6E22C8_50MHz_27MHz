module	led
(
input	wire	key_1,
input	wire	key_2,
input	wire	key_3,
input	wire	key_4,
input	wire	key_5,

output	wire	led_1,
output	wire	led_2,
output	wire	led_3,
output	wire	led_4,
output	wire	led_5
);
assign	led_1=key_1;
assign	led_2=key_2;
assign	led_3=key_3;
assign	led_4=key_4;
assign	led_5=key_5;
endmodule     