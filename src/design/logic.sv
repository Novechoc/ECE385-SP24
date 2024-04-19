module logic_block
(
    input logic pixel_clk,
    input logic reset,
    input logic [9:0]  BallX, 
    input logic [9:0]  BallY,
    input logic [9:0]  BallS,
    input logic [28:0] info_ground[16],
    input logic go_up,
    output logic logic_in_air,
    output logic touch_down, touch_up,
    output logic [9:0] touch_down_position_y,
    output logic [9:0] touch_up_position_y
);

logic [9:0] x_start;
logic [9:0] y_loc;
logic [9:0] length;

always_comb begin
    // determine if the ball is in the air
    logic_in_air = 1;
    for (int i = 0; i < 16; i = i + 1) begin
        x_start = info_ground[i][9:0];
        y_loc = info_ground[i][18:10];
        length = info_ground[i][28:19];
        if (BallY + BallS == y_loc && ((BallX - BallS <= x_start + length) && (BallX + BallS >= x_start))) begin //y_loc may need to be directly referenced
            logic_in_air = 0;
        end
        else if(BallY + BallS == 479) begin
            logic_in_air = 0;
        end
    end

    // determine if the ball is touching the ground
    touch_down = 0;
    touch_up = 0;
    for (int i = 0; i < 16; i = i + 1) begin
        x_start = info_ground[i][9:0];
        y_loc = info_ground[i][18:10];
        length = info_ground[i][28:19];
        if ((BallX - BallS <= x_start + length) && (BallX + BallS >= x_start)) begin
            if ((BallY + BallS > y_loc) && (BallY - BallS < y_loc)) begin
                if ((BallY <= y_loc + 4 * BallS / 5) && go_up == 0) begin
                    touch_down = 1;
                    touch_down_position_y = y_loc - BallS;
                end
                else if (go_up == 1) begin
                    touch_up = 1;
                    touch_up_position_y = y_loc + BallS;
                end
            end
        end
    end
    
end

endmodule