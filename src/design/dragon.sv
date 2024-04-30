module dragon_attack(
    input logic Reset, frame_clk,
    input logic [9:0] BallX, BallY, BallS,
    input logic [3:0] game_state,
    input logic go_out_attack_range,
    output [9:0] attackX,attackY,attackS
);

    logic [9:0] attack_motion_X, attack_motion_Y, targetX, targetY;
    logic throw_attack, attack_exist, flag_record_location,DirectionX;
    logic [9:0] mouthX, mouthY, attack_speed_default;
    int Rate;
    assign mouthX = 570;
    assign mouthY = 230;
    // assign DistX = BallX - mouthX;
    // assign DistY = BallY - mouthY;
    // assign Rate = DistY/DistX;
    assign attackS = 8;
    assign attack_speed_default = 10d'1;

    always_ff @(posedge frame_clk) begin
        if (Reset == 1) begin
            attackX <= 0;
            attackY <= 0;
            attack_exist <= 0;
            throw_attack <= 0;
            flag_record_location <= 0;
            // attack_motion_X <= attack_speed_default;
            // attack_motion_Y <= attack_speed_default * Rate;
        end
        else begin
            if (go_out_attack_range == 1) begin
                attack_exist <= 0;
                flag_record_location <= 1;
            end
            else begin
                attack_exist <= 1;
                flag_record_location <= 0;
            end

            if ((attack_exist == 0)&&(flag_record_location)) begin
                targetX <= BallX;
                targetY <= BallY;
                if(targetX - mouthX >= 0)begin
                    DirectionX <= 1; //to right
                end
                else begin
                    DirectionX <= 0; //to left
                end
                Rate = (targetY - mouthY)/(targetX - mouthX);
                flag_record_location <= 0;
                if(DirectionX==0)begin  //to left(most times)
                    attack_motion_X <= -attack_speed_default;
                    attack_motion_Y <= attack_motion_X * Rate;
                end
                else begin
                    attack_motion_X <= attack_speed_default;
                    attack_motion_Y <= attack_motion_X * Rate;
                end

                attack_exist <= 1;
            if(attack_exist==1) begin
                if((go_out_attack_range == 1)) begin
                    attack_exist <= 0;
                    attackX <= 0;
                    attackY <= 0;
                end
                if(knife_exist == 1) begin
                    attackX <= attackX + attack_motion_X;
                    attackY <= attackY + attack_motion_Y;
                end
            end
            
        end
    end

endmodule