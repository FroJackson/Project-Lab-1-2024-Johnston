module PWM_Generator_Find(
    input clk, RvL,
    output reg PWM_R, PWM_L
);

    reg [19:0] width_65 = 20'd650000;         // Pulse Width
    reg [19:0] width_25 = 20'd300000;
    reg [19:0] width_90 = 20'd900000;
    reg [19:0] width_50 = 20'd500000;
    reg [19:0] count = 0;

    always@(posedge clk) begin

        count <= count + 1;

    if(~RvL)begin
        if(count < width_25) begin
            PWM_R = 1;
            end
        else begin
            PWM_R = 0;
            end
        if(count < width_90) begin
            PWM_L = 1;
            end
        else begin
            PWM_L = 0;
            end   
    end
    else if (RvL) begin
        if(count < width_50) begin
            PWM_R = 1;
            end
        else begin
            PWM_R = 0;
            end
        if(count < width_90) begin
            PWM_L = 1;
            end
        else begin
            PWM_L = 0;
            end  
    end
    end
endmodule
