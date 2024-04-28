module knife(
    input logic Reset,
    input logic frame_clk,
    input logic [31:0] keycode,
    input logic [9:0] BallX, 
    input logic [9:0] BallY, 
    input logic [9:0] BallS,
    input logic [9:0] go_left, go_right,
    input logic knife_touch_fence,
    output logic [9:0] knifeX,
    output logic [9:0] knifeY,
    output logic [9:0] knifeS
);

    logic throw_knife;
    logic knife_exist;
    logic direction;
    logic [9:0] knife_motion_X;
    logic [9:0] knife_speed;
    logic [7:0] keycode1, keycode2, keycode3, keycode4;
    assign keycode1 = keycode[7:0];
    assign keycode2 = keycode[15:8];
    assign keycode3 = keycode[23:16];
    assign keycode4 = keycode[31:24];
    assign knifeS = 8;
    assign knife_speed = 10'd5;
    assign knife_max_X = 639;
    assign knife_min_X = 0;

    always_ff @(posedge frame_clk) begin
        if (Reset == 1) begin
            knifeX <= 0;
            knifeY <= 0;
            knife_exist <= 0;
            throw_knife <= 0;
            knife_motion_X <= knife_speed;
            direction <= 1'b0;
        end
        else begin
        
        if (go_left == 1) begin
            direction <= 1'b1;
        end
        else if (go_right == 1) begin
            direction <= 1'b0;
        end
        else begin
            direction <= direction;
        end

        if ((throw_knife==1)&&(keycode1 != 8'h0D || keycode2 != 8'h0D || keycode3 != 8'h0D || keycode4 != 8'h0D)) begin
            throw_knife <= 0;
        end

        if ((keycode1 == 8'h0D || keycode2 == 8'h0D || keycode3 == 8'h0D || keycode4 == 8'h0D)&&(throw_knife==0)) begin
            if(knife_exist == 0) begin
                knifeX <= BallX;
                knifeY <= BallY;
                if(direction == 1) begin
                    knife_motion_X <= -knife_speed;
                end
                else begin
                    knife_motion_X <= knife_speed;
                end

                knife_exist <= 1;
                throw_knife <= 1;
            end
        end
            if(knife_exist == 1) begin
                if((knife_touch_fence==1)) begin
                    knife_exist <= 0;
                    knifeX <= 0;
                    knifeY <= 0;
                end
                if(knife_exist == 1) begin
                    knifeX <= knifeX + knife_motion_X;
                    knifeY <= knifeY;
                end
            end


    
    end
    end
endmodule
