module Flip_Flop(clk,D,Q);
    input clk,D;
    output reg Q=0;
    always @(posedge clk) begin
        Q=D;
    end
endmodule
// The above sets up a D-flip-flop that is used twice
// It is sets the left mic as the Clk input of the 1st D FF and the right mic as a D input
// The 2nd FF is set with the output of the 1st Q1 and the clk from the basys 2 board to sync the 
// input of the signals to the board to avoid timing issues with the FFs


module MicFlip_Flops(input clk,RightMic,LeftMic, output RvL);
    reg Neg_RMic = 0, Neg_LMic=0, Pos_RMic, Pos_LMic;
    wire Q1,L,R;

    // posegde and negedge the clock to work around not being able to update
    // the always block anytime the clk changes naturally
    always@(posedge clk) begin
        Pos_RMic=RightMic;
        Pos_LMic=LeftMic;
    end
    always@(negedge clk) begin
        Neg_RMic=RightMic;
        Neg_LMic=LeftMic;
    end
    assign L = Pos_LMic|Neg_LMic;
    assign R = Pos_RMic|Neg_RMic;
    Flip_Flop S0(L,R,Q1);
    Flip_Flop S1(clk,Q1,RvL);
endmodule
