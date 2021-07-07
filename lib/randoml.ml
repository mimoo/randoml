let rand_fill (buf: bytes) = Rand.rand_bytes buf

let rand_bytes len =
  let buf = Bytes.create len in
  rand_fill buf

let rand_bigint _x = failwith "not implemented"

let rand_int32 _ = Rand.rand_int32 ()

let rand_int64 _ = Rand.rand_int64 ()

let rand_int32_range = Rand.rand_int32_range

let rand_int64_range = Rand.rand_int64_range

let rand_bigint lower upper = failwith "not implemented"

(* tests *)

let%test "rand_fill" =
  let buf = Bytes.create 16 in
  let zero_buf = Bytes.create 16 in
  rand_fill buf;
  Bytes.compare zero_buf buf != 0 (* negligible probability *)

let%test "rand_int32" =
  let x = ref Int32.zero in
    for _ = 1 to 4 do
      let y = rand_int32 () in
      x := Int32.add !x y
    done;
  Int32.(compare !x zero) != 0 (* negligible probability *)

let%test "rand_int64" =
  let x = ref Int64.zero in
    for _ = 1 to 2 do
      let y = rand_int64 () in
      x := Int64.add !x y
    done;
  Int64.(compare !x zero) != 0 (* negligible probability *)

let%test "rand_int32_range" =
  let lower = Int32.of_int 1 in
  let upper = Int32.of_int 100000000 in
  let x = rand_int32_range lower upper in
  (Int32.compare x upper) < 0


let%test "rand_int64_range" =
let lower = Int64.of_int 1 in
let upper = Int64.of_int 100000000 in
let x = rand_int64_range lower upper in
(Int64.compare x upper) < 0
