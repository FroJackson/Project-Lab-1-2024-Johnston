module top(
    input clk,
    input overide, // input overide is from the overcurrent protection ckt output pin JA1
    input R_signal, L_signal,
    output f_RvL,
    output f_IN1, f_IN2, f_IN3, f_IN4, //pins JA2,3,4,7
    output f_enA, f_enB, //pins JA8,9

    input PR,
    input k1,
    input k10,
    input Encoder_SignalA, //JC1
    input Encoder_SignalB //JC2
);
    wire RvL;
    wire enA_OC, enB_OC;
    wire PWM_R, PWM_L;

    wire [4:1]BC_IN;
    wire [4:1]ET_IN; 
    wire PWM;
    wire enA_RE;
    wire enB_RE;
    wire T_C;
    wire [1:0]Encoder_Turn;
    wire Turn_Start;



    // Instantiate MicFlip_Flops Module
    MicFlip_Flops U0 (
        .clk(clk),
        .RightMic(R_signal),
        .LeftMic(L_signal),
        .RvL(RvL)
    );

    // Instantiate PWM_Generator_Find Module
    PWM_Generator_Find U1 (
        .clk(clk),
        .RvL(RvL),
        .PWM_R(PWM_R),
        .PWM_L(PWM_L)
    );

    // Instantiate PWM_Generator_Find Module
    OverCurrent U2 (
        .clk(clk),
        .overide(overide),
        .enA_OC(enA_OC),
        .enB_OC(enB_OC)
    );

    // Instantiate New_Overlord Module
    New_Overlord U3 (
        .PR(PR),
        .PWM(PWM),
        .PWM_R(PWM_R),
        .PWM_L(PWM_L),

        .enA_OC(enA_OC),
        .enB_OC(enB_OC),
        .enA_RE(enA_RE),
        .enB_RE(enB_RE),
        
        .Turn_Start(Turn_Start),
        .T_C(T_C),
        .BC_IN(BC_IN),
        .ET_IN(ET_IN),
        .RvL(RvL),
                                // Outputs for the Entire systems that drives the directions and enables of the ckt. 
        .f_IN1(f_IN1),
        .f_IN2(f_IN2),
        .f_IN3(f_IN3),
        .f_IN4(f_IN4),
        .f_enA(f_enA),
        .f_enB(f_enB),
        .f_RvL(f_RvL),
        .Fire(Fire)
    );

    Ball_Controller U4(
        .clk(clk),
        .PR(PR),
        .k1(k1),
        .k10(k10),
        .T_C(T_C),
        .enA_OC(enA_OC),
        .Encoder_Turn(Encoder_Turn),
        .Turn_Start(Turn_Start),
        .IN(BC_IN)   
//        .LED1(LED1)
    );
    
    Encoder_Turn U5(
        .clk(clk),
        .Encoder_SignalA(Encoder_SignalA),
        .Encoder_SignalB(Encoder_SignalB),
        .Encoder_Turn(Encoder_Turn),
        .Turn_Start(Turn_Start),
        .enA_RE(enA_RE),
        .enB_RE(enB_RE),
        .IN(ET_IN),
        .T_C(T_C)   
        
  //      .LED1(LED1)
    );
    
    PWM_Generator U6 (
        .clk_100MHz(clk),
        .PWM(PWM)
    );

endmodule