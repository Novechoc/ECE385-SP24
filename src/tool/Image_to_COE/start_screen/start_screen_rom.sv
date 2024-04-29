module start_screen_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [1:0] q
);

logic [1:0] memory [0:76799] /* synthesis ram_init_file = "./start_screen/start_screen.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
