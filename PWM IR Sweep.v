module PWM_Generator(
    //input [1:0] sw2,        // Controll Input (0%-100%)
    input clk_100MHz,
    output PWM
);

    reg [19:0] width = 20'd750000;         // Pulse Width
    reg [4:0] out_PWM;       // For Output Minipulation
    reg [19:0] count;

    initial begin            // Initialize Registers to Zero
        //width = 0;
        out_PWM = 0;
        count = 0;
    end

    always@(posedge clk_100MHz) begin

            count = count + 1;

        if(count < width)
            out_PWM = 1;
        else
            out_PWM = 0;

    end


    /*
    always@(*)begin
        case(sw2)
            2'd0 : width = 20'd0;     // 0% Duty
            2'd1 : width = 20'd500000;    // 50% Duty
            2'd2 : width = 20'd600000;    // 65% Duty
            2'd3 : width = 20'd750000;    // 75% Duty
            default : width = 20'd0;
        endcase
    end */

    assign PWM = out_PWM;

endmodule