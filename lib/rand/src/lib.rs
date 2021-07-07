use rand::{rngs::OsRng, RngCore};

#[ocaml::func]
pub fn rand_bytes(buf: &mut [u8]) {
    OsRng.fill_bytes(buf);
}
