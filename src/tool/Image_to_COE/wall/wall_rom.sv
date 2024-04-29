module wall_rom (
	input logic clock,
	input logic [6:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:74] /* synthesis ram_init_file = "./wall/wall.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
