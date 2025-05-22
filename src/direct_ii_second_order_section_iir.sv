module direct_ii_second_order_section_iir
import ae_iir_pkg::*;
  #( parameter int IIR_WD, COF_WD )
   (
    input  logic  clk_i,
    input  logic  en_i,
    input  logic  rst_ni,
  
    input  logic  [IIR_WD-1:0]  sample_i,
  
    input  TYDE_SOS_COEFF_DATA_COF_WD  sos_coeff_i,
  
    output logic  [IIR_WD-1:0]  respond_o
   );
  
  logic [IIR_WD-1:0]   sample_0 ;
  logic [IIR_WD-1:0]    sum_w_0 ;
  logic [IIR_WD-1:0]   gain_w_0 ;
  logic [IIR_WD-1:0]    sum_y_0 ;
  
  logic [IIR_WD-1:0]  delay_w_1   ;
  logic [IIR_WD-1:0]   gain_w_1_a ;
  logic [IIR_WD-1:0]   gain_w_1_b ;
  
  logic [IIR_WD-1:0]  delay_w_2   ;
  logic [IIR_WD-1:0]   gain_w_2_a ;
  logic [IIR_WD-1:0]   gain_w_2_b ;
  
  logic [IIR_WD-1:0]    sum_w_21_a ;
  logic [IIR_WD-1:0]    sum_w_21_b ;
  
  logic [COF_WD-1:0]  a_coeff_to_mul [2:1] ;
  logic [COF_WD-1:0]  b_coeff_to_mul [2:0] ;
  
  assign sample_0 = sample_i;
  
  assign a_coeff_to_mul [2] = ~ sos_coeff_i.sos_coeff_a[2] + {{(COF_WD-1){1'b0}}, 1'b1};
  assign a_coeff_to_mul [1] = ~ sos_coeff_i.sos_coeff_a[1] + {{(COF_WD-1){1'b0}}, 1'b1};
  
  assign b_coeff_to_mul [2] =   sos_coeff_i.sos_coeff_b[2];
  assign b_coeff_to_mul [1] =   sos_coeff_i.sos_coeff_b[1];
  assign b_coeff_to_mul [0] =   sos_coeff_i.sos_coeff_b[0];
  
  sos_coeff_gain_n_shift  #(.IIR_WD(IIR_WD), .COF_WD(COF_WD), .SHIFT_NUM(20))  MUL_W0   ( .X(   sum_w_0   ), .H( b_coeff_to_mul[0] ), .P( gain_w_0   ));
  sos_coeff_gain_n_shift  #(.IIR_WD(IIR_WD), .COF_WD(COF_WD), .SHIFT_NUM(20))  MUL_W1A  ( .X( delay_w_1   ), .H( a_coeff_to_mul[1] ), .P( gain_w_1_a ));
  sos_coeff_gain_n_shift  #(.IIR_WD(IIR_WD), .COF_WD(COF_WD), .SHIFT_NUM(20))  MUL_W1B  ( .X( delay_w_1   ), .H( b_coeff_to_mul[1] ), .P( gain_w_1_b ));
  sos_coeff_gain_n_shift  #(.IIR_WD(IIR_WD), .COF_WD(COF_WD), .SHIFT_NUM(20))  MUL_W2A  ( .X( delay_w_2   ), .H( a_coeff_to_mul[2] ), .P( gain_w_2_a ));
  sos_coeff_gain_n_shift  #(.IIR_WD(IIR_WD), .COF_WD(COF_WD), .SHIFT_NUM(20))  MUL_W2B  ( .X( delay_w_2   ), .H( b_coeff_to_mul[2] ), .P( gain_w_2_b ));
  
  sos_add          #(.WD(IIR_WD))                  ADD_W0   ( .A(  sample_0   ), .B(   sum_w_21_a      ), .S( sum_w_0      ));
  sos_add          #(.WD(IIR_WD))                  ADD_Y0   ( .A(  gain_w_0   ), .B(   sum_w_21_b      ), .S( sum_y_0      ));
  sos_add          #(.WD(IIR_WD))                  ADD_W21A ( .A(  gain_w_1_a ), .B(  gain_w_2_a       ), .S( sum_w_21_a   ));
  sos_add          #(.WD(IIR_WD))                  ADD_W21B ( .A(  gain_w_1_b ), .B(  gain_w_2_b       ), .S( sum_w_21_b   ));
  
  sos_delay  #(.WD(IIR_WD))   DELAY_01 ( .clk_i( clk_i  ), .en_i( en_i ), .rst_ni( rst_ni ), .in(   sum_w_0 ), .out( delay_w_1 ));
  sos_delay  #(.WD(IIR_WD))   DELAY_12 ( .clk_i( clk_i  ), .en_i( en_i ), .rst_ni( rst_ni ), .in( delay_w_1 ), .out( delay_w_2 ));
  
  assign respond_o = sum_y_0;
  
endmodule: direct_ii_second_order_section_iir