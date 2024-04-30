//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic Clk, vde, go_left, go_right,
                       input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       input  logic [9:0] KnifeX, KnifeY, Knife_size,
                       output logic [3:0]  Red, Green, Blue,

                       input  logic [3:0] game_state,
                       
                       input  logic [28:0] info_fence[16],
                       input  logic [28:0] info_ground[16],
                       input  logic [9:0] info_exit[2],
                       input  logic [20:0] info_spince[6]);
                       
                       
    logic [3:0] Red_background;
    logic [3:0] Green_background;
    logic [3:0] Blue_background;
    
    logic [3:0] Red_start_screen;
    logic [3:0] Green_start_screen;
    logic [3:0] Blue_start_screen;

    logic [3:0] Red_win_screen;
    logic [3:0] Green_win_screen;
    logic [3:0] Blue_win_screen;
    
    logic [3:0] Red_player;
    logic [3:0] Green_player;
    logic [3:0] Blue_player;   

    logic [3:0] Red_player_reverse;
    logic [3:0] Green_player_reverse;
    logic [3:0] Blue_player_reverse;

    logic [3:0] Red_ground;
    logic [3:0] Green_ground;
    logic [3:0] Blue_ground;
    
    logic [3:0] Red_wall;
    logic [3:0] Green_wall;
    logic [3:0] Blue_wall;
       
    logic [9:0] DoorX = info_exit[0], DoorY = info_exit[1];
    logic [3:0] Red_door;
    logic [3:0] Green_door;
    logic [3:0] Blue_door;
    
    logic [9:0] spinceX, spinceY;
    logic [3:0] Red_spince;
    logic [3:0] Green_spince;
    logic [3:0] Blue_spince;     
    
    background_example background_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .blank(vde),
        .red(Red_background),
        .green(Green_background),
        .blue(Blue_background)
    );
    
    start_screen_example start_screen_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .blank(vde),
        .red(Red_start_screen),
        .green(Green_start_screen),
        .blue(Blue_start_screen)
    );
    
    win_screen_example win_screen_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .blank(vde),
        .red(Red_win_screen),
        .green(Green_win_screen),
        .blue(Blue_win_screen)
    );
    
    player_example player_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .BallX(BallX),
        .BallY(BallY),
        .blank(vde),
        .red(Red_player),
        .green(Green_player),
        .blue(Blue_player)
    );
    
    player_example_reverse player_example_reverse_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .BallX(BallX),
        .BallY(BallY),
        .blank(vde),
        .red(Red_player_reverse),
        .green(Green_player_reverse),
        .blue(Blue_player_reverse)
    );
    
    ground_example ground_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .blank(vde),
        .red(Red_ground),
        .green(Green_ground),
        .blue(Blue_ground)
    );
    
    wall_example wall_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .blank(vde),
        .red(Red_wall),
        .green(Green_wall),
        .blue(Blue_wall)
    );
    
    door_example door_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .DoorX(DoorX),
        .DoorY(DoorY),
        .blank(vde),
        .red(Red_door),
        .green(Green_door),
        .blue(Blue_door)
    );
    
    spince_example spince_example_inst(
        .vga_clk(Clk),
        .DrawX(spinceX),
        .DrawY(spinceY),
        .blank(vde),
        .red(Red_spince),
        .green(Green_spince),
        .blue(Blue_spince)
    );
    
    logic ball_on, knife_on, direction;
    logic ground_on, ground_flag, fence_on, fence_flag, exit_on, spince_on, spince_flag;
    logic [9:0] x_start, y_loc, length_ground;
    logic [9:0] y_start, x_loc, length_fence;
    logic [9:0] x_spince;
    logic [8:0] y_spince;
    logic [2:0] direction_spince;
    //logic [9:0] y_start_exit, x_loc_exit, length_exit;


    initial begin
        ball_on = 1'b0;
        ground_on = 1'b0;
        ground_flag = 1'b0;
        fence_on = 1'b0;
        fence_flag = 1'b0;
        exit_on = 1'b0;
        knife_on = 1'b0;
        direction = 1'b0;
        spince_on = 1'b0;
        spince_flag = 1'b0;

    end
	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;

    int Dist_knifeX, Dist_knifeY, Size_knife;
    assign Dist_knifeX = DrawX - KnifeX;
    assign Dist_knifeY = DrawY - KnifeY;
    assign Size_knife = Knife_size;
    
