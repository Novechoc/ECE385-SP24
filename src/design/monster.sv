module monster(
    input logic Reset, frame_clk,
    input logic [9:0] BallX, BallY, BallS,
    input logic [20:0] info_monster,
    input logic [9:0] knifeX, knifeY,
    input logic [3:0] game_state,
    output logic [9:0] fireballX, fireballY, fireballS,
    output logic fireball_exist, monster_exist
    );

logic [9:0] playerX, playerY;
logic [9:0] stepX, stepY;
logic knife_can_attack, monster_enable;
logic [3:0] monster_life_counter;
logic [9:0] monsterX, monsterY;
assign monsterX = info_monster[9:0];
assign monsterY = info_monster[19:10];
assign monster_enable = info_monster[20];

logic [1:0] attack_state;
// 0: player is not in range，try to locate the player
// 1: player is in range, preparing to attack
// 2: player is in range, attacking

assign fireballS = 8;

initial begin
    attack_state = 2'b00;
    fireball_exist = 0;
    monster_exist = 1;
    knife_can_attack = 0;
    monster_life_counter = 0;
end

always_ff @(posedge frame_clk) begin // monster movement
    if (game_state == 4'd2 && monster_exist && monster_enable) begin
        if ((knifeX >= BallX - BallS) && (knifeX <= BallX + BallS)
         && (knifeY >= BallY - BallS) && (knifeY <= BallY + BallS)) begin
            knife_can_attack <= 1;
        end
        else if (knifeX >= monsterX -5 && knifeX <= monsterX + 5  && knifeY >= monsterY - 30 && knifeY <= monsterY + 30) begin
            knife_can_attack <= 0;
            monster_life_counter <= monster_life_counter + 1;
            if (monster_life_counter == 4'd4) begin
                monster_exist <= 0;
                monster_life_counter <= 0;
            end
        end
    end
    else if (game_state != 4'd2) begin
        knife_can_attack <= 0;
        monster_life_counter <= 0;
        monster_exist <= 1;
    end
end

always_ff @(posedge frame_clk) begin // monster attack
    if (game_state == 4'd2 && monster_exist == 1 && monster_enable == 1) begin
        if (attack_state == 0) begin // player not in range, try to locate the player
            if (BallX > 200 && BallX < monsterX) begin
                attack_state = 2'b01;
                playerX <= BallX;
                playerY <= BallY;
                stepX <= 1;
                if (playerY - monsterY >= 0) begin // below
                    stepY <= (playerY - monsterY)/(monsterX - playerX) * stepX;
                end
                else begin
                    stepY <= (monsterY - playerY)/(monsterX - playerX) * stepX;
                end
            end
        end
        else if (attack_state == 1) begin // player in range, preparing to attack
            fireball_exist = 1;
            fireballX <= monsterX;
            fireballY <= monsterY;
            attack_state <= 2'b10;
        end
        else if (attack_state == 2) begin // player in range, attacking
            fireballX <= fireballX - stepX;
            if (playerY - monsterY >= 0) begin // below
                fireballY <=  fireballY + stepY;
            end
            else begin
                fireballY <=  fireballY + stepY;
            end
            if ((fireballX <= 200) || (fireballY <= 0) || (fireballY >= 480) ) begin
                fireball_exist <= 0;
                attack_state <= 2'b00;
            end
        end
    end
    else begin
        attack_state <= 2'b00;
        fireball_exist <= 0;
    end
end

endmodule