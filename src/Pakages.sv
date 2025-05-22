package ae_iir_pkg;
  
  parameter int  IIR_WD      = 48;
  parameter int  COF_WD      = 32;
  parameter int  IIR_N_TAP   = 12;
  parameter int  IIR_SOS_NUM =  6;  // The number of SOS-matrix's row // The number of sections

  typedef logic [IIR_WD-1:0] TYDE_SOS_COEFF_ROM        [6:1]; // the sos's coeff (for 1 section only)
  typedef logic [COF_WD-1:0] TYDE_SOS_COEFF_ROM_COF_WD [6:1]; // the sos's coeff (for 1 section only)

  typedef struct {
       logic [IIR_WD-1:0] sos_coeff_a [2:1];
       logic [IIR_WD-1:0] sos_coeff_b [2:0];
  } TYDE_SOS_COEFF_DATA_IIR_WD;
  
  typedef struct {
       logic [COF_WD-1:0] sos_coeff_a [2:1];
       logic [COF_WD-1:0] sos_coeff_b [2:0];
  } TYDE_SOS_COEFF_DATA_COF_WD;
  
endpackage: ae_iir_pkg