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


`ifndef SKY130_FD_SC_HS__DLXBP_1_TIMING_PP_V
`define SKY130_FD_SC_HS__DLXBP_1_TIMING_PP_V

/**
 * dlxbp: Delay latch, non-inverted enable, complementary outputs.
 *
 * Verilog simulation timing model.
 */

`timescale 1ns / 1ps
`default_nettype none

// Import sub cells.
`include "../u_dl_p_no_pg/sky130_fd_sc_hs__u_dl_p_no_pg.v"

`celldefine
module sky130_fd_sc_hs__dlxbp_1 (
    VPWR,
    VGND,
    Q   ,
    Q_N ,
    D   ,
    GATE
);

    // Module ports
    input  VPWR;
    input  VGND;
    output Q   ;
    output Q_N ;
    input  D   ;
    input  GATE;

    // Local signals
    wire       GATE_delayed;
    wire       D_delayed   ;
    reg        notifier    ;
    wire       buf_Q       ;
    wire       awake       ;

    //                            Name           Output  Other arguments
    sky130_fd_sc_hs__u_dl_p_no_pg u_dl_p_no_pg0 (buf_Q , D_delayed, GATE_delayed, notifier, VPWR, VGND);
    buf                           buf0          (Q     , buf_Q                                        );
    not                           not0          (Q_N   , buf_Q                                        );
    assign awake = ( VPWR === 1'b1 );

specify
( D +=> Q ) = ( 0:0:0 , 0:0:0 ) ;  // delays are tris , tfall
( D -=> Q_N ) = ( 0:0:0 , 0:0:0 ) ;  // delays are tris , tfall
( posedge GATE => ( Q +: D ) ) = ( 0:0:0 , 0:0:0 ) ; // delays are tris , tfall
( posedge GATE => ( Q_N -: D ) ) = ( 0:0:0 , 0:0:0 ) ; // delays are  tris , tfall
$width ( posedge GATE &&& awake , 1.0:1.0:1.0 , 0 , notifier ) ;
$width ( negedge GATE &&& awake , 1.0:1.0:1.0 , 0 , notifier ) ;
$setuphold ( negedge GATE , posedge D , 0:0:0 , 0:0:0 , notifier , awake , awake , GATE_delayed , D_delayed ) ;
$setuphold ( negedge GATE , negedge D , 0:0:0 , 0:0:0 , notifier , awake , awake , GATE_delayed , D_delayed ) ;
endspecify
endmodule
`endcelldefine

`default_nettype wire
`endif  // SKY130_FD_SC_HS__DLXBP_1_TIMING_PP_V
