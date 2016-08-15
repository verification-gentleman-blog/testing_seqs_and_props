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


module props_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  `include "vgm_svunit_utils_macros.svh"

  string name = "props_ut";
  svunit_testcase svunit_ut;

  import vgm_ahb::*;


  bit clk;
  always #1 clk = ~clk;

  default clocking @(posedge clk);
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

    `SVTEST(drive_awvalid__with_delay)
      `FAIL_IF(1)
    `SVTEST_END

  `SVUNIT_TESTS_END


  task reset_signals();
  endtask

endmodule
