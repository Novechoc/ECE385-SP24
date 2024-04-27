
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
    input  logic touch_down, touch_up, touch_left, touch_right,
    input  logic [9:0] touch_down_position_y, touch_left_position_x,
    input  logic [9:0] touch_up_position_y, touch_right_position_x,

    output logic [9:0]  BallX, 
    output logic [9:0]  BallY, 
    output logic [9:0]  BallS,
    output logic [9:0]  go_up, go_left, go_right
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
    
    logic wait_jump, drop_ground;
    logic [3:0] counter_jump;
    logic [3:0] counter_jump_time;

    logic [7:0] keycode1, keycode2, keycode3, keycode4;
    assign keycode1 = keycode[7:0];
    assign keycode2 = keycode[15:8];
    assign keycode3 = keycode[23:16];
    assign keycode4 = keycode[31:24];

    initial begin
        curr_speed = 10'd0;
        gravity = 10'd1;
        go_up = 0;
        go_left = 0; go_right = 0;
        wait_jump = 0;
        drop_ground = 0;
        counter_jump = 4'b0;
        counter_jump_time = 4'b0;
        
    end

    always_comb begin
        Ball_Y_Motion_next = 10'd0; // set default motion to be same as prev clock cycle 
        Ball_X_Motion_next = 10'd0;

        //modify to control ball motion with the keycode
        if (keycode1 == 8'h07 || keycode2 == 8'h07 || keycode3 == 8'h07 || keycode4 == 8'h07) begin
            Ball_X_Motion_next = 10'd1;
            go_up = 0;
            go_left = 0;
            go_right = 1;
        end
        else if (keycode1 == 8'h04 || keycode2 == 8'h04 || keycode3 == 8'h04 || keycode4 == 8'h04) begin
            Ball_X_Motion_next = -10'd1;
            go_up = 0;
            go_left = 1; 
            go_right = 0;
        end
        else begin
            go_up = 0;
            go_left = 0;
            go_right = 0;
        end

        if ((keycode1 == 8'h1A || keycode2 == 8'h1A || keycode3 == 8'h1A || keycode4 == 8'h1A) && drop_ground == 0) begin
            Ball_Y_Motion_next = -10'd8;
            go_up = 1;
        end

        if (logic_in_air == 1) begin // Ball is in the air, apply gravity
                if (wait_jump == 1) begin
                    Ball_Y_Motion_next = 0;
                end
                else if ((keycode1 != 8'h1A && keycode2 != 8'h1A && keycode3 != 8'h1A && keycode4 != 8'h1A) || drop_ground == 1 ) begin
                    Ball_Y_Motion_next = curr_speed + gravity;
                    curr_speed = Ball_Y_Motion_next;
                    if (curr_speed > 10'd3) begin
                        curr_speed = 10'd3;
                    end 
                end
                else begin
                    curr_speed = 10'd0;
                end
        end
        else begin
            curr_speed = 10'd0;
        end

        
        if (touch_down == 1) begin
            Ball_Y_Motion_next = touch_down_position_y - BallY;
        end
        else if (touch_up == 1 ) begin
            Ball_Y_Motion_next = Ball_Y_Step;//
        end

        if (touch_right == 1) begin
            Ball_X_Motion_next = touch_right_position_x - BallX;
        end
        else if (touch_left == 1) begin
            Ball_X_Motion_next = touch_left_position_x - BallX;
        end

        // if ((BallY + BallS) >= Ball_Y_Max & keycode != 8'h1A)
        // begin
        //     Ball_Y_Motion_next = 10'd0;
        // end

        //if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
        //begin
        //    Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'b1);  // set to -1 via 2's complement.
        //end

        //boundary check
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


    end
        
    always_ff @(posedge frame_clk) begin
        if (Reset) begin
            drop_ground <= 0;
            wait_jump <= 0;
            counter_jump <= 0;
            counter_jump_time <= 0;
        end
        else if (counter_jump_time >= 2 && logic_in_air == 1) begin
            drop_ground <= 1;
        end
        else if (go_up && !wait_jump) begin
            counter_jump <= counter_jump + 1;
            if (counter_jump >= 6) begin
                wait_jump <= 1;
            end
        end
        else if (wait_jump) begin
            counter_jump <= counter_jump + 1;
            if (counter_jump >= 11 && keycode1 != 8'h1A && keycode2 != 8'h1A && keycode3 != 8'h1A && keycode4 != 8'h1A) begin  // Adjust this value to control jump height/duration
                drop_ground <= 0;
                wait_jump <= 0;
                counter_jump <= 0;
                counter_jump_time <= counter_jump_time + 1;
            end
            else if (counter_jump >= 11) begin
                wait_jump <= 0;
                drop_ground <= 1;
            end
        end
        else if (logic_in_air == 0) begin
            drop_ground <= 0;
            wait_jump <= 0;
            counter_jump <= 0;
            counter_jump_time <= 0;  
        end
    end


    assign BallS = 15;  // default ball size
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
