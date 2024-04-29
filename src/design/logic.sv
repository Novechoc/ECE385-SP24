module logic_block
(
    input logic pixel_clk,
    input logic reset,
    input logic [9:0]  BallX, KnifeX, 
    input logic [9:0]  BallY, KnifeY,
    input logic [9:0]  BallS, KnifeS,
    input logic [28:0] info_ground[16],
    input logic [28:0] info_fence[16],
    input logic [9:0]  info_exit[2],
    input logic [20:0] info_spince[6],
    input logic go_up, go_left, go_right,
    output logic logic_in_air, win_the_game, lose_the_game,
    output logic touch_down, touch_up, touch_left, touch_right, knife_touch_fence,
    output logic [9:0] touch_down_position_y, touch_left_position_x, 
    output logic [9:0] touch_up_position_y, touch_right_position_x
);

logic [9:0] x_start, y_start;
logic [9:0] y_loc, x_loc;
logic [9:0] length_ground, length_fence;
logic [9:0] spinceX, spinceY;
always_comb begin
    // determine if the ball is in the air
    logic_in_air = 1;
    for (int i = 0; i < 16; i = i + 1) begin
        x_start = info_ground[i][9:0];
        y_loc = info_ground[i][18:10];
        length_ground = info_ground[i][28:19];
        if (BallY + BallS == y_loc && ((BallX - BallS <= x_start + length_ground) && (BallX + BallS >= x_start))) begin //y_loc may need to be directly referenced
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
        length_ground = info_ground[i][28:19];
        if ((BallX - 4*BallS/5<= x_start + length_ground) && (BallX + 4*BallS/5 >= x_start)) begin
            if ((BallY + BallS> y_loc) && (BallY - BallS < y_loc)) begin
                if ((BallY <= y_loc + 2 * BallS / 5) && go_up == 0) begin //3
                    touch_down = 1;
                    touch_down_position_y = y_loc - BallS;
                end
                else begin
                    touch_up = 1;
                    touch_up_position_y = y_loc + BallS;
                end
            end
        end
    end

    // determine if the ball is touching the fence
    touch_right = 0;
    touch_left = 0;
    for (int j = 0; j < 16; j = j + 1) begin
        y_start = info_fence[j][8:0];
        x_loc = info_fence[j][18:9];
        length_fence = info_fence[j][28:19];
        if ((BallY - 4*BallS/5 <= y_start + length_fence) && (BallY + 4*BallS/5 >= y_start)) begin
            if ((BallX + BallS > x_loc) && (BallX - BallS < x_loc)) begin
                if ((BallX <= x_loc + 6 * BallS / 7) && go_left == 0) begin
                    touch_right = 1;
                    touch_right_position_x = x_loc - BallS;
                end
                else begin
                    touch_left = 1;
                    touch_left_position_x = x_loc + BallS;
                end
            end
        end
    end
    // determine if the knife is touching the fence
    knife_touch_fence = 0;
    for (int j = 0; j < 16; j = j + 1) begin
        y_start = info_fence[j][8:0];
        x_loc = info_fence[j][18:9];
        length_fence = info_fence[j][28:19];
        if ((KnifeY - KnifeS <= y_start + length_fence) && (KnifeY + KnifeS >= y_start)) begin
            if ((KnifeX + KnifeS > x_loc) && (KnifeX - KnifeS < x_loc)) begin
                knife_touch_fence = 1;
            end
        end
    end
// determine if the ball is touching the exit
    win_the_game = 0;
    if((BallX  >= info_exit[0]-10) && (BallX <= info_exit[0]+10) 
    && (BallY>= info_exit[1]-20) && (BallY <= info_exit[1]+20)) begin
        win_the_game = 1;
    end
// determine if the ball lose the game
    lose_the_game = 0;
    if(BallY > 479) begin
        lose_the_game = 1;
    end 
    for(int i = 0; i<6; i=i+1) begin
        spinceX = info_spince[i][9:0];
        spinceY = info_spince[i][18:10];
        if ((BallX-BallS <= 2+spinceX)&&(BallX+BallS >=spinceX-2)
        &&  (BallY-BallS <= spinceY+1)&&(BallY+BallS>=spinceY-1)) begin
            lose_the_game = 1;
        end
    end
end

endmodule