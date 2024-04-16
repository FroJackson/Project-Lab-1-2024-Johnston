module OverCurrent (
    input clk,
    input overide,
    output reg enA_OC, enB_OC
);

integer Dbounce = 0;
integer OCtimer = 0;
reg OCreset = 0;
reg [0:29]count = 0;

always@(posedge clk)begin
    count = count + 1;
    if(count >= 100000000)begin
        Dbounce = 0;
        count = 0;
    end
        if(overide)begin
            Dbounce = Dbounce + 1;
            if(Dbounce >= 40000000)begin
                Dbounce = 0;
                OCreset = 1;
            end
        end
  //      else begin
  //          Dbounce =0;
  //      end
    if(OCreset)begin
        OCtimer = OCtimer + 1;
        if(OCtimer >= 300000000)begin
            OCreset = 0;
            OCtimer = 0;
        end
    end
    enA_OC = (OCreset == 0) ? 1:0;
    enB_OC = (OCreset == 0) ? 1:0;
end 
endmodule