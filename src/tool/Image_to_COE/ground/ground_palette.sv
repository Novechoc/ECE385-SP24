module ground_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'hC, 4'hC, 4'hC},
	{4'hC, 4'hC, 4'hC},
	{4'hA, 4'hA, 4'hA},
	{4'hB, 4'hB, 4'hB},
	{4'hB, 4'hB, 4'hB},
	{4'hC, 4'hC, 4'hC},
	{4'hC, 4'hC, 4'hC},
	{4'hA, 4'hA, 4'hA},
	{4'hB, 4'hB, 4'hB},
	{4'hC, 4'hC, 4'hC},
	{4'hC, 4'hC, 4'hC},
	{4'hC, 4'hC, 4'hC},
	{4'hC, 4'hC, 4'hC},
	{4'hC, 4'hB, 4'hB},
	{4'hC, 4'hC, 4'hC},
	{4'hC, 4'hC, 4'hC}
};

assign {red, green, blue} = palette[index];

endmodule
