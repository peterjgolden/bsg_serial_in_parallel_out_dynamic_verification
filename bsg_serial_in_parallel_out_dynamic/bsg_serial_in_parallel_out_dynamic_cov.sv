//
// Peter Golden 4/2026
//
// This module defines functional coverages of module bsg_serial_in_parallel_out_dynamic
//
//

`include "bsg_defines.sv"

module bsg_serial_in_parallel_out_dynamic_cov
  #(parameter max_els_p = 4
    , parameter lg_max_els_lp = $clog2(max_els_p)
    )
  (input clk_i
   , input reset_i

   // selected DUT interface/control signals
   , input v_i
   , input yumi_i
   , input [lg_max_els_lp-1:0] len_i

   // selected DUT internal control/state signals
   , input [lg_max_els_lp-1:0] count_r
   , input [lg_max_els_lp-1:0] len_r
   , input count_r_is_zero
   , input count_r_is_last
   , input clear_li
   , input up_li
   , input dff_en_li
   , input go_fifo_v_li
   , input one_word_lo
   );

  covergroup cg_reset @(negedge clk_i);
    coverpoint reset_i;
  endgroup

  // First word of a packet is being accepted.
  covergroup cg_start @(negedge clk_i iff ~reset_i & dff_en_li);
    cp_v: coverpoint v_i { bins asserted = {1}; }
    cp_len_i: coverpoint len_i {
      bins all_lengths[] = {[0:max_els_p-1]};
    }
    cp_count_zero: coverpoint count_r_is_zero { bins yes = {1}; }
    cp_up: coverpoint up_li;
    cp_clear: coverpoint clear_li;

    cross_all: cross cp_v, cp_len_i, cp_count_zero, cp_up, cp_clear {
      illegal_bins ig0 = cross_all with (cp_v != 1);
      illegal_bins ig1 = cross_all with (cp_count_zero != 1);
    }
  endgroup

  // Middle of a multi-word packet.
  covergroup cg_normal @(negedge clk_i iff ~reset_i & ~count_r_is_zero & ~count_r_is_last);
    cp_v: coverpoint v_i;
    cp_count: coverpoint count_r {
      bins mid_counts[] = {[1:max_els_p-2]};
    }
    cp_len_r: coverpoint len_r {
      bins multi_lengths[] = {[1:max_els_p-1]};
    }
    cp_up: coverpoint up_li;
    cp_clear: coverpoint clear_li;
    cp_one_word: coverpoint one_word_lo { illegal_bins ig = {1}; }
    cp_go_fifo: coverpoint go_fifo_v_li { illegal_bins ig = {1}; }

    cross_all: cross cp_v, cp_count, cp_len_r, cp_up, cp_clear, cp_one_word, cp_go_fifo {
      illegal_bins ig0 = cross_all with (cp_count >= cp_len_r);
      illegal_bins ig1 = cross_all with (cp_one_word != 0);
      illegal_bins ig2 = cross_all with (cp_go_fifo != 0);
      illegal_bins ig3 = cross_all with (cp_clear != 0);
    }
  endgroup

  // Final word of a packet is being accepted.
  covergroup cg_finish @(negedge clk_i iff ~reset_i & count_r_is_last);
    cp_v: coverpoint v_i;
    cp_yumi: coverpoint yumi_i;
    cp_len_r: coverpoint len_r {
      bins all_lengths[] = {[0:max_els_p-1]};
    }
    cp_count: coverpoint count_r {
      bins all_counts[] = {[0:max_els_p-1]};
    }
    cp_clear: coverpoint clear_li;
    cp_up: coverpoint up_li;
    cp_go_fifo: coverpoint go_fifo_v_li;
    cp_one_word: coverpoint one_word_lo;

    cross_all: cross cp_v, cp_yumi, cp_len_r, cp_count, cp_clear, cp_up, cp_go_fifo, cp_one_word {
      illegal_bins ig0 = cross_all with (cp_count != cp_len_r);
      illegal_bins ig1 = cross_all with (cp_clear == 1 && cp_up == 1);
      illegal_bins ig2 = cross_all with (cp_clear == 1 && cp_go_fifo == 0);
      illegal_bins ig3 = cross_all with (cp_one_word == 1 && cp_len_r != 0);
      illegal_bins ig4 = cross_all with (cp_one_word == 0 && cp_len_r == 0);
    }
  endgroup

  cg_reset cov_reset = new;
  cg_start cov_start = new;
  cg_normal cov_normal = new;
  cg_finish cov_finish = new;

  final
  begin
    $display("");
    $display("Instance: %m");
    $display("---------------------- Functional Coverage Results ----------------------");
    $display("Reset        functional coverage is %f%%", cov_reset.get_coverage());
    $display("Packet start functional coverage is %f%%", cov_start.cross_all.get_coverage());
    $display("Packet body  functional coverage is %f%%", cov_normal.cross_all.get_coverage());
    $display("Packet end   functional coverage is %f%%", cov_finish.cross_all.get_coverage());
    $display("-------------------------------------------------------------------------");
    $display("");
  end

endmodule
