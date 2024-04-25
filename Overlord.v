module New_Overlord (
    input enable,
    input Attack_start,
    input PR,
    input PWM,
    input PWM_R, PWM_L,
    input enA_OC, enB_OC,
    input enA_RE, enB_RE,
    input Turn_Start,
    input T_C,
    input [4:1] BC_IN,
    input [4:1] ET_IN, 
    input RvL,
    input k1,
    input k10,

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
    output Fire_LED
);
    assign f_enA = (enable & Attack_start) & ((~PR & enA_OC & PWM_R) | (PR & PWM & enA_OC & enA_RE));
    assign f_enB = (enable & Attack_start) & ((~PR & enB_OC & PWM_L) | (PR & PWM & enB_OC & enB_RE));
    
    assign f_IN1 = (enable & Attack_start) & ((~PR & 0 & PWM_R) | (PR & ((BC_IN[1] & ~Turn_Start) | (ET_IN[1] & Turn_Start)) & PWM));
    assign f_IN2 = (enable & Attack_start) & ((~PR & 1 & PWM_L) | (PR & ((BC_IN[2] & ~Turn_Start) | (ET_IN[2] & Turn_Start)) & PWM));
    assign f_IN3 = (enable & Attack_start) & ((~PR & 1 & PWM_R) | (PR & ((BC_IN[3] & ~Turn_Start) | (ET_IN[3] & Turn_Start)) & PWM));
    assign f_IN4 = (enable & Attack_start) & ((~PR & 0 & PWM_L) | (PR & ((BC_IN[4] & ~Turn_Start) | (ET_IN[4] & Turn_Start)) & PWM));
    
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
    //assign Fire_LED = T_C;

endmodule
