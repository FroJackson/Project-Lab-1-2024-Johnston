module New_Overlord (
    input enable,
    input Attack_start,
    input PR,
    input PWM,
    input PWM_R, PWM_L,
    input enA_OC, enB_OC,
    input enA_RE, enB_RE,
    
    input en_A_Find,
    input en_B_Find,
    
    input Turn_Start,
    input T_C,
    input [4:1] BC_IN,
    input [4:1] ET_IN, 
    
    input FIND_IN_1,
    input FIND_IN_2,
    input FIND_IN_3,
    input FIND_IN_4,
    
    input RvL,
    input k1,
    input k10,
    
    input R_final_signal,
    input L_final_signal,

    output f_IN1, f_IN2, f_IN3, f_IN4,
    output f_enA, f_enB,
    output fire,
    
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
    //output Fire_LED
    
    output Border_L2,
    output R_Final_LED,
    output L_Final_LED,
    output Border_R2
);
    assign f_enA = (enable & Attack_start) & ((~PR & enA_OC & PWM_R & en_A_Find) | (PR & PWM & enA_OC /*& enA_RE*/));
    assign f_enB = (enable & Attack_start) & ((~PR & enB_OC & PWM_L & en_B_Find) | (PR & PWM & enB_OC /*& enB_RE)*/));
    
    assign f_IN1 = (enable & Attack_start) & ((~PR & FIND_IN_1) | (PR & ((BC_IN[1] & ~Turn_Start) | (ET_IN[1] & Turn_Start))));
    assign f_IN2 = (enable & Attack_start) & ((~PR & FIND_IN_2) | (PR & ((BC_IN[2] & ~Turn_Start) | (ET_IN[2] & Turn_Start))));
    assign f_IN3 = (enable & Attack_start) & ((~PR & FIND_IN_3) | (PR & ((BC_IN[3] & ~Turn_Start) | (ET_IN[3] & Turn_Start))));
    assign f_IN4 = (enable & Attack_start) & ((~PR & FIND_IN_4) | (PR & ((BC_IN[4] & ~Turn_Start) | (ET_IN[4] & Turn_Start))));
    
    assign fire = T_C;
    
    assign enable_LED = enable;
    assign Attack_LED = Attack_start;
    assign f_RvL = RvL;
    assign PR_LED = PR;
    assign Border_L = 1;
    assign k1_LED = k1;
    assign k10_LED = k10;
    assign Border_R = 1;
    assign Turn_Start_LED = Turn_Start;
    assign T_C_LED = T_C;
    assign R_Final_LED = R_final_signal;
    assign L_Final_LED = L_final_signal;
    assign Border_L2 = 1;
    assign Border_R2 = 1;
    //assign Fire_LED = T_C;

endmodule