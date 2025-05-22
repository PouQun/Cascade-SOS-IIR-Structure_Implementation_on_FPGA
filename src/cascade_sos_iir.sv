module cascade_sos_iir
import  ae_iir_pkg::*;
 #( parameter int WD, IIR_SOS_NUM, COF_WD ,IIR_WD)
  (
    input  logic          clk_i,
    input  logic          en_i,
    input  logic          rst_ni,
  
    input  logic [WD-1:0] IN,
  
    input  TYDE_SOS_COEFF_DATA_COF_WD  COEFF_SOS_IN   [IIR_SOS_NUM:1],
  
    output logic [WD-1:0] OUT
  );
  
  TYDE_SOS_COEFF_DATA_COF_WD    COEFF_SOS_DATA   [IIR_SOS_NUM:1];
  logic  [IIR_WD-1:0]              IO_SOS_DATA   [IIR_SOS_NUM:0];
  
  assign  COEFF_SOS_DATA = COEFF_SOS_IN;
  
  sos_signed_sample_extend #(.S_WD( WD ), .L_WD( IIR_WD ))
                 IN_EXTEND  (
                                     .data_i  ( IN              ),
                                     .signed_i(           1'b1  ),
                                     .data_o  ( IO_SOS_DATA[0]  ));
  
  genvar i;
  generate
      for (i = 1; i < IIR_SOS_NUM+1 ; i = i + 1) begin : DIRECT_2_TRANS
          direct_ii_second_order_section_iir  #(.IIR_WD(IIR_WD), .COF_WD(COF_WD))
                                        SOS    (
                                                .clk_i          ( clk_i               ),
                                                .en_i           (  en_i               ),
                                                .rst_ni         ( rst_ni              ),
                                                .sample_i       (    IO_SOS_DATA[i-1] ),
                                                .sos_coeff_i    ( COEFF_SOS_DATA[i]   ),
                                                .respond_o      (    IO_SOS_DATA[i]   ));
      end
  endgenerate
  
  assign  OUT  = IO_SOS_DATA[IIR_SOS_NUM][WD-1:0];
  
endmodule