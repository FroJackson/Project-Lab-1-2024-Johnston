module Start_Stop_Find_Ball(
    input RvL,
    input clk,

    input PWM_R_F,
    input PWM_L_F,
    input PWM_R_R,
    input PWM_L_R,
    input PWM_R_L,
    input PWM_L_L,
    

    output FIND_IN_1,
    output FIND_IN_2,
    output FIND_IN_3,
    output FIND_IN_4,
    
    
    output PWM_R,
    output PWM_L,

    output en_A_Find,
    output en_B_Find,
    
    output R_final_signal,  
    output L_final_signal
   
    
    );

reg sample = 1;          // turns off motors to allow for the mics to correctly sample
reg sample_NEW = 1;

reg [28:0]turn_timer = 0;    // time allowed to turn
reg [28:0]forward_timer = 0;  // time allowed to move forward

reg start_turn = 0;   // flag that starts turning
reg start_turn_NEW = 0;

reg Turn_V_Straight = 0;
reg Turn_V_Straight_NEW = 0;
reg [28:0]Right_Tracker = 0;
reg [28:0]Left_tracker = 0;
reg [28:0]sample_count = 0;

parameter [1:4]Forward_IN = 4'b0110;

reg [1:4]Turn_IN = 4'b0000;
reg [1:4]Turn_IN_NEW = 4'b0000;

reg Right_final = 0;
reg Left_final = 0;
reg Right_final_NEW = 0;
reg Left_final_NEW = 0;

always@(posedge clk)begin
    if (sample) begin
    //check if RvL is greater in a set time period
    //after 3s or 3_000_000 clk cycles of sample_count
        sample_count = sample_count + 1;
        if (~RvL) begin
            Left_tracker = Left_tracker + 1;
        end
    
        if(RvL) begin
            Right_Tracker = Right_Tracker + 1;
        end
    
        if (sample_count >= 100000000)begin
          if (Left_tracker > Right_Tracker) begin
            Turn_IN_NEW <= 4'b0101;
            start_turn_NEW = 1;
            sample_NEW = 0;
            sample_count <= 0;
            Right_final_NEW = 0;
            Left_final_NEW = 1;
            Left_tracker = 0;
            Right_Tracker = 0;
            end

          if (Left_tracker < Right_Tracker)begin
            Turn_IN_NEW <= 4'b1010;
            start_turn_NEW = 1;
            sample_NEW = 0;
            sample_count <= 0;
            Right_final_NEW = 1;
            Left_final_NEW = 0;
            Left_tracker = 0;
            Right_Tracker = 0;
           end
   
        end
        
    end    
    
    

if (start_turn)begin

   turn_timer = turn_timer + 1;

   if (turn_timer >= 100000000)begin
       Turn_V_Straight_NEW = 1;
    end
   
   if(Turn_V_Straight)begin
        forward_timer = forward_timer + 1;
        
        if (forward_timer >= 50000000) begin
            turn_timer =0;
            forward_timer = 0;
            sample_NEW = 1;
            start_turn_NEW = 0;
            Turn_V_Straight_NEW = 0;
        end 
   end
   
   
end

        sample = sample_NEW;
        Right_final = Right_final_NEW;
        Left_final = Left_final_NEW;
        Turn_IN = Turn_IN_NEW;
        Turn_V_Straight = Turn_V_Straight_NEW;
        start_turn = start_turn_NEW;

end


assign  FIND_IN_1 = start_turn & ((~Turn_V_Straight  & Turn_IN[1]) | (Turn_V_Straight & Forward_IN[1]));
assign  FIND_IN_2 = start_turn & ((~Turn_V_Straight &  Turn_IN[2]) | (Turn_V_Straight & Forward_IN[2]));
assign  FIND_IN_3 = start_turn & ((~Turn_V_Straight &  Turn_IN[3]) | (Turn_V_Straight & Forward_IN[3]));
assign  FIND_IN_4 = start_turn & ((~Turn_V_Straight &  Turn_IN[4]) | (Turn_V_Straight & Forward_IN[4]));

assign en_A_Find = ~sample;
assign en_B_Find = ~sample;

assign PWM_R = start_turn & ((~Turn_V_Straight & Right_final & PWM_R_R) | (~Turn_V_Straight & Left_final & PWM_R_L) | (Turn_V_Straight & PWM_R_F));
assign PWM_L = start_turn & ((~Turn_V_Straight & Right_final & PWM_L_R) | (~Turn_V_Straight & Left_final & PWM_L_L) | (Turn_V_Straight & PWM_L_F));

assign R_final_signal = Right_final;
assign L_final_signal = Left_final;

endmodule
