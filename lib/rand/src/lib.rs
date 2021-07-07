use rand::{rngs::OsRng, RngCore};

#[ocaml::func]
pub fn rand_bytes(buf: &mut [u8]) {
    OsRng.fill_bytes(buf);
}

#[ocaml::func]
pub fn rand_int32() -> i32 {
    OsRng.next_u32() as i32
}

#[ocaml::func]
pub fn rand_int64() -> i64 {
    OsRng.next_u64() as i64
}
