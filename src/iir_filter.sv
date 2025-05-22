module iir_filter
import  ae_iir_pkg::*;
 #( parameter int WD, IIR_SOS_NUM, IIR_WD, COF_WD)
  (
    input  logic          clk_i,
    input  logic          en_i,
    input  logic          rst_ni,
  
    input  logic [WD-1:0]  IN,
    output logic [WD-1:0]  OUT
  );
  
  TYDE_SOS_COEFF_DATA_COF_WD    COEFF_SOS_DATA   [IIR_SOS_NUM:1];
  
  sos_coeff_registers    #( .COF_WD( COF_WD ), .IIR_SOS_NUM( IIR_SOS_NUM ))
        FILTERS_COEFF     (
                                              .clk_i (  clk_i         ),
                                              .en_i  (   en_i         ),
                                              .rst_ni(  rst_ni        ),
                                              .sos_o ( COEFF_SOS_DATA );
  
  cascade_sos_iir        #( .COF_WD( COF_WD ), .IIR_SOS_NUM( IIR_SOS_NUM ), .WD( WD ), .IIR_WD( IIR_WD ))
             IIR_FILTER   (
                                              .clk_i       ( clk_i              ),
                                              .en_i        ( en_i               ),
                                              .rst_ni      ( rst_ni             ),
                                              .IN          ( IN                 ),
                                              .COEFF_SOS_IN( COEFF_SOS_DATA     ),
                                              .OUT         ( OUT                ));
  
  
endmodule