module world_map_0(
    input logic Reset, Clk,
    output logic [28:0] info_ground[16],
    output logic [28:0] info_fence[16],
    output logic [9:0] info_exit[2],
    output logic [20:0] info_spince[6]
    );

initial begin
        info_ground[0][9:0] = 0; // x_start
        info_ground[0][18:10] = 400; // y_loc
        info_ground[0][28:19] = 60; // length

        info_ground[1][9:0] = 200;
        info_ground[1][18:10] = 350;
        info_ground[1][28:19] = 80;
        
        info_ground[2][9:0] = 300;
        info_ground[2][18:10] = 280;
        info_ground[2][28:19] = 80;

        info_ground[3][9:0] = 410;
        info_ground[3][18:10] = 220;
        info_ground[3][28:19] = 100;

        info_ground[4][9:0] = 520;
        info_ground[4][18:10] = 150;
        info_ground[4][28:19] = 120;
        
        info_ground[5][9:0] = 120; // x_start
        info_ground[5][18:10] = 400; // y_loc
        info_ground[5][28:19] = 80; // length

        // Simplified fences
        info_fence[0][8:0] = 390; // y_start
        info_fence[0][18:9] = 0; // x_loc
        info_fence[0][28:19] = 200; // length

        info_fence[1][8:0] = 350; // y_start
        info_fence[1][18:9] = 200; // x_loc
        info_fence[1][28:19] = 50; // length
        
        info_fence[2][8:0] = 0; // y_start
        info_fence[2][18:9] = 639; // x_loc
        info_fence[2][28:19] = 439; // length

        // Exits
        info_exit[0] = 10'd600; // x location
        info_exit[1] = 10'd130; // y location
        
        // Spinces
        info_spince[0][9:0] = 80; //the x-axis of the center of the spince
        info_spince[0][18:10] = 395; //the y-axis of the center of the spince
        info_spince[0][20:19] = 1; //the direction of the spince 0:left 1:up 2:right 3:down

    end
    
endmodule