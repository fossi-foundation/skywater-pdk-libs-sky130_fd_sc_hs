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


`ifndef SKY130_FD_SC_HS__SDFXBP_2_TIMING_V
`define SKY130_FD_SC_HS__SDFXBP_2_TIMING_V

/**
 * sdfxbp: Scan delay flop, non-inverted clock, complementary outputs.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import sub cells.
`include "../u_mux_2/sky130_fd_sc_hs__u_mux_2.v"
`include "../u_df_p_no_pg/sky130_fd_sc_hs__u_df_p_no_pg.v"

`celldefine
module sky130_fd_sc_hs__sdfxbp_2 (
    CLK ,
    D   ,
    Q   ,
    Q_N ,
    SCD ,
    SCE ,
    VPWR,
    VGND
);

    // Module ports
    input  CLK ;
    input  D   ;
    output Q   ;
    output Q_N ;
    input  SCD ;
    input  SCE ;
    input  VPWR;
    input  VGND;

    // Local signals
    wire buf_Q      ;
    wire mux_out    ;
    reg  notifier   ;
    wire D_delayed  ;
    wire SCD_delayed;
    wire SCE_delayed;
    wire CLK_delayed;
    wire awake      ;
    wire cond1      ;
    wire cond2      ;
    wire cond3      ;

    //                            Name           Output   Other arguments
    sky130_fd_sc_hs__u_mux_2_1    u_mux_20      (mux_out, D_delayed, SCD_delayed, SCE_delayed       );
    sky130_fd_sc_hs__u_df_p_no_pg u_df_p_no_pg0 (buf_Q  , mux_out, CLK_delayed, notifier, VPWR, VGND);
    assign awake = ( VPWR === 1'b1 );
    assign cond1 = ( ( SCE_delayed === 1'b0 ) && awake );
    assign cond2 = ( ( SCE_delayed === 1'b1 ) && awake );
    assign cond3 = ( ( D_delayed !== SCD_delayed ) && awake );
    buf                           buf0          (Q      , buf_Q                                     );
    not                           not0          (Q_N    , buf_Q                                     );

specify
( posedge CLK => ( Q : CLK ) ) = ( 0:0:0 , 0:0:0 ) ; // delays are tris , tfall
( posedge CLK => ( Q_N : CLK ) ) = ( 0:0:0 , 0:0:0 ) ; // delays are tris , tfall
$setuphold ( posedge CLK , posedge D , 0:0:0 , 0:0:0 , notifier , cond1 , cond1 , CLK_delayed , D_delayed ) ;
$setuphold ( posedge CLK , negedge D , 0:0:0 , 0:0:0 , notifier , cond1 , cond1 , CLK_delayed , D_delayed ) ;
$setuphold ( posedge CLK , posedge SCD , 0:0:0 , 0:0:0 , notifier , cond2 , cond2 , CLK_delayed , SCD_delayed ) ;
$setuphold ( posedge CLK , negedge SCD , 0:0:0 , 0:0:0 , notifier , cond2 , cond2 , CLK_delayed , SCD_delayed ) ;
$setuphold ( posedge CLK , posedge SCE , 0:0:0 , 0:0:0 , notifier , cond3 , cond3 , CLK_delayed , SCE_delayed ) ;
$setuphold ( posedge CLK , negedge SCE , 0:0:0 , 0:0:0 , notifier , cond3 , cond3 , CLK_delayed , SCE_delayed ) ;
$width ( posedge CLK &&& awake , 1.0:1.0:1.0 , 0 , notifier ) ;
$width ( negedge CLK &&& awake , 1.0:1.0:1.0 , 0 , notifier ) ;
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_HS__SDFXBP_2_TIMING_V
