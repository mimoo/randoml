use rand::distributions::{Distribution, Uniform};
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

#[ocaml::func]
pub fn rand_int32_range(lower: i32, upper: i32) -> i32 {
    let between = Uniform::from(lower..upper);
    between.sample(&mut OsRng)
}

#[ocaml::func]
pub fn rand_int64_range(lower: i64, upper: i64) -> i64 {
    let between = Uniform::from(lower..upper);
    between.sample(&mut OsRng)
}
