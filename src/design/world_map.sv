module world_map(
    input logic Reset, Clk,
    input logic [9:0] BallX,
    output logic [28:0] info_ground[16],
    output logic [28:0] info_fence[16],
    output logic [9:0] info_exit[2],
    output logic [20:0] info_spince[6],
    output logic [20:0] info_monster
    );

    initial begin
        info_ground[0][9:0] = 0; //x_start
        info_ground[0][18:10] = 430; //y_loc
        info_ground[0][28:19] = 639; //length

        info_ground[1][9:0] = 100;
        info_ground[1][18:10] = 380;
        info_ground[1][28:19] = 120;

        info_ground[2][9:0] = 240;
        info_ground[2][18:10] = 320;
        info_ground[2][28:19] = 90;

        info_ground[3][9:0] = 365;
        info_ground[3][18:10] = 265;
        info_ground[3][28:19] = 45;

        info_ground[7][9:0] = 460;
        info_ground[7][18:10] = 230;
        info_ground[7][28:19] = 40;

        info_ground[4][9:0] = 370;
        info_ground[4][18:10] = 160;
        info_ground[4][28:19] = 50;

        info_ground[5][9:0] = 550; // right most one
        info_ground[5][18:10] = 260;
        info_ground[5][28:19] = 89;

        // info_ground[9][9:0] = 240;      //maybe special(middle)
        // info_ground[9][18:10] = 135;
        // info_ground[9][28:19] = 60;

        info_ground[6][9:0] = 105;
        info_ground[6][18:10] = 110;
        info_ground[6][28:19] = 60;

        info_ground[8][9:0] = 0;   // door 
        info_ground[8][18:10] = 42;
        info_ground[8][28:19] = 50;


        info_fence[0][8:0] = 382; //y_start
        info_fence[0][18:9] = 102; //x_loc
        info_fence[0][28:19] = 48; //length

        info_fence[1][8:0] = 262; //y_start
        info_fence[1][18:9] = 552; //x_loc
        info_fence[1][28:19] = 168; //length

        info_fence[2][8:0] = 0; //y_start
        info_fence[2][18:9] = 0; //x_loc
        info_fence[2][28:19] = 479; //length

        info_fence[3][8:0] = 0; //y_start
        info_fence[3][18:9] = 639; //x_loc
        info_fence[3][28:19] = 479; //length
        
        info_fence[4][8:0] = 382; //y_start
        info_fence[4][18:9] = 219; //x_loc
        info_fence[4][28:19] = 48; //length

        info_exit[0] = 20; // x location
        info_exit[1] = 20; // y location

        info_spince[0][9:0] = 60; //the x-axis of the center of the spince
        info_spince[0][18:10] = 420; //the y-axis of the center of the spince
        info_spince[0][20:19] = 1; //the direction of the spince 0:left 1:up 2:right 3:down

        info_spince[1][9:0] = 260; //the x-axis of the center of the spince
        info_spince[1][18:10] = 420; //the y-axis of the center of the spince
        info_spince[1][20:19] = 1; //the direction of the spince 0:left 1:up 2:right 3:down

        info_spince[2][9:0] = 160; //the x-axis of the center of the spince
        info_spince[2][18:10] = 370; //the y-axis of the center of the spince
        info_spince[2][20:19] = 1; //the direction of the spince 0:left 1:up 2:right 3:down

        info_monster[9:0] = 590; // x location
        info_monster[19:10] = 210; // y location
        info_monster[20] = 1; // enable


    end


    logic [9:0] special_ground_speed;
    logic reach_left, reach_right;
    always_ff @(posedge Clk or posedge Reset) begin
        if(Reset == 1'b1) begin
        special_ground_speed <= 10'd0;
        reach_left <= 0;
        reach_right <= 0;
        info_ground[9][9:0] <= 180;      //maybe special
        info_ground[9][18:10] <= 135;
        info_ground[9][28:19] <= 60;
        end
        else begin
            if(info_ground[9][9:0] <=180) begin
                reach_left <= 1;
                reach_right <= 0;
            end
            else if(info_ground[9][9:0] >= 305) begin
                reach_right <= 1;
                reach_left <= 0;
            end
            else begin
                reach_left <= reach_left;
                reach_right <= reach_right;
            end

            if(reach_left == 1) begin
                special_ground_speed <= 1;
                info_ground[9][9:0] <= info_ground[9][9:0] + special_ground_speed;
            end
            else begin
                special_ground_speed <= 1;
                info_ground[9][9:0] <= info_ground[9][9:0] - special_ground_speed;
            end
        end
    
    end

endmodule