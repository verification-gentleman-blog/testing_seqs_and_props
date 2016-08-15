// Copyright 2016 Tudor Timisescu (verificationgentleman.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


module seqs_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  `include "vgm_svunit_utils_macros.svh"

  string name = "seqs_ut";
  svunit_testcase svunit_ut;

  import vgm_ahb::*;


  bit HCLK;
  bit [1:0] HTRANS;
  bit HREADY;


  always #1 HCLK = ~HCLK;

  default clocking cb @(posedge HCLK);
    inout HTRANS;
    inout HREADY;
  endclocking


  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
    reset_signals();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask



  `SVUNIT_TESTS_BEGIN

    `SVTEST(trans_started__idle__doesnt_match)
      `FAIL_IF_SEQ(trans_started(HTRANS, HREADY))
    `SVTEST_END


    `SVTEST(trans_started__coming_from_idle__matches)
      cb.HTRANS <= NONSEQ;

      `FAIL_UNLESS_SEQ(trans_started(HTRANS, HREADY))
    `SVTEST_END


    `SVTEST(trans_started__continuing_trans__doesnt_match)
      cb.HTRANS <= NONSEQ;
      cb.HREADY <= 0;

      // Can't use this, because of usage of $past(...) in the sequence under
      // test. The $past(...) will always return the default value of the
      // expression.
      //##1;
      //`FAIL_IF_SEQ(trans_started(HTRANS, HREADY))

      `FAIL_IF_SEQ(##1 trans_started(HTRANS, HREADY))
    `SVTEST_END


    `SVTEST(trans_started__after_done_trans__matches)
      cb.HTRANS <= NONSEQ;
      cb.HREADY <= 1;

      `FAIL_UNLESS_SEQ(##1 trans_started(HTRANS, HREADY))
    `SVTEST_END

  `SVUNIT_TESTS_END


  task reset_signals();
    HTRANS <= IDLE;
    HREADY <= 1;
    ##1;
  endtask

endmodule
