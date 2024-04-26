module top(
    input clk,
    input enable,
    input Attack_start,
    input overide, // input overide is from the overcurrent protection ckt output pin JA1
    input R_signal, L_signal,
    
    input PR_Signal,
    // k1 and k10 act as switches and the IR_signal is given for the IR Circuit
    //input k1,
    //input k10,
    input IR_signal,
    
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
    output T_C_LED,
    
    output Border_R2,
    output R_Final_LED,
    output L_Final_LED,
    output Border_L2
    //output Fire_LED
);
    wire k1;
    wire k10;
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
    
    wire PWM_R_F;
    wire PWM_L_F;
    wire PWM_R_R;
    wire PWM_L_R;
    wire PWM_R_L;
    wire PWM_L_L;
    
    wire FIND_IN_1;
    wire FIND_IN_2;
    wire FIND_IN_3;
    wire FIND_IN_4;
    
    wire en_A_Find;
    wire en_B_Find;



    // Instantiate MicFlip_Flops Module
    MicFlip_Flops U0 (
        .clk(clk),              //RVL output based on the mic inputs
        .RightMic(R_signal),
        .LeftMic(L_signal),
        .RvL(RvL)
    );

    // Instantiate PWM_Generator_Find Module
    PWM_Generator_Find U1 (
        .clk(clk),              // PWMS for find ball state
        .PWM_R_F(PWM_R_F),
        .PWM_L_F(PWM_L_F),
        
        .PWM_R_R(PWM_R_R),
        .PWM_L_R(PWM_L_R),
        
        .PWM_R_L(PWM_R_L),
        .PWM_L_L(PWM_L_L)
    );

    // Instantiate PWM_Generator_Find Module
    OverCurrent U2 (
        .clk(clk),  
        .overide(overide),              // overcurrent protection ckt
        .enA_OC(enA_OC),                // protection enables
        .enB_OC(enB_OC)                 // protection enables
    );

    // Instantiate New_Overlord Module
    New_Overlord U3 (
     .enable(enable),                       // enable movement switch 1
     .Attack_start(Attack_start),           // start attack switch 2
     .PR(PR),                               // Photo resistor flag that controlls states 
     .PWM(PWM),                             //PWMS for ball controller state
     .PWM_R(PWM_R),                         // PWMS for find ball state
     .PWM_L(PWM_L),
     .enA_OC(enA_OC),                       // Overcurrent enables
     .enB_OC(enB_OC),
     .enA_RE(enA_RE),                       // NOT IN USE enables for the rover encoder turning
     .enB_RE(enB_RE),                       // NOT IN USE enables for the rover encoder turning
     
     .en_A_Find(en_A_Find),                 // enables for the start stop ball state
     .en_B_Find(en_B_Find),
     
     .Turn_Start(Turn_Start),               // Flags for signals    
     .T_C(T_C),                         
     .BC_IN(BC_IN),                         // inputs for IN pins
     .ET_IN(ET_IN), 
     
     .FIND_IN_1(FIND_IN_1),                 // inputs for IN pins
     .FIND_IN_2(FIND_IN_2),
     .FIND_IN_3(FIND_IN_3),
     .FIND_IN_4(FIND_IN_4),
     
     .RvL(RvL),                             // Rvl input k1 and k10 inputs for LEDs
     .k1(k1),
     .k10(k10),
     
     .R_final_signal(R_final_signal),       // signals from Start Stop find ball for LEDs
     .L_final_signal(L_final_signal),
     
     .f_IN1(f_IN1),                         // outputs driven to the motor control board and the fire control board
     .f_IN2(f_IN2), 
     .f_IN3(f_IN3), 
     .f_IN4(f_IN4),
     .f_enA(f_enA), 
     .f_enB(f_enB),
     .fire(fire),
    
     .enable_LED(enable_LED),               // LEDS 
     .Attack_LED(Attack_LED),
     .f_RvL(f_RvL),
     .PR_LED(PR_LED),
     .Border_L(Border_L),
     .k1_LED(k1_LED),
     .k10_LED(k10_LED),
     .Border_R(Border_R),
     .Turn_Start_LED(Turn_Start_LED),
     .T_C_LED(T_C_LED),
     .Border_L2(Border_L2),
     .R_Final_LED(R_Final_LED),
     .L_Final_LED(L_Final_LED),
     .Border_R2(Border_R2)
     //.Fire_LED(Fire_LED)
    );

    Ball_Controller U4(
        .clk(clk),
        .k1(k1),                        // k1 and k10 are from the IR dectection module
        .k10(k10),
        .T_C(T_C),                      // if ~T_C then it is searching for an IR signal 
        .PR_Signal(PR_Signal),          // Photoresistor signal that is debounced and latched
        
        .IN(BC_IN),                     // IN pins driven by BC IN
        .Encoder_Turn(Encoder_Turn),    // turn right vs left signal sent into encoder turn
        .Turn_Start(Turn_Start),        // starts encoder turn 
        .PR(PR)                         // logical output of PR used by the system to signal states before and after collection of the ball
//        .LED1(LED1)
    );
    
    Encoder_Turn U5(
        .clk(clk),
        .Encoder_SignalA(Encoder_SignalA),
        .Encoder_SignalB(Encoder_SignalB),
        .Encoder_Turn(Encoder_Turn),        // told to turn right or left based on 1k or 10k from Ball controller
        .Turn_Start(Turn_Start),            // Start turing from ball conteroller
        
        .enA_RE(enA_RE),                    // NOT IN USE
        .enB_RE(enB_RE),                    // NOT IN USE
        .IN(ET_IN),                         // IN PINS while encoder turn is active
        .T_C(T_C)                           // Turn complete  = fire
        
  //      .LED1(LED1)
    );
    
    PWM_Generator U6 (
        .clk_100MHz(clk),   // PWM signal for encoder turning 
        .PWM(PWM)
    );
    
    IR U7 (
        .clk(clk),               // Outputs the k1 or k10 logical signal based on the IR ckt
        .IR_signal(IR_signal),
        .k1(k1),
        .k10(k10)
    );
    
    Start_Stop_Find_Ball U8 (
    .RvL(RvL),                   //RvL from the mic flip flops            
    .clk(clk),

    .PWM_R_F(PWM_R_F),           // PWMS from PWM generator find
    .PWM_L_F(PWM_L_F),           
    .PWM_R_R(PWM_R_R),          
    .PWM_L_R(PWM_L_R),            
    .PWM_R_L(PWM_R_L),
    .PWM_L_L(PWM_L_L),
    

    .FIND_IN_1(FIND_IN_1),        // IN pins driven  into overlord used while ~PR
    .FIND_IN_2(FIND_IN_2),
    .FIND_IN_3(FIND_IN_3),
    .FIND_IN_4(FIND_IN_4),
    
    
    .PWM_R(PWM_R),                  // final output of the PWM_R or PWM_L based on the state
    .PWM_L(PWM_L),

    .en_A_Find(en_A_Find),          // final enable input  turns off when sample =1  
    .en_B_Find(en_B_Find),
    
    .R_final_signal(R_final_signal),
    .L_final_signal(L_final_signal)
    
    
    );

endmodule