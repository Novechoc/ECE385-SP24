module world_selector
(
    input logic Reset, Clk,
    input [1:0] selector_value,

    input logic [28:0] info_ground_0[16],
    input logic [28:0] info_fence_0[16],
    input logic [9:0] info_exit_0[2],
    input logic [20:0] info_spince_0[6],

    input logic [28:0] info_ground_1[16],
    input logic [28:0] info_fence_1[16],
    input logic [9:0] info_exit_1[2],
    input logic [20:0] info_spince_1[6],

    output logic [28:0] info_ground[16],
    output logic [28:0] info_fence[16],
    output logic [9:0] info_exit[2],
    output logic [20:0] info_spince[6]
);

    always_comb begin
        if (selector_value == 2'b00) begin
            info_ground = info_ground_0;
            info_fence = info_fence_0;
            info_exit = info_exit_0;
            info_spince = info_spince_0;
        end
        else if (selector_value == 2'b01) begin
            info_ground = info_ground_1;
            info_fence = info_fence_1;
            info_exit = info_exit_1;
            info_spince = info_spince_1;
        end
    end

endmodule