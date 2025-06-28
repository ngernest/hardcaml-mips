open Hardcaml
open Hardcaml_waveterm
open Mips.Datapath

(* Adapted from
   https://blog.janestreet.com/using-ascii-waveforms-to-test-hardware-designs/ *)

(* Create a simulation module by passing the input/output modules to a
   functor *)
module Simulator = Cyclesim.With_interface (I) (O)

let testbench () : Waveform.t =
  let sim = Simulator.create create in
  let waves, sim = Waveform.create sim in
  let inputs = Cyclesim.inputs sim in
  let step ~(suffix : int) : unit =
    inputs.suffix := if suffix = 1 then Bits.vdd else Bits.gnd;
    Cyclesim.cycle sim in
  step ~suffix:0;
  step ~suffix:1;
  step ~suffix:1;
  step ~suffix:0;
  step ~suffix:1;
  step ~suffix:0;
  waves

let%expect_test "basic" =
  let waves = testbench () in
  Waveform.print ~display_height:8 waves;
  [%expect
    {|
    ┌Signals────────┐┌Waves──────────────────────────────────────────────┐
    │suffix         ││        ┌───────────────┐       ┌───────┐          │
    │               ││────────┘               └───────┘       └───────   │
    │               ││────────┬───────────────┬───────┬───────┬───────   │
    │pc             ││ 1E     │1F             │1E     │1F     │1E        │
    │               ││────────┴───────────────┴───────┴───────┴───────   │
    │               ││                                                   │
    └───────────────┘└───────────────────────────────────────────────────┘
  |}]
