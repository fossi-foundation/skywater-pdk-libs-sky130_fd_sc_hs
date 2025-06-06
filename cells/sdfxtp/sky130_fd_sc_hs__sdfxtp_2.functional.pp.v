/*
 * Copyright 2020 The SkyWater PDK Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
*/


`ifndef SKY130_FD_SC_HS__SDFXTP_2_FUNCTIONAL_PP_V
`define SKY130_FD_SC_HS__SDFXTP_2_FUNCTIONAL_PP_V

/**
 * sdfxtp: Scan delay flop, non-inverted clock, single output.
 *
 * Verilog simulation functional model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import sub cells.
`include "../u_mux_2/sky130_fd_sc_hs__u_mux_2.v"
`include "../u_df_p_pg/sky130_fd_sc_hs__u_df_p_pg.v"

`celldefine
module sky130_fd_sc_hs__sdfxtp_2 (
    VPWR,
    VGND,
    Q   ,
    CLK ,
    D   ,
    SCD ,
    SCE
);

    // Module ports
    input  VPWR;
    input  VGND;
    output Q   ;
    input  CLK ;
    input  D   ;
    input  SCD ;
    input  SCE ;

    // Local signals
    wire buf_Q  ;
    wire mux_out;

    //                         Delay       Name        Output   Other arguments
    sky130_fd_sc_hs__u_mux_2_1             u_mux_20   (mux_out, D, SCD, SCE             );
    sky130_fd_sc_hs__u_df_p_pg `UNIT_DELAY u_df_p_pg0 (buf_Q  , mux_out, CLK, VPWR, VGND);
    buf                                    buf0       (Q      , buf_Q                   );

endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_HS__SDFXTP_2_FUNCTIONAL_PP_V
