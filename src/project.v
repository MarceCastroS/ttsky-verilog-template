module tt_um_cardjitsu (
    input logic clk,
    input logic rst,
    input logic btn_0,
    input logic btn_1,
    input logic btn_2,
    input logic [3:0] sw,
    output logic [3:0] leds,
    output logic led6_r,
    output logic led6_g,
    output logic led6_b
);

    // Tipos de estado
    typedef enum { INICIO, JUGADOR1, JUGADOR2, EVALUAR, CHEQUEO_GANADOR } state_type;
    state_type state = INICIO;

    // Registros
    logic [3:0] carta_j1;
    logic [3:0] carta_j2;
    logic [3:0] Mazo1 [5:0];
    logic [3:0] Mazo2 [5:0];
    integer victorias_j1 = 0;
    integer victorias_j2 = 0;
    integer mazo1_idx = 0;
    integer mazo2_idx = 0;
    integer vida1 = 8;
    integer vida2 = 8;
    logic btn_reg, btn_reg_prev;

    // Lógica para detectar flanco de subida de btn_0
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_reg <= 1'b0;
            btn_reg_prev <= 1'b0;
        end else begin
            btn_reg_prev <= btn_reg;
            btn_reg <= btn_0;
        end
    end
    
    // Máquina de estados principal
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= INICIO;
            mazo1_idx <= 0;
            for (int i=0; i<6; i++) begin
                Mazo1[i] <= 4'b0000;
            end
            mazo2_idx <= 0;
            for (int i=0; i<6; i++) begin
                Mazo2[i] <= 4'b0000;
            end
            victorias_j1 <= 0;
            victorias_j2 <= 0;
            vida1 <= 8;
            vida2 <= 8;
            led6_g <= 1'b1;
            led6_b <= 1'b0;
            led6_r <= 1'b0;
        end else begin
            case (state)
                INICIO: begin
                    led6_g <= 1'b1;
                    led6_b <= 1'b0;
                    led6_r <= 1'b0;
                    if (btn_reg == 1'b1 && btn_reg_prev == 1'b0) begin
                        if (mazo1_idx <= 5) begin
                            Mazo1[mazo1_idx] <= sw;
                            mazo1_idx <= mazo1_idx + 1;
                        end else begin
                            Mazo2[mazo2_idx] <= sw;
                            mazo2_idx <= mazo2_idx + 1;
                        end
                    end
                    if (mazo2_idx == 6) begin
                        mazo1_idx <= 0;
                        mazo2_idx <= 0;
                        state <= JUGADOR1;
                    end
                end

                JUGADOR1: begin
                    led6_g <= 1'b0;
                    led6_b <= 1'b1;
                    led6_r <= 1'b0;
                    if (btn_reg == 1'b1 && btn_reg_prev == 1'b0) begin
                        case (sw)
                            4'd1: if (Mazo1[0] != 4'b0000) begin carta_j1 <= Mazo1[0]; Mazo1[0] <= 4'b0000; state <= JUGADOR2; end
                            4'd2: if (Mazo1[1] != 4'b0000) begin carta_j1 <= Mazo1[1]; Mazo1[1] <= 4'b0000; state <= JUGADOR2; end
                            4'd3: if (Mazo1[2] != 4'b0000) begin carta_j1 <= Mazo1[2]; Mazo1[2] <= 4'b0000; state <= JUGADOR2; end
                            4'd4: if (Mazo1[3] != 4'b0000) begin carta_j1 <= Mazo1[3]; Mazo1[3] <= 4'b0000; state <= JUGADOR2; end
                            4'd5: if (Mazo1[4] != 4'b0000) begin carta_j1 <= Mazo1[4]; Mazo1[4] <= 4'b0000; state <= JUGADOR2; end
                            4'd6: if (Mazo1[5] != 4'b0000) begin carta_j1 <= Mazo1[5]; Mazo1[5] <= 4'b0000; state <= JUGADOR2; end
                        endcase
                    end
                end

                JUGADOR2: begin
                    led6_g <= 1'b0;
                    led6_b <= 1'b0;
                    led6_r <= 1'b1;
                    if (btn_reg == 1'b1 && btn_reg_prev == 1'b0) begin
                        case (sw)
                            4'd1: if (Mazo2[0] != 4'b0000) begin carta_j2 <= Mazo2[0]; Mazo2[0] <= 4'b0000; state <= EVALUAR; end
                            4'd2: if (Mazo2[1] != 4'b0000) begin carta_j2 <= Mazo2[1]; Mazo2[1] <= 4'b0000; state <= EVALUAR; end
                            4'd3: if (Mazo2[2] != 4'b0000) begin carta_j2 <= Mazo2[2]; Mazo2[2] <= 4'b0000; state <= EVALUAR; end
                            4'd4: if (Mazo2[3] != 4'b0000) begin carta_j2 <= Mazo2[3]; Mazo2[3] <= 4'b0000; state <= EVALUAR; end
                            4'd5: if (Mazo2[4] != 4'b0000) begin carta_j2 <= Mazo2[4]; Mazo2[4] <= 4'b0000; state <= EVALUAR; end
                            4'd6: if (Mazo2[5] != 4'b0000) begin carta_j2 <= Mazo2[5]; Mazo2[5] <= 4'b0000; state <= EVALUAR; end
                        endcase
                    end
                end

                EVALUAR: begin
                    if (carta_j1[1:0] > carta_j2[1:0]) begin
                        victorias_j1 <= victorias_j1 + 1;
                        vida2 <= vida2 - carta_j1[1:0];
                        state <= CHEQUEO_GANADOR;
                    end else if (carta_j1[1:0] < carta_j2[1:0]) begin
                        victorias_j2 <= victorias_j2 + 1;
                        vida1 <= vida1 - carta_j2[1:0];
                        state <= CHEQUEO_GANADOR;
                    end else begin
                        state <= JUGADOR1;
                    end
                end

                CHEQUEO_GANADOR: begin
                    led6_g <= 1'b0;
                    led6_b <= 1'b0;
                    led6_r <= 1'b0;
                    if (vida2 <= 0 || victorias_j1 >= 3) begin
                        // Jugador 1 Gana
                    end else if (vida1 <= 0 || victorias_j2 >= 3) begin
                        // Jugador 2 Gana
                    end else begin
                        state <= JUGADOR1;
                    end
                end
            endcase
        end
    end

    // Lógica para los LEDs
    always_comb begin
        if (btn_1 == 1'b1) begin
            if (sw == 4'b1111) begin
                leds = vida1;
            end else begin
                leds = victorias_j1;
            end
        end else if (btn_2 == 1'b1) begin
            if (sw == 4'b1111) begin
                leds = vida2;
            end else begin
                leds = victorias_j2;
            end
        end else begin
            case (state)
                INICIO: leds = mazo1_idx + mazo2_idx;
                EVALUAR: begin
                    if (carta_j1[1:0] > carta_j2[1:0])
                        leds = 4'b1000; // J1 Gana
                    else if (carta_j1[1:0] < carta_j2[1:0])
                        leds = 4'b0001; // J2 Gana
                    else
                        leds = 4'b0000; // Empate
                end
                CHEQUEO_GANADOR: begin
                    if (vida2 <= 0 || victorias_j1 >= 3)
                        leds = 4'b1100; // J1 Ganador Final
                    else if (vida1 <= 0 || victorias_j2 >= 3)
                        leds = 4'b0011; // J2 Ganador Final
                    else
                        leds = 4'b0000;
                end
                default: leds = 4'b0000;
            endcase
        end
    end
endmodule