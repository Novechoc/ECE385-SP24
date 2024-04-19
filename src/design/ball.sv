//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [31:0]  keycode,

    input  logic logic_in_air,
    input  logic touch_down, touch_up,
    input  logic [9:0] touch_down_position_y,
    input  logic [9:0] touch_up_position_y,

    output logic [9:0]  BallX, 
    output logic [9:0]  BallY, 
    output logic [9:0]  BallS,
    output logic [9:0]  go_up 
);
    

	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=7;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion_next;
    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;

    logic [9:0] curr_speed;
    logic [9:0] gravity;

    logic [7:0] keycode1, keycode2, keycode3, keycode4;
    assign keycode1 = keycode[7:0];
    assign keycode2 = keycode[15:8];
    assign keycode3 = keycode[23:16];
    assign keycode4 = keycode[31:24];

    initial begin
        curr_speed = 10'd0;
        gravity = 10'd1;
        go_up = 0;
    end

    always_comb begin
        Ball_Y_Motion_next = 10'd0; // set default motion to be same as prev clock cycle 
        Ball_X_Motion_next = 10'd0;

        //modify to control ball motion with the keycode
        if (keycode1 == 8'h16 || keycode2 == 8'h16 || keycode3 == 8'h16 || keycode4 == 8'h16) begin
            Ball_X_Motion_next = 10'd0;
            go_up = 0;
        end        
        else if (keycode1 == 8'h07 || keycode2 == 8'h07 || keycode3 == 8'h07 || keycode4 == 8'h07) begin
            Ball_X_Motion_next = 10'd1;
            go_up = 0;
        end
        else if (keycode1 == 8'h04 || keycode2 == 8'h04 || keycode3 == 8'h04 || keycode4 == 8'h04) begin
            Ball_X_Motion_next = -10'd1;
            go_up = 0;
        end
        else begin
            go_up = 0;
        end

        if (keycode1 == 8'h1A || keycode2 == 8'h1A || keycode3 == 8'h1A || keycode4 == 8'h1A) begin
            Ball_Y_Motion_next = -10'd7;
            go_up = 1;
        end

        if (logic_in_air == 1 && go_up == 0) begin // Ball is in the air, apply gravity
            Ball_Y_Motion_next = curr_speed + gravity;
            curr_speed = Ball_Y_Motion_next;
            if (curr_speed > 10'd3) begin
                curr_speed = 10'd3;
            end
        end
        else begin
            curr_speed = 10'd0;
        end
        
        if (touch_down == 1) begin
            Ball_Y_Motion_next = touch_down_position_y - BallY;
        end
        else if (touch_up == 1) begin
            Ball_Y_Motion_next = Ball_Y_Step;
        end

        // if ((BallY + BallS) >= Ball_Y_Max & keycode != 8'h1A)
        // begin
        //     Ball_Y_Motion_next = 10'd0;
        // end

        //if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        //begin
        //    Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        //end
        if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
        begin
            Ball_Y_Motion_next = Ball_Y_Step;
        end 
        else if ( (BallX + BallS) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
        begin
            Ball_X_Motion_next = (~ (Ball_X_Step) + 1'b1);
        end
        else if ( (BallX - BallS) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
        begin
            Ball_X_Motion_next = Ball_X_Step;
        end
       //fill in the rest of the motion equations here to bounce left and right

    end

    assign BallS = 16;  // default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
			BallY <= Ball_Y_Center;
			BallX <= Ball_X_Center;
        end
        else 
        begin 
            BallY <= Ball_Y_next;  // Update ball position
            BallX <= Ball_X_next;
		end  
    end


    
      
endmodule
