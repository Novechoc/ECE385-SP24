module world_map(
    input logic Reset,
    output logic [28:0] info_ground[16]
    );

    initial begin
        info_ground[0][9:0] = 0; //x_start
        info_ground[0][18:10] = 410; //y_loc
        info_ground[0][28:19] = 639; //length

        info_ground[1][9:0] = 500;
        info_ground[1][18:10] = 310;
        info_ground[1][28:19] = 139;

        info_ground[2][9:0] = 70;
        info_ground[2][18:10] = 200;
        info_ground[2][28:19] = 220;

        info_ground[3][9:0] = 320;
        info_ground[3][18:10] = 250;
        info_ground[3][28:19] = 40;
    end

endmodule