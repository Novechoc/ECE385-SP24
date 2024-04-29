module door_rom (
	input logic clock,
	input logic [10:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:1599] /* synthesis ram_init_file = "./door/door.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
