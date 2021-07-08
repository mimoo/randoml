(lang dune 2.8)

(generate_opam_files true)

(source
 (github mimoo/randoml))

(license ISC)

(authors "David Wong")

(maintainers "david@o1labs.org")

(package
 (name randoml)
 (synopsis "Generating cryptographically-secure random numbers")
 (description
  "A library relying on Rust rand to generate random numbers. The random numbers are cryptographically secure.")
 (depends
  (bignum
   (>= v0.14.0))
  (dune
   (>= 2.8.0))
  (ppx_inline_test
   (and
    :with-test
    (>= v0.14.1)))
  (core_kernel
   (> v0.14.0))
  (bignum.bigint
   (> v0.14.0))))
