open Core_kernel

(** some internal helper functions *)
module Utils = struct
  (** converts [bytes] encoded in little-endian into a [Bigint.t] *)
  let bigint_of_bytes (bytearray : bytes) =
    let f offset acc byte =
      let num = Bigint.of_int @@ int_of_char byte in
      let offset = offset * 8 in
      let num = Bigint.(num lsl offset) in
      Bigint.(acc + num)
    in
    Bytes.foldi bytearray ~init:Bigint.zero ~f

  (** return number of bits in number *)
  let rec num_bits ?(num = 0) (x : Bigint.t) =
    if Bigint.(x = zero) then num
    else num_bits ~num:(num + 1) (Bigint.shift_right x 1)

  (** clear useless bits in a random value (assuming little-endian) *)
  let clear_bits buf to_keep =
    let mask = (1 lsl to_keep) - 1 in
    let last_idx = Bytes.length buf - 1 in
    let last_byte = Bytes.get buf last_idx |> int_of_char in
    let last_byte = last_byte land mask |> char_of_int in
    Bytes.set buf last_idx last_byte

  (* tests *)

  let%test_unit "clear_bits" =
    let buf = Bytes.of_char_list [ '\xff'; '\xff' ] in
    clear_bits buf 8;
    assert (Char.(Bytes.get buf 1 = '\xff'));
    clear_bits buf 7;
    assert (Char.(Bytes.get buf 1 = '\x7f'));
    clear_bits buf 6;
    assert (Char.(Bytes.get buf 1 = '\x3f'));
    clear_bits buf 5;
    assert (Char.(Bytes.get buf 1 = '\x1f'));
    clear_bits buf 4;
    assert (Char.(Bytes.get buf 1 = '\x0f'));
    clear_bits buf 3;
    assert (Char.(Bytes.get buf 1 = '\x07'));
    clear_bits buf 2;
    assert (Char.(Bytes.get buf 1 = '\x03'));
    clear_bits buf 1;
    assert (Char.(Bytes.get buf 1 = '\x01'));
    clear_bits buf 0;
    assert (Char.(Bytes.get buf 1 = '\x00'))
end

(* implementations *)

let rand_fill (buf : bytes) = Rand.rand_bytes buf

let rand_bytes len =
  let buf = Bytes.create len in
  rand_fill buf;
  buf

let rand_int32 _ = Rand.rand_int32 ()

let rand_int64 _ = Rand.rand_int64 ()

let rand_int32_range = Rand.rand_int32_range

let rand_int64_range = Rand.rand_int64_range

let rand_bigint (upperbound : Bigint.t) =
  (* generated random values until it's smaller than the upperbound *)
  let rec loop ~to_keep ~bytes ~upperbound =
    let buf = rand_bytes bytes in
    Utils.clear_bits buf to_keep;
    let num = Utils.bigint_of_bytes buf in
    if Bigint.(num < upperbound) then num else loop ~to_keep ~bytes ~upperbound
  in
  if Bigint.(upperbound < Bigint.one) then Bigint.zero
  else
    let bits = Utils.num_bits upperbound in
    let to_keep = bits mod 8 in
    let to_keep = if to_keep = 0 then 8 else to_keep in
    let bytes = (bits + 7) / 8 in
    (* attempt to generate until it works. This will work well if the upperbound is close to a power of two, otherwise... *)
    loop ~to_keep ~bytes ~upperbound

(* tests *)

let%test "rand_fill" =
  let buf = Bytes.create 16 in
  let zero_buf = Bytes.create 16 in
  rand_fill buf;
  (* negligible probability *)
  Bytes.compare zero_buf buf <> 0

let%test "rand_int32" =
  let x = ref Int32.zero in
  for _ = 1 to 4 do
    let y = rand_int32 () in
    x := Int32.(!x + y)
  done;
  (* negligible probability *)
  Int32.(compare !x zero) <> 0

let%test "rand_int64" =
  let x = ref Int64.zero in
  for _ = 1 to 2 do
    let y = rand_int64 () in
    x := Int64.(!x + y)
  done;
  (* negligible probability *)
  Int64.(compare !x zero) <> 0

let%test "rand_int32_range" =
  let lower = Int32.of_int_exn 1 in
  let upper = Int32.of_int_exn 100000000 in
  let x = rand_int32_range lower upper in
  Int32.(x < upper)

let%test "rand_int64_range" =
  let lower = Int64.of_int_exn 1 in
  let upper = Int64.of_int_exn 100000000 in
  let x = rand_int64_range lower upper in
  Int64.(x < upper)

let%test "rand_bigint" =
  let upperbound =
    Bigint.of_string
      "7067388259113537318333190002971674063309935587502475832486424805170478604"
  in
  let x = rand_bigint upperbound in
  Bigint.(x < upperbound)
