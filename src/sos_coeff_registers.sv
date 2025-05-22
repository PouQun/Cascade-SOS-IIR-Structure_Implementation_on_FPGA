module sos_coeff_registers
import ae_iir_pkg::*;
 #( parameter int COF_WD, IIR_SOS_NUM )
  (
    input  logic  clk_i,
    input  logic  en_i,
    input  logic  rst_ni,

    output  TYDE_SOS_COEFF_DATA_COF_WD  sos_o  [IIR_SOS_NUM  :1]
  );
  
  TYDE_SOS_COEFF_DATA_COF_WD   sos_t         [IIR_SOS_NUM   :1];
  TYDE_SOS_COEFF_ROM_COF_WD    HEX_ROM_DATA  [IIR_SOS_NUM   :1];
  
  logic    [COF_WD-1:0]  h_column_1 [IIR_SOS_NUM -1:0];
  logic    [COF_WD-1:0]  h_column_2 [IIR_SOS_NUM -1:0];
  logic    [COF_WD-1:0]  h_column_3 [IIR_SOS_NUM -1:0];
  logic    [COF_WD-1:0]  h_column_4 [IIR_SOS_NUM -1:0];
  logic    [COF_WD-1:0]  h_column_5 [IIR_SOS_NUM -1:0];
  logic    [COF_WD-1:0]  h_column_6 [IIR_SOS_NUM -1:0];
  
  initial begin
        $readmemh("../samples_filter/matlabs/audio_equalizer_coeff_filters/single_iir/sos_coeff/iir_sos_nxL_n_1.hex",  h_column_1);  // COLUMN 1 of SOS matrix
        $readmemh("../samples_filter/matlabs/audio_equalizer_coeff_filters/single_iir/sos_coeff/iir_sos_nxL_n_2.hex",  h_column_2);  // COLUMN 2 of SOS matrix
        $readmemh("../samples_filter/matlabs/audio_equalizer_coeff_filters/single_iir/sos_coeff/iir_sos_nxL_n_3.hex",  h_column_3);  // COLUMN 3 of SOS matrix
        $readmemh("../samples_filter/matlabs/audio_equalizer_coeff_filters/single_iir/sos_coeff/iir_sos_nxL_n_4.hex",  h_column_4);  // COLUMN 4 of SOS matrix
        $readmemh("../samples_filter/matlabs/audio_equalizer_coeff_filters/single_iir/sos_coeff/iir_sos_nxL_n_5.hex",  h_column_5);  // COLUMN 5 of SOS matrix
        $readmemh("../samples_filter/matlabs/audio_equalizer_coeff_filters/single_iir/sos_coeff/iir_sos_nxL_n_6.hex",  h_column_6);  // COLUMN 6 of SOS matrix
       
        for (int i=1; i<IIR_SOS_NUM+1; i++) begin
                                                 HEX_ROM_DATA[i][1] = h_column_1[i-1];
                                                 HEX_ROM_DATA[i][2] = h_column_2[i-1];
                                                 HEX_ROM_DATA[i][3] = h_column_3[i-1];
                                                 HEX_ROM_DATA[i][4] = h_column_4[i-1];
                                                 HEX_ROM_DATA[i][5] = h_column_5[i-1];
                                                 HEX_ROM_DATA[i][6] = h_column_6[i-1];
        end
  end
  
  genvar k;
  generate
    for (k=1; k<IIR_SOS_NUM+1; k++) begin: SOS_OUT
        assign  sos_t[k].sos_coeff_a = HEX_ROM_DATA[k][6:5];
        assign  sos_t[k].sos_coeff_b = HEX_ROM_DATA[k][3:1];
          
        coeff_regs_cof_wd  #(.COF_WD(COF_WD))
             HB_COEFF_REGS  (
                                        .clk_i      (  clk_i    ),
                                        .en_i       (   en_i    ),
                                        .rst_ni     (  rst_ni   ),
                                        .sos_coeff_i(  sos_t[k] ),
                                        .sos_coeff_o(  sos_o[k] ));
    end
  endgenerate
  
endmodule: sos_coeff_registers

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module coeff_regs_cof_wd
import ae_iir_pkg::*;
 #( parameter int COF_WD )
  (
    input  logic  clk_i,
    input  logic  en_i,
    input  logic  rst_ni,
    
    input   TYDE_SOS_COEFF_DATA_COF_WD  sos_coeff_i,
    output  TYDE_SOS_COEFF_DATA_COF_WD  sos_coeff_o
  );
  
  always_ff@( posedge clk_i, negedge rst_ni ) begin:  REG_BUFFER
    if      ( ~rst_ni  )  begin
                                  sos_coeff_o.sos_coeff_a[2]  <= {(COF_WD){1'b0}};
                                  sos_coeff_o.sos_coeff_a[1]  <= {(COF_WD){1'b0}};
                                  sos_coeff_o.sos_coeff_b[2]  <= {(COF_WD){1'b0}};
                                  sos_coeff_o.sos_coeff_b[1]  <= {(COF_WD){1'b0}};
                                  sos_coeff_o.sos_coeff_b[0]  <= {(COF_WD){1'b0}};
                          end
    else if ( en_i     )  begin
                                  sos_coeff_o.sos_coeff_a[2]  <= sos_coeff_i.sos_coeff_a[2];
                                  sos_coeff_o.sos_coeff_a[1]  <= sos_coeff_i.sos_coeff_a[1];
                                  sos_coeff_o.sos_coeff_b[2]  <= sos_coeff_i.sos_coeff_b[2];
                                  sos_coeff_o.sos_coeff_b[1]  <= sos_coeff_i.sos_coeff_b[1];
                                  sos_coeff_o.sos_coeff_b[0]  <= sos_coeff_i.sos_coeff_b[0];
                          end
    else                  begin
                                  sos_coeff_o.sos_coeff_a[2]  <= sos_coeff_o.sos_coeff_a[2];
                                  sos_coeff_o.sos_coeff_a[1]  <= sos_coeff_o.sos_coeff_a[1];
                                  sos_coeff_o.sos_coeff_b[2]  <= sos_coeff_o.sos_coeff_b[2];
                                  sos_coeff_o.sos_coeff_b[1]  <= sos_coeff_o.sos_coeff_b[1];
                                  sos_coeff_o.sos_coeff_b[0]  <= sos_coeff_o.sos_coeff_b[0];                          end
  end
  
endmodule: coeff_regs_cof_wd