//direction
    always_ff @(posedge Clk) begin
        if (go_left == 1) begin
            direction <= 1'b1;
        end
        else if (go_right == 1) begin
            direction <= 1'b0;
        end
        else begin
            direction <= direction;
        end
    end

//ball
    always_comb
    begin:Ball_on_proc
        if ( DistX >= -14 && DistX <= 15 && DistY >= -14 && DistY <= 15 )
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
    end 

//throw knife
    always_comb
    begin:Knife_on_proc
        if ( ((Dist_knifeX*Dist_knifeX + Dist_knifeY*Dist_knifeY) <= (Size_knife * Size_knife)) &&
            (DrawY >= KnifeY +  Size_knife/2)&& (DrawY <= KnifeY +  Size_knife/2 + 3 ))
            knife_on = 1'b1;
        else 
            knife_on = 1'b0;
    end

//exit
    always_comb
    begin
        if ((DrawX >= info_exit[0] - 19) && (DrawX <= info_exit[0] + 20) && (DrawY >= info_exit[1] - 19) && (DrawY <= info_exit[1] + 20 ) ) begin
            exit_on = 1'b1;
        end
        else begin
            exit_on = 1'b0;
        end
    end 

//ground
    always_comb 
    begin
        ground_flag = 1'b0;
        if (ground_flag == 1'b0) begin
            for (int i = 0; i < 16; i = i + 1) begin
                x_start = info_ground[i][9:0];
                y_loc = info_ground[i][18:10];
                length_ground = info_ground[i][28:19];
                if ((DrawY >= y_loc - 2) && (DrawY <= y_loc + 2) && (DrawX >= x_start) && (DrawX <= x_start + length_ground)) begin
                    ground_on = 1'b1;
                    ground_flag = 1'b1;
                    break;
                end
                else begin
                    ground_on = 1'b0;
                end
            end
        end    
    end
    
//fence
    always_comb 
    begin
        fence_flag = 1'b0;
        if (fence_flag == 1'b0) begin
            for (int i = 0; i < 16; i = i + 1) begin
                y_start = info_fence[i][8:0];
                x_loc = info_fence[i][18:9];
                length_fence = info_fence[i][28:19];
                if ((DrawX >= x_loc - 2) && (DrawX <= x_loc + 1) && (DrawY >= y_start) && (DrawY <= y_start + length_fence)) begin
                    fence_on = 1'b1;
                    fence_flag = 1'b1;
                    break;
                end
                else begin
                    fence_on = 1'b0;
                end
            end
        end    
    end
    
//spince

always_comb begin
    for (int i = 0; i < 6; i = i + 1) begin
        if ((DrawX >= info_spince[i][9:0] - 3) && (DrawX <= info_spince[i][9:0] + 4) 
        && (DrawY >= info_spince[i][18:10] - 7) && (DrawY <= info_spince[i][18:10] + 7)) begin
            spince_on = 1'b1;
            spinceX = DrawX + 5 - info_spince[i][9:0];
            spinceY = DrawY + 7 - info_spince[i][18:10];
            break;
        end
        else begin
            spince_on = 1'b0;
        end
    end
end

//    always_comb
//    begin
//        spince_flag = 1'b0;
//        if (spince_flag == 1'b0) begin
//            for (int i = 0; i < 6; i = i + 1) begin
//                x_spince = info_spince[i][9:0];
//                y_spince = info_spince[i][18:10];
//                direction_spince = info_spince[i][20:19];
//                if (direction_spince == 1) begin
//                    //width:8 height:20
//                    if ((DrawX>= x_spince-4) && (DrawX <= x_spince + 4) &&
//                     (DrawY >= y_spince - 10) && (DrawY <= y_spince + 10)&&
//                     (DrawY-y_spince>=4*(DrawX-x_spince-2))&&
//                     (DrawY-y_spince>=-4*(DrawX-x_spince+2))
//                     ) begin
//                        spince_on = 1'b1;
//                        spince_flag = 1'b1;
//                        break;
//                    end
//                    else begin
//                        spince_on = 1'b0;
//                    end
//                end
//            end
//        end
//    end


    always_comb
    begin:RGB_Displa
        if (game_state == 3'd0) begin
            if (!(Red_start_screen == 4'h0 && Green_start_screen == 4'hF && Blue_start_screen == 4'h1) 
            && !(Red_start_screen == 4'h5 && Green_start_screen == 4'h7 && Blue_start_screen == 4'h6))begin
                Red = Red_start_screen;
                Green = Green_start_screen;
                Blue = Blue_start_screen;
            end
            else begin
                Red = 4'h0;
                Green = 4'h0;
                Blue = 4'h0;
            end
        end
        else if (game_state == 3'd1) begin
            Red = Red_background;
            Green = Green_background;
            Blue = Blue_background;
        end
        else if (game_state == 3'd2) begin
            if ((ground_on == 1'b1)) begin 
                Red = Red_ground; //4'hC;
                Green = Green_ground; //4'h7;
                Blue = Blue_ground; //4'h0;
            end 
            else if ((fence_on == 1'b1)) begin 
                Red = Red_wall;
                Green = Green_wall;
                Blue = Blue_wall;
            end
            else if ((spince_on == 1'b1)
            && (!(Red_spince == 4'h0 && Green_spince == 4'hE && Blue_spince == 4'h2) 
            && !(Red_spince == 4'h2 && Green_spince == 4'hC && Blue_spince == 4'h6))) begin  
                Red = Red_spince; //4'hB;
                Green = Green_spince; // 4'h0;
                Blue = Blue_spince; //4'hB;
            end
            else if ((ball_on == 1'b1 && direction == 0) 
            && (!(Red_player == 4'h0 && Green_player == 4'hF && Blue_player == 4'h1) 
            && !(Red_player == 4'h3 && Green_player == 4'hB && Blue_player == 4'h3)
            && !(Red_player == 4'h7 && Green_player == 4'hB && Blue_player == 4'h6))) begin 
                Red = Red_player;
                Green = Green_player;
                Blue = Blue_player;
            end
            else if ((ball_on == 1'b1 && direction == 1) 
            && (!(Red_player_reverse == 4'h0 && Green_player_reverse == 4'hF && Blue_player_reverse == 4'h1) 
            && !(Red_player_reverse == 4'h3 && Green_player_reverse == 4'hB && Blue_player_reverse == 4'h3)
            && !(Red_player_reverse == 4'h7 && Green_player_reverse == 4'hB && Blue_player_reverse == 4'h6))) begin 
                Red = Red_player_reverse;
                Green = Green_player_reverse;
                Blue = Blue_player_reverse;
            end
            else if ((exit_on == 1'b1)
            && (!(Red_door == 4'h0 && Green_door == 4'hF && Blue_door == 4'h1) 
            && !(Red_door == 4'h2 && Green_door == 4'h9 && Blue_door == 4'h3))) begin 
                Red = Red_door;
                Green = Green_door;
                Blue = Blue_door;
            end
            else if ((knife_on == 1'b1)) begin 
                Red = 4'hd;
                Green = 4'hd;
                Blue = 4'hd;
            end   
            else begin 
                Red = Red_background;
                Green = Green_background;
                Blue = Blue_background;
            end      
        end
        else if (game_state == 4'd3) begin
            Red = Red_win_screen;
            Green = Green_win_screen;
            Blue = Blue_win_screen;
        end
    end
    
endmodule
