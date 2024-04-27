module world_map(
    input logic Reset,
    output logic [28:0] info_ground[16],
    output logic [28:0] info_fence[16],
    output logic [28:0] info_exit[16]
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
        info_ground[2][28:19] = 80;

        info_ground[3][9:0] = 420;
        info_ground[3][18:10] = 250;
        info_ground[3][28:19] = 40;

        info_ground[4][9:0] = 280;
        info_ground[4][18:10] = 180;
        info_ground[4][28:19] = 50;

        info_ground[5][9:0] = 550;
        info_ground[5][18:10] = 260;
        info_ground[5][28:19] = 89;

        info_ground[6][9:0] = 120;
        info_ground[6][18:10] = 140;
        info_ground[6][28:19] = 50;

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
        
        info_exit[0][8:0] = 2;
        info_exit[0][18:9] = 2;
        info_exit[0][28:19] = 35;

        
    end

endmodule