module top(
    input clk,
    input enable,
    input Attack_start,
    input overide, // input overide is from the overcurrent protection ckt output pin JA1
    input R_signal, L_signal,
    
    input PR_Signal,
    // k1 and k10 act as switches and the IR_signal is given for the IR Circuit
    input k1,
    input k10,
    //input IR_signal,
    
    input Encoder_SignalA, //JA1
    input Encoder_SignalB, //JA2
    // functional rover control outputs
    output f_IN1, f_IN2, f_IN3, f_IN4,
    output f_enA, f_enB,
    output fire,
    //LEDs for Monorinting states
    output enable_LED,
    output Attack_LED,
    output f_RvL,
    output PR_LED,
    output Border_L,
    output k1_LED,
    output k10_LED,
    output Border_R,
    output Turn_Start_LED,
    output T_C_LED
    //output Fire_LED
);
    wire RvL;
    wire enA_OC, enB_OC;
    wire PWM_R, PWM_L;
    wire PR;

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
     .enable(enable),
     .Attack_start(Attack_start),
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
     .k1(k1),
     .k10(k10),

     .f_IN1(f_IN1), 
     .f_IN2(f_IN2), 
     .f_IN3(f_IN3), 
     .f_IN4(f_IN4),
     .f_enA(f_enA), 
     .f_enB(f_enB),
     .fire(fire),
    
     .enable_LED(enable_LED),
     .Attack_LED(Attack_LED),
     .f_RvL(f_RvL),
     .PR_LED(PR_LED),
     .Border_L(Border_L),
     .k1_LED(k1_LED),
     .k10_LED(k10_LED),
     .Border_R(Border_R),
     .Turn_Start_LED(Turn_Start_LED),
     .T_C_LED(T_C_LED)
     //.Fire_LED(Fire_LED)
    );

    Ball_Controller U4(
        .clk(clk),
        .k1(k1),
        .k10(k10),
        .T_C(T_C),
        .PR_Signal(PR_Signal),
        .IN(BC_IN),
        .Encoder_Turn(Encoder_Turn),
        .Turn_Start(Turn_Start),
        .PR(PR) 
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
    
    /*IR U7 (
        .clk(clk),
        .IR_signal(IR_signal),
        .k1(k1),
        .k10(k10)
    );*/

endmodule
