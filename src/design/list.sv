module generate_circle_positions;

    logic [18:0] info_location_list[28]; // Array to store 28 positions

    initial begin
        info_location_list[0][9:0] = 140; // Point 1
        info_location_list[0][18:10] = 270;  

        info_location_list[1][9:0] = 139; // Point 2
        info_location_list[1][18:10] = 266;  

        info_location_list[2][9:0] = 138; // Point 3
        info_location_list[2][18:10] = 261;  

        info_location_list[3][9:0] = 136; // Point 4
        info_location_list[3][18:10] = 258;

        info_location_list[4][9:0] = 132; // Point 5
        info_location_list[4][18:10] = 254;

        info_location_list[5][9:0] = 129; // Point 6
        info_location_list[5][18:10] = 252;

        info_location_list[6][9:0] = 124; // Point 7
        info_location_list[6][18:10] = 251;

        info_location_list[7][9:0] = 120; // Point 8
        info_location_list[7][18:10] = 250;

        info_location_list[8][9:0] = 116; // Point 9
        info_location_list[8][18:10] = 251;

        info_location_list[9][9:0] = 111; // Point 10
        info_location_list[9][18:10] = 252;

        info_location_list[10][9:0] = 108; // Point 11
        info_location_list[10][18:10] = 254;

        info_location_list[11][9:0] = 104; // Point 12
        info_location_list[11][18:10] = 258;

        info_location_list[12][9:0] = 102; // Point 13
        info_location_list[12][18:10] = 261;

        info_location_list[13][9:0] = 101; // Point 14
        info_location_list[13][18:10] = 266;

        info_location_list[14][9:0] = 100; // Point 15
        info_location_list[14][18:10] = 270;

        info_location_list[15][9:0] = 101; // Point 16
        info_location_list[15][18:10] = 274;

        info_location_list[16][9:0] = 102; // Point 17
        info_location_list[16][18:10] = 279;

        info_location_list[17][9:0] = 104; // Point 18
        info_location_list[17][18:10] = 282;

        info_location_list[18][9:0] = 108; // Point 19
        info_location_list[18][18:10] = 286;

        info_location_list[19][9:0] = 111; // Point 20
        info_location_list[19][18:10] = 288;

        info_location_list[20][9:0] = 116; // Point 21
        info_location_list[20][18:10] = 289;

        info_location_list[21][9:0] = 120; // Point 22
        info_location_list[21][18:10] = 290;

        info_location_list[22][9:0] = 124; // Point 23
        info_location_list[22][18:10] = 289;

        info_location_list[23][9:0] = 129; // Point 24
        info_location_list[23][18:10] = 288;

        info_location_list[24][9:0] = 132; // Point 25
        info_location_list[24][18:10] = 286;

        info_location_list[25][9:0] = 136; // Point 26
        info_location_list[25][18:10] = 282;

        info_location_list[26][9:0] = 138; // Point 27
        info_location_list[26][18:10] = 279;

        info_location_list[27][9:0] = 139; // Point 28
        info_location_list[27][18:10] = 274;
    end

    // This module can be instantiated or tested as needed.

endmodule
