module spince_rom (
	input logic clock,
	input logic [7:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:149] /* synthesis ram_init_file = "./spince/spince.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
