
val rand_bytes : bytes -> unit
(** fills a bytearray with random values *)

val rand_int : int * int -> int
(** returns a random [int] in the given range. For example rand_int (1, 4) can return numbers from 1 to 4 (including 1 and 4) *)

val rand_bigint : Bigint.t * Bigint.t -> Bigint.t
(** Returns a random [Bigint.t] in the given range. Similar to [rand_int] *)
