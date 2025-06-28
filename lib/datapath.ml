open Hardcaml.Signal

(** A module representing the structure of an input signal *)
module I = struct
  type 'a t = { clock : 'a; suffix : 'a } [@@deriving sexp_of, hardcaml]
end

(** A module representing the structure of an output signal
    - Right now, this just outputs a single 5-bit signal called [pc] consisting
      of "1111" concatenated with the [suffix] from the input record *)
module O = struct
  type 'a t = { pc : 'a [@bits 5] } [@@deriving sexp_of, hardcaml]
end

(** Represents the logic of the circuit *)
let create (i : _ I.t) : _ O.t = { O.pc = of_string "1111" @: i.suffix }
