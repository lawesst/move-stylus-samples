// Move Stylus sample: Owned counter (created in init, transferred to sender)
// Unlike shared counter, this one is owned by a single address.
// Build: move-stylus build && move-stylus test

module counter_owned::counter_owned;

use stylus::{
    tx_context::TxContext,
    object::{Self, UID},
    transfer::{Self},
};

#[test_only]
use stylus::test_scenario;

const INITIAL: u64 = 0;

/// Owned counter: only the owner can mutate it.
public struct Counter has key {
    id: UID,
    value: u64,
}

/// Create counter in init and transfer to sender (one per deploy/sender).
entry fun init(ctx: &mut TxContext) {
    let counter = Counter {
        id: object::new(ctx),
        value: INITIAL,
    };
    transfer::transfer(counter, ctx.sender());
}

/// Increment (only owner can call via owned object).
#[ext(owned_objects(counter))]
entry fun increment(counter: &mut Counter) {
    counter.value = counter.value + 1;
}

/// Read value.
#[ext(abi(view), owned_objects(counter))]
entry fun read(counter: &Counter): u64 {
    counter.value
}

/// Set value (owner only).
#[ext(owned_objects(counter))]
entry fun set_value(counter: &mut Counter, value: u64) {
    counter.value = value;
}

//
// Unit tests (we create and own the object in test)
//
#[test]
fun test_increment() {
    let mut ctx = test_scenario::new_tx_context();
    let uid = object::new(&mut ctx);
    let mut c = Counter { id: uid, value: 0 };

    c.increment();
    c.increment();
    assert!(c.read() == 2, 0);

    test_scenario::drop_storage_object(c);
}

#[test]
fun test_set_value() {
    let mut ctx = test_scenario::new_tx_context();
    let uid = object::new(&mut ctx);
    let mut c = Counter { id: uid, value: 5 };

    c.set_value(99);
    assert!(c.read() == 99, 0);

    test_scenario::drop_storage_object(c);
}
