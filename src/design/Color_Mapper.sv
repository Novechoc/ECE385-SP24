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


module  color_mapper ( input  logic Clk, vde,
                       input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       input  logic [9:0] KnifeX, KnifeY, Knife_size,
                       output logic [3:0]  Red, Green, Blue, 
                       input  logic [28:0] info_fence[16],
                       input  logic [28:0] info_ground[16]);
                       
                       
    logic [3:0] Red_background;
    logic [3:0] Green_background;
    logic [3:0] Blue_background;
    
    background_example background_example_inst(
        .vga_clk(Clk),
        .DrawX(DrawX),
        .DrawY(DrawY),
        .blank(vde),
        .red(Red_background),
        .green(Green_background),
        .blue(Blue_background)
    );
    
    logic ball_on, knife_on;
    logic ground_on, ground_flag, fence_on, fence_flag;
    logic [9:0] x_start, y_loc, length_ground;
    logic [9:0] y_start, x_loc, length_fence;


    initial begin
        ball_on = 1'b0;
        ground_on = 1'b0;
        ground_flag = 1'b0;
        fence_on = 1'b0;
        fence_flag = 1'b0;
        knife_on = 1'b0;
    end
	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;

    int Dist_knifeX, Dist_knifeY, Size_knife;
    assign Dist_knifeX = DrawX - KnifeX;
    assign Dist_knifeY = DrawY - KnifeY;
    assign Size_knife = Knife_size;

//ball
    always_comb
    begin:Ball_on_proc
        if ( (2*DistX*DistX + DistY*DistY) <= (Size * Size) )
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
    end 

//throw knife
    always_comb
    begin:Knife_on_proc
        if ( ((Dist_knifeX*Dist_knifeX + Dist_knifeY*Dist_knifeY) <= (Size_knife * Size_knife))) //&&
            //(DrawY >= KnifeY +  Size_knife/2)&& (DrawY <= KnifeY +  Size_knife/2 + 3 ))
            knife_on = 1'b1;
        else 
            knife_on = 1'b0;
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

    always_comb
    begin:RGB_Displa
        if ((ground_on == 1'b1)) begin 
            Red = 4'hC;
            Green = 4'h7;
            Blue = 4'h0;
        end 
        else if ((fence_on == 1'b1)) begin 
            Red = 4'hC;
            Green = 4'h7;
            Blue = 4'h0;
        end
        else if ((ball_on == 1'b1)) begin 
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end    
        else if ((knife_on == 1'b1)) begin 
            Red = 4'hb;
            Green = 4'hb;
            Blue = 4'hb;
        end   
        else begin 
            Red = Red_background;
            Green = Green_background;
            Blue = Blue_background;
        end      
    end 
    
endmodule
