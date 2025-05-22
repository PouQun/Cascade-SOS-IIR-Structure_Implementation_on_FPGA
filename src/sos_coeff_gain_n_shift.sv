module sos_coeff_gain_n_shift
 # ( parameter int IIR_WD, COF_WD, SHIFT_NUM )
   (
    input  logic  [IIR_WD-1:0] X,
    input  logic  [COF_WD-1:0] H,
    output logic  [IIR_WD-1:0] P
   );
  
  logic  [IIR_WD+COF_WD-1:0] MUL;
  
 // assign MUL = $signed( X ) * $signed( H );
  
  ip_mult_48x32  MULTIPLE (
                                        .dataa ( X   ),
                                        .datab ( H   ),
                                        .result( MUL ));
  
  assign P   = MUL[IIR_WD-1+SHIFT_NUM:SHIFT_NUM];
  
endmodule: sos_coeff_gain_n_shift