module syn_gen #(
  parameter H_TOTAL  = 1056, //hor total time
  parameter H_SYNC   =  128, //hor sync time
  parameter H_BPORCH =   88, //hor back porch
  parameter H_RES    =  800, //hor resolution
  parameter V_TOTAL  =  628, //ver total time
  parameter V_SYNC   =    4, //ver sync time
  parameter V_BPORCH =   23, //ver back porch
  parameter V_RES    =  600, //ver resolution
  parameter RD_HRES  =  640,
  parameter RD_VRES  =  480,
  parameter HS_POL   =    1, //HS polarity , 0:neg.polarity, 1:pos.polarity
  parameter VS_POL   =    1  //VS polarity , 0:neg.polarity, 1:pos.polarity
)
(
  input I_pxl_clk, //pixel clock
  input I_rst_n,   //low active

  output reg O_rden,
  output reg O_de,
  output reg O_hs,
  output reg O_vs
);

//====================================================

  reg [15:0] V_cnt;
  reg [15:0] H_cnt;

//-----------------------------------------

  wire Pout_de_w;
  wire Pout_hs_w;
  wire Pout_vs_w;

  reg  Pout_de_dn;
  reg  Pout_hs_dn;
  reg  Pout_vs_dn;

//-----------------------------------------

  wire Rden_w;
  reg  Rden_dn;

//==============================================================================
//Generate HS, VS, DE signals

  always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n)
      V_cnt <= 16'd0;
    else begin
      if ((V_cnt >= (V_TOTAL-1'b1)) && (H_cnt >= (H_TOTAL-1'b1)))
        V_cnt <= 16'd0;
      else if (H_cnt >= (H_TOTAL-1'b1))
        V_cnt <=  V_cnt + 1'b1;
      else
        V_cnt <= V_cnt;
    end
  end

//-------------------------------------------------------------

  always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n)
      H_cnt <= 16'd0;
    else if (H_cnt >= (H_TOTAL-1'b1))
      H_cnt <= 16'd0;
    else
      H_cnt <= H_cnt + 1'b1;
  end

//-------------------------------------------------------------

  assign Pout_de_w = (H_cnt >= (H_SYNC+H_BPORCH)) && (H_cnt <= (H_SYNC+H_BPORCH+H_RES-1'b1)) &&
                     (V_cnt >= (V_SYNC+V_BPORCH)) && (V_cnt <= (V_SYNC+V_BPORCH+V_RES-1'b1));
  assign Pout_hs_w = !((H_cnt >= 16'd0) && (H_cnt <= (H_SYNC-1'b1)));
  assign Pout_vs_w = !((V_cnt >= 16'd0) && (V_cnt <= (V_SYNC-1'b1)));

//==============================================================================

  assign Rden_w = (H_cnt >= (H_SYNC+H_BPORCH)) && (H_cnt <= (H_SYNC+H_BPORCH+RD_HRES-1'b1)) &&
                  (V_cnt >= (V_SYNC+V_BPORCH)) && (V_cnt <= (V_SYNC+V_BPORCH+RD_VRES-1'b1));

  always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n) begin
      Pout_de_dn <= 1'b0;
      Pout_hs_dn <= 1'b1;
      Pout_vs_dn <= 1'b1;
      Rden_dn    <= 1'b0;
    end else begin
      Pout_de_dn <= Pout_de_w;
      Pout_hs_dn <= Pout_hs_w;
      Pout_vs_dn <= Pout_vs_w;
      Rden_dn    <= Rden_w   ;
    end
  end

  always @(posedge I_pxl_clk or negedge I_rst_n) begin
    if (!I_rst_n) begin
      O_de   <= 1'b0;
      O_hs   <= 1'b1;
      O_vs   <= 1'b1;
      O_rden <= 1'b0;
    end else begin
      O_de   <= Pout_de_dn;
      O_hs   <= HS_POL ? ~Pout_hs_dn : Pout_hs_dn;
      O_vs   <= VS_POL ? ~Pout_vs_dn : Pout_vs_dn;
      O_rden <= Rden_dn;
    end
  end

endmodule
