
val rand_fill : bytes -> unit
(** fills a bytearray with random values *)

val rand_bytes : int -> unit
(** returns a random bytearray of a given length *)

val rand_int32 : unit -> int32
(** returns a random [int32] *)

val rand_int64 : unit -> int64
(** returns a random [int64] *)

val rand_int32_range : int32 -> int32 -> int32
(** returns a random [int32] in the given range. For example `rand_int32_range Int32.((1, 4))` can return numbers from 1 to 4 (including 1 and 4) *)

val rand_int64_range : int64 -> int64 -> int64
(** returns a random [int64] in the given range. For example `rand_int64_range Int64.((1, 4))` can return numbers from 1 to 4 (including 1 and 4) *)

val rand_bigint : Bigint.t -> Bigint.t -> Bigint.t
(** returns a random [Bigint.t] in the given range. Similar to [rand_int] *)
