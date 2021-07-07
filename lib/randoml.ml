
let rand_bytes (buf: bytes) = Rand.rand_bytes buf

let rand_int _x = failwith "not implemented"

let rand_bigint _x = failwith "not implemented"

let%test "rand_bytes" =
  let buf = Bytes.create 16 in
  let zero_buf = Bytes.create 16 in
  rand_bytes buf;
  Bytes.compare zero_buf buf != 0 (* negligible probability *)
