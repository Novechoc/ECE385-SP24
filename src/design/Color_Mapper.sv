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


module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       output logic [3:0]  Red, Green, Blue, 
                       input  logic [28:0] info_ground[16]);
    
    logic ball_on;
    logic ground_on, ground_flag;
    logic [9:0] x_start, y_loc, length;

    initial begin
        ball_on = 1'b0;
        ground_on = 1'b0;
        ground_flag = 1'b0;
    end
	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
  
    always_comb
    begin:Ball_on_proc
        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
    end 

    always_comb 
    begin
        ground_flag = 1'b0;
        if (ground_flag == 1'b0) begin
            for (int i = 0; i < 16; i = i + 1) begin
                x_start = info_ground[i][9:0];
                y_loc = info_ground[i][18:10];
                length = info_ground[i][28:19];
                if ((DrawY >= y_loc - 2) && (DrawY <= y_loc + 2) && (DrawX >= x_start) && (DrawX <= x_start + length)) begin
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
       
    always_comb
    begin:RGB_Displa
        if ((ground_on == 1'b1)) begin 
            Red = 4'hC;
            Green = 4'h7;
            Blue = 4'h0;
        end
        else if ((ball_on == 1'b1)) begin 
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end       
        else begin 
            Red = 4'h1; 
            Green = 4'h8;
            Blue = 4'hb;
        end      
    end 
    
endmodule
