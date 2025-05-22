module sos_add
 # ( parameter int WD )
   (
    input  logic [WD-1:0] A,
    input  logic [WD-1:0] B,
    output logic [WD-1:0] S
   );
  
  assign S = A + B ;
  
endmodule: sos_add