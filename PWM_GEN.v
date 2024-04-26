module PWM_Generator_Find(
    input clk,
    output PWM_R_F, PWM_L_F,
    output PWM_R_R, PWM_L_R,
    output PWM_R_L, PWM_L_L
);
    reg PWM_R_F_out =0;
    reg PWM_L_F_out =0;
    reg PWM_R_R_out =0;
    reg PWM_L_R_out =0;
    reg PWM_R_L_out =0;
    reg PWM_L_L_out =0;
    // copy paste and comment to switch the PWM values on the fly
    // 75 40 and 80 in place rn
    //reg [19:0] width_25 = 20'd250000;
    //reg [19:0] width_30 = 20'd300000;
    //reg [19:0] width_35 = 20'd350000;
    reg [19:0] width_40 = 20'd400000;
    //reg [19:0] width_45 = 20'd450000;
    //reg [19:0] width_50 = 20'd500000;         // Pulse Width
    //reg [19:0] width_55 = 20'd550000;
    //reg [19:0] width_60 = 20'd600000;
    //reg [19:0] width_65 = 20'd650000;
    //reg [19:0] width_70 = 20'd700000;         // Pulse Width
    reg [19:0] width_75 = 20'd750000;
    reg [19:0] width_80 = 20'd800000;
    //reg [19:0] width_85 = 20'd850000;
    //reg [19:0] width_90 = 20'd900000;
    //reg [19:0] width_95 = 20'd950000;
    
    reg [19:0] count = 0;

    always@(posedge clk) begin

        count = count + 1;
        
        
        if(count < width_75) begin
            PWM_R_F_out = 1;
        end
        else begin
            PWM_R_F_out = 0;
        end
        
        
        
        if(count < width_75) begin
            PWM_L_F_out = 1;
        end
        else begin
            PWM_L_F_out = 0;
        end
        
        
        
        if(count < width_40) begin
            PWM_R_R_out = 1;
        end
        else begin
            PWM_R_R_out = 0;
        end
        
        
             
        if(count < width_80) begin
            PWM_L_R_out = 1;
        end
        else begin
            PWM_L_R_out = 0;
        end
        
        
        
        if(count < width_80) begin
            PWM_R_L_out = 1;
        end
        else begin
            PWM_R_L_out = 0;
        end
        
        
        
        if(count < width_40) begin
            PWM_L_L_out = 1;
        end
        else begin
            PWM_L_L_out = 0;
        end
       
        
        
end

        assign PWM_R_F = PWM_R_F_out;
        assign PWM_L_F = PWM_L_F_out;
        assign PWM_R_R = PWM_R_R_out;
        assign PWM_L_R = PWM_L_R_out;
        assign PWM_R_L = PWM_R_L_out;
        assign PWM_L_L = PWM_L_L_out;

endmodule