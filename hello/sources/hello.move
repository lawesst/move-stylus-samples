// Minimal Move Stylus sample
// Build: move-stylus build && move-stylus test

module hello::hello;

entry fun hello_world(): vector<u8> {
    b"hello world"
}

#[test]
fun test_hello() {
    assert!(hello_world() == b"hello world", 1);
}
