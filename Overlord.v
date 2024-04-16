module New_Overlord (
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

    output f_IN1, f_IN2, f_IN3, f_IN4,
    output f_enA, f_enB,
    output f_RvL,
    output Fire
);
    assign f_enA = (~PR & enA_OC & PWM_R) | (PR & PWM & enA_OC & enA_RE);
    assign f_enB = (~PR & enB_OC & PWM_L) | (PR & PWM & enB_OC & enB_RE);
    
    assign f_IN1 = (~PR & 1) | (PR & ((BC_IN[1] & ~Turn_Start) | (ET_IN[1] & Turn_Start)) & PWM);
    assign f_IN2 = (~PR & 0) | (PR & ((BC_IN[2] & ~Turn_Start) | (ET_IN[2] & Turn_Start)) & PWM);
    assign f_IN3 = (~PR & 0) | (PR & ((BC_IN[3] & ~Turn_Start) | (ET_IN[3] & Turn_Start)) & PWM);
    assign f_IN4 = (~PR & 1) | (PR & ((BC_IN[4] & ~Turn_Start) | (ET_IN[4] & Turn_Start)) & PWM);
    
    assign Fire = T_C;
    
    assign f_RvL = RvL;
    

endmodule