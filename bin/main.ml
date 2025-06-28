open Hardcaml
open Mips
module MipsCircuit = Circuit.With_interface (Datapath.I) (Datapath.O)

let circuit : Circuit.t =
  MipsCircuit.create_exn Datapath.create ~name:"datapath"

(* Produces the equivalent Verilog circuit *)
let () = Rtl.print Verilog circuit
