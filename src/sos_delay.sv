module sos_delay
 #( parameter int WD )
  (
    input  logic clk_i,
    input  logic en_i,
    input  logic rst_ni,
  
    input  logic [WD-1:0] in,
  
    output logic [WD-1:0] out
);
  
  always_ff @ ( posedge clk_i, negedge rst_ni ) begin
    if      ( ~rst_ni )  out <= {(WD){1'b0}};
    else if (   en_i  )  out <= in;
    else                 out <= out;
  end
  
endmodule: sos_delay