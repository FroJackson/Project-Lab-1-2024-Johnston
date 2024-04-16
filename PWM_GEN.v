module PWM_Generator_Find(
    input clk, RvL,
    output reg PWM_R, PWM_L
);

    reg [19:0] width_80;         // Pulse Width
    reg [19:0] width_40;
    reg [19:0] width_90;
    reg [19:0] count;
    initial begin            // Initialize Registers to Zero
        width_80 = 20'd800000;
        width_40 = 20'd400000;
        width_90 = 20'd900000;
        count = 0;
    end

    always@(posedge clk) begin

        count <= count + 1;

    if(~RvL)begin
        if(count < width_40) begin
            PWM_L = 1;
            end
        else begin
            PWM_L = 0;
            end
        if(count < width_90) begin
            PWM_R = 1;
            end
        else begin
            PWM_R = 0;
            end   
    end
    else begin
        if(count < width_80) begin
            PWM_L = 1;
            end
        else begin
            PWM_L = 0;
            end
        if(count < width_40) begin
            PWM_R = 1;
            end
        else begin
            PWM_R = 0;
            end  
    end
    end
endmodule