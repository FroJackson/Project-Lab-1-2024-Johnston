module Encoder_Turn(
    input clk,
    input Encoder_SignalA,
    input Encoder_SignalB,
    input [1:0]Encoder_Turn,    // B L R F    //Input
    input Turn_Start,
    output reg enA_RE,
    output reg enB_RE,
    output reg [4:1] IN,
    output reg T_C
 //   output LED1
);
reg [7:0] EncoderA_Counter = 0;
reg [7:0] EncoderB_Counter = 0;
reg [9:0] Encoder_Out = 0;
reg old_signal_A = 0;
reg old_signal_B = 0;
reg T_C_reg = 0;
                //OUTPUT
parameter Turn_Limit = 65;     //17=45d 40=110d
reg Stop_A = 0;
reg Stop_B = 0;
//reg LEDON = 0;

always @(posedge clk) begin
if (Turn_Start) begin
    if (~T_C_reg)begin

        case (Encoder_Turn)
            2'b10: IN = 4'b1010;          // Left on Switch 2 (0110)
            2'b01: IN = 4'b0101;          // Right on Switch 1 (1001)
            default: IN = 4'b0000;          // Stop (0000)
        endcase

        if (Encoder_SignalA) begin
            if ((Encoder_SignalA != old_signal_A) & ~old_signal_A) begin
                EncoderA_Counter = EncoderA_Counter + 1;
            end
        end

        if (Encoder_SignalB) begin
            if ((Encoder_SignalB != old_signal_B) & ~old_signal_B) begin
                EncoderB_Counter = EncoderB_Counter + 1;
            end
        end

        if (EncoderB_Counter == EncoderA_Counter) begin
            Stop_A = 0; 
            Stop_B = 0;
            Encoder_Out = EncoderA_Counter;
        end

        old_signal_A = Encoder_SignalA;
        old_signal_B = Encoder_SignalB;

        if(EncoderA_Counter > 17)begin
            EncoderA_Counter = 0;
            EncoderB_Counter = 0;
            Encoder_Out = 0;
            T_C_reg = 1;
        end 
    end
    else begin
        IN = 4'b0000;
    end
    end
    enA_RE = (Stop_A == 0) ? 1 : 0;
    enB_RE = (Stop_B == 0) ? 1 : 0;
    T_C = T_C_reg;
end
//    assign LED1 = LEDON;
endmodule
