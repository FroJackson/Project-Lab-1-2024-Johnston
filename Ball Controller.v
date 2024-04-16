module Ball_Controller(
    input clk, k1, k10, T_C, PR, enA_OC, enB_OC,
 //   output reg LED1, //output reg GRAB_FIRE,
    output reg [4:1]IN,
    output reg [0:1]Encoder_Turn,
    output reg Turn_Start
);
   
reg S_C = 0;
reg PR_Latch = 0;
reg Latch = 0;
reg G_C = 0;
reg LEDON = 0;
reg Turn_Start_Hold = 0;
parameter Short_Right = 2'b01;
parameter Short_Left = 2'b10;


always @(posedge clk) begin
    if(PR & ~PR_Latch)begin
        LEDON = 1;//GRAB_FIRE = 0;
        PR_Latch = 1;
 
    end
    
    if(~S_C & PR_Latch)begin
        IN = 4'b0101;
        if(k1|k10)begin
            IN = 4'b0000;
            S_C = 1;
        end
    end


    if (S_C) begin
        if (~T_C)begin
            if (k1) begin
                Encoder_Turn = Short_Right;
                Turn_Start_Hold = 1;
            end
            if (k10) begin
                Encoder_Turn = Short_Left;
                Turn_Start_Hold = 1;
            end
        end
        else begin
            LEDON = 1;//GRAB_FIRE = 1;
        end
    end        
//       LED1 = LEDON;
    Turn_Start = Turn_Start_Hold;
end   
endmodule
/*module Sweeper(
    input clk,
    input k1, k10, OvC, T_C, E_R_Turn, E_L_Turn,
    output reg Turn_Completed = 0, IN1 = 0, IN2  = 0, IN3  = 0, IN4  = 0, RvL_duty_cycle = 1,
    output reg S_R_Turn = 0, S_L_Turn = 0, override = 0
    );
   


   localparam [2:0] Right = 0, //2 bit local vector parameter since there are 3 states, requiring 2 bits to represent them all, must match the size of the state encoding
                    Short_Right = 1, //the list after the the names and parameters for each state in the system
                    Short_Left = 2, //each state should be assigned with a unique value 0,1,2,3 etc...
                    Overcurrent = 3,
                    Completed = 4;

   reg [2:0] Sweeper_State; // vector variable to represent each state which is 2 bits to match the size of the state encoding
   reg complete = 0;
                     //Notice the initial state is undeclared here
   always @(posedge clk) begin //
    if(~complete)begin
         Sweeper_State = Right;


         case (Sweeper_State) // the case statements specify state transitions
            Right: begin
               if (k1 && ~OvC) begin
                  Sweeper_State = Short_Right;
               end
               else if (k10 && ~OvC) begin
                  Sweeper_State = Short_Left;
               end
               else if (OvC) begin
                  Sweeper_State = Overcurrent;
               end
               else if (~k1 && ~k10) begin
                
                  Sweeper_State = Right;
               end
            end

            Short_Right: begin
               if (OvC) begin
                  Sweeper_State = Overcurrent;
               end
               else if (T_C) begin
                  Sweeper_State = Completed;
               end
            end

            Short_Left: begin
               if (OvC) begin
                  Sweeper_State = Overcurrent;
               end
               else if (T_C) begin
                  Sweeper_State = Completed;
               end
            end

            Overcurrent: begin
               if (OvC) begin
                  Sweeper_State = Overcurrent;
               end
               else if (k10 && ~OvC) begin
                  Sweeper_State = Short_Left;
               end
               else if (k1 && ~OvC) begin
                  Sweeper_State = Short_Right;
               end
               else if (~k1 && ~k10 && ~OvC) begin
                  Sweeper_State = Right;
               end
            end

            Completed: begin
               Sweeper_State = Completed;
            end

            default: begin
               Sweeper_State = Right;
            end
         endcase

      // State actions
      case (Sweeper_State) //state actions
         Right: begin 
            {RvL_duty_cycle,Ball_Collected} = 2'b10;     //Turn Right 
            {IN1,IN2,IN3,IN4}=4'b0000;                             //Turn Right
            {S_R_Turn,S_L_Turn,override} = 3'b000;
         end

         Short_Right: begin
            {S_R_Turn,S_L_Turn,override} = 3'b100;                 // Setting Turn control R on
         end

         Short_Left: begin
            {S_R_Turn,S_L_Turn,override} = 3'b010;                 // Setting Turn Control L on
         end

         Overcurrent: begin
            {S_R_Turn,S_L_Turn,override} = 3'b001;              //Setting overcurrent protection verilog on
         end

         Completed: begin
            Turn_Completed = 1;
            complete = 1;
         end

         default: begin
            {RvL_duty_cycle,Ball_Collected} = 2'b10;
            {IN1,IN2,IN3,IN4}=4'b0000;
            {S_R_Turn,S_L_Turn,override} = 3'b000; 
         end
      endcase
   end
end
endmodule*/