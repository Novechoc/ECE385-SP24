module world_map_0(
    input logic Reset, Clk,
    output logic [28:0] info_ground[16],
    input logic [9:0] BallX,BallY,
    input logic monster_exist,
    output logic [28:0] info_fence[16],
    output logic [9:0] info_exit[2],
    output logic [20:0] info_spince[6],
    output logic [20:0] info_monster
    );

initial begin
        info_ground[0][9:0] = 0; // x_start
        info_ground[0][18:10] = 400; // y_loc
        info_ground[0][28:19] = 60; // length

        info_ground[1][9:0] = 200;
        info_ground[1][18:10] = 350;  //may be special
        info_ground[1][28:19] = 80;
        
        info_ground[2][9:0] = 300;
        info_ground[2][18:10] = 280;
        info_ground[2][28:19] = 80; 

        info_ground[3][9:0] = 410;
        info_ground[3][18:10] = 220; //show a spince
        info_ground[3][28:19] = 120;

        info_ground[4][9:0] = 540;
        info_ground[4][18:10] = 150;
        info_ground[4][28:19] = 120;
        
        info_ground[5][9:0] = 100; // x_start
        info_ground[5][18:10] = 400; // y_loc
        info_ground[5][28:19] = 98; // length

        // Simplified fences
        info_fence[0][8:0] = 0; // y_start
        info_fence[0][18:9] = 0; // x_loc
        info_fence[0][28:19] = 439; // length

        info_fence[1][8:0] = 350; // y_start
        info_fence[1][18:9] = 200; // x_loc
        info_fence[1][28:19] = 52; // length
        
        info_fence[2][8:0] = 0; // y_start
        info_fence[2][18:9] = 639; // x_loc
        info_fence[2][28:19] = 439; // length

        // Exits
        info_exit[0] = 10'd600; // x location
        info_exit[1] = 10'd130; // y location
        
        // Spinces
        info_spince[0][9:0] = 80; //the x-axis of the center of the spince
        info_spince[0][18:10] = 400; //the y-axis of the center of the spince
        info_spince[0][20:19] = 1; //the direction of the spince 0:left 1:up 2:right 3:down

        // info_spince[1][9:0] = ; //the x-axis of the center of the spince
        // info_spince[1][18:10] = 395; //the y-axis of the center of the spince
        // info_spince[1][20:19] = 1; //the direction of the spince 0:left 1:up 2:right 3:down

        info_monster[20] = 0; //disables the monster
end

    always_ff @(posedge Clk) begin
        if (Reset) begin
            info_ground[1][9:0] = 200;
            info_ground[1][18:10] = 350;  //may be special
            info_ground[1][28:19] = 80;
            
            info_spince[1][9:0] = 460; 
            info_spince[1][18:10] = 230; 
            info_spince[1][20:19] = 1; 
        end
        else begin
            if(BallX > 273) begin
                info_ground[1][9:0] = 0;
                info_ground[1][18:10] = 0;  //may be special
                info_ground[1][28:19] = 0;
            end
            else begin
                info_ground[1][9:0] = 200;
                info_ground[1][18:10] = 350;  //may be special
                info_ground[1][28:19] = 80;
            end
            if(BallX > 420)begin
                info_spince[1][9:0] = 460; 
                info_spince[1][18:10] = 210; 
                info_spince[1][20:19] = 1; 
            end
            else begin
                info_spince[1][9:0] = 460; 
                info_spince[1][18:10] = 230; 
                info_spince[1][20:19] = 1; 
            end
        end
    end

endmodule