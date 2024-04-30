module state_machine
(
    input logic pixel_clk,
    input logic reset,
    input logic win_the_game, lose_the_game,
    input logic [31:0] keycode,
    output logic [3:0] game_state,
    output logic [1:0] selector_value
);

logic [7:0] keycode1, keycode2, keycode3, keycode4;
assign keycode1 = keycode[7:0];
assign keycode2 = keycode[15:8];
assign keycode3 = keycode[23:16];
assign keycode4 = keycode[31:24];

// logic next_world_aviailable, can_win;
// logic [8:0] time_counter;

// State definition
typedef enum logic [3:0] {
    START_SCREEN,
    GAME_STATE_PREP_1,
    GAME_STATE_1,
    GAME_LOSE_STATE_1,
    GAME_STATE_PREP_2,
    GAME_STATE_2,
    GAME_LOSE_STATE_2,
    GAME_WIN_STATE,
    GAME_WIN_STATE_TRANSITION
} State;

// State register and next state logic
State current_state, next_state;

always_ff @(posedge pixel_clk) begin
    if (reset) begin
        current_state <= START_SCREEN;
    end else begin
        current_state <= next_state;
    end
end

initial begin
    current_state = START_SCREEN;
    selector_value = 2'b00;
    // next_world_aviailable = 1;
    // time_counter = 0;
end

// State transition and output logic
always_comb begin
    case (current_state)
        START_SCREEN: begin
            if (keycode1 == 8'h28 || keycode2 == 8'h28 || keycode3 == 8'h28 || keycode4 == 8'h28) begin
                next_state = GAME_STATE_PREP_1;
            end
            else begin
                next_state = START_SCREEN;
            end
            game_state = 4'd0;
            selector_value = 2'b00;
        end
        GAME_STATE_PREP_1: begin
            next_state = GAME_STATE_1;
            game_state = 4'd1;
            selector_value = 2'b00;
        end
        GAME_STATE_1: begin
            if (win_the_game) begin
                next_state = GAME_STATE_PREP_2;
            end 
            else if (lose_the_game) begin
                next_state = GAME_LOSE_STATE_1;
            end
            else begin
                next_state = GAME_STATE_1;
            end
            game_state = 4'd2;
            selector_value = 2'b00;
        end
        GAME_LOSE_STATE_1: begin
            next_state = GAME_STATE_PREP_1;
            game_state = 4'd1;
            selector_value = 2'b00;
        end
        GAME_STATE_PREP_2: begin
            next_state = GAME_STATE_2;
            game_state = 4'd1;
            selector_value = 2'b01;
        end
        GAME_STATE_2: begin
            if (win_the_game) begin
                next_state = GAME_WIN_STATE;
            end 
            else if (lose_the_game) begin
                next_state = GAME_LOSE_STATE_2;
            end
            else begin
                next_state = GAME_STATE_2;
            end
            game_state = 4'd2;
            selector_value = 2'b01;
        end
        GAME_LOSE_STATE_2: begin
            next_state = GAME_STATE_PREP_2;
            game_state = 4'd1;
            selector_value = 2'b01;
        end
        GAME_WIN_STATE: begin
            if (keycode1 == 8'h28 || keycode2 == 8'h28 || keycode3 == 8'h28 || keycode4 == 8'h28) begin
                next_state = GAME_WIN_STATE_TRANSITION;
            end
            else begin
                next_state = GAME_WIN_STATE;
            end
            game_state = 4'd3;
            selector_value = 2'b00;
        end
        GAME_WIN_STATE_TRANSITION: begin
            if (keycode1 != 8'h28 && keycode2 != 8'h28 && keycode3 != 8'h28 && keycode4 != 8'h28) begin
                next_state = START_SCREEN;
            end
            else begin
                next_state = GAME_WIN_STATE_TRANSITION;
            end
            game_state = 4'd0;
            selector_value = 2'b00;  
        end
    endcase
end


// always_ff @(posedge pixel_clk) begin
//     if (reset) begin
//         next_world_aviailable <= 1;
//         time_counter <= 0;
//     end
    
//     time_counter <= time_counter + 1;
//     if (time_counter == 10) begin
//         can_win <= 1;
//         time_counter <= 0;
//     end
//     else begin
//         can_win <= 0;
//     end
    
//     if (selector_value == 2'b01) begin
//         next_world_aviailable <= 0;
//     end
//     else if (selector_value == 2'b00) begin
//         next_world_aviailable <= 1;
//     end
// end


endmodule