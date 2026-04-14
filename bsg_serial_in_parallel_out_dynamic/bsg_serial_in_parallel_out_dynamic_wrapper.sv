`timescale 1ns/1ps
`include "bsg_defines.sv"

module bsg_serial_in_parallel_out_dynamic_wrapper
  #(parameter width_p = 8
    , parameter max_els_p = 4
    , parameter lg_max_els_lp = `BSG_SAFE_CLOG2(max_els_p)
    )
  ;

  logic clk_i;
  logic reset_i;

  logic v_i;
  logic [lg_max_els_lp-1:0] len_i;
  logic [width_p-1:0] data_i;
  logic ready_and_o;
  logic len_ready_o;

  logic v_o;
  logic [max_els_p-1:0][width_p-1:0] data_o;
  logic yumi_i;

  bsg_serial_in_parallel_out_dynamic
    #(.width_p(width_p)
      ,.max_els_p(max_els_p)
      ) dut
    (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.v_i(v_i)
     ,.len_i(len_i)
     ,.data_i(data_i)
     ,.ready_and_o(ready_and_o)
     ,.len_ready_o(len_ready_o)
     ,.v_o(v_o)
     ,.data_o(data_o)
     ,.yumi_i(yumi_i)
     );

  bsg_serial_in_parallel_out_dynamic_cov
    #(.width_p(width_p)
      ,.max_els_p(max_els_p)
      ,.lg_max_els_lp(lg_max_els_lp)
      ) cov
    (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.v_i(v_i)
     ,.len_i(len_i)
     ,.ready_and_o(ready_and_o)
     ,.len_ready_o(len_ready_o)
     ,.v_o(v_o)
     ,.yumi_i(yumi_i)
     ,.count_r(dut.count_r)
     ,.len_r(dut.len_r)
     ,.count_r_is_zero(dut.count_r_is_zero)
     ,.count_r_is_last(dut.count_r_is_last)
     ,.clear_li(dut.clear_li)
     ,.up_li(dut.up_li)
     ,.dff_en_li(dut.dff_en_li)
     ,.go_fifo_v_li(dut.go_fifo_v_li)
     ,.one_word_lo(dut.one_word_lo)
     );

endmodule
