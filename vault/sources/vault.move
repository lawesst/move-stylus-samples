// Move Stylus sample: Vault contract
// Shared vault: anyone can deposit; only owner can withdraw.
// Build: move-stylus build && move-stylus test

module vault::vault;

use stylus::{
    tx_context::TxContext,
    object::{Self, UID},
    transfer::{Self},
};

#[test_only]
use stylus::test_scenario;

/// Shared vault: holds balance, only owner can withdraw.
public struct Vault has key {
    id: UID,
    owner: address,
    balance: u64,
}

/// Create a new vault (caller becomes owner).
entry fun create(ctx: &mut TxContext) {
    transfer::share_object(Vault {
        id: object::new(ctx),
        owner: ctx.sender(),
        balance: 0,
    });
}

/// Deposit into the vault (anyone).
#[ext(shared_objects(vault))]
entry fun deposit(vault: &mut Vault, amount: u64) {
    vault.balance = vault.balance + amount;
}

/// Withdraw from the vault (owner only).
#[ext(shared_objects(vault))]
entry fun withdraw(vault: &mut Vault, amount: u64, ctx: &TxContext) {
    assert!(ctx.sender() == vault.owner, 1); // ENotOwner
    assert!(vault.balance >= amount, 2);        // EInsufficientBalance
    vault.balance = vault.balance - amount;
}

/// Read vault balance.
#[ext(abi(view), shared_objects(vault))]
entry fun balance(vault: &Vault): u64 {
    vault.balance
}

/// Read vault owner.
#[ext(abi(view), shared_objects(vault))]
entry fun owner(vault: &Vault): address {
    vault.owner
}

//
// Unit tests
//
#[test]
fun test_deposit_and_balance() {
    let mut ctx = test_scenario::new_tx_context();
    let uid = object::new(&mut ctx);
    let mut v = Vault { id: uid, owner: @0x1, balance: 0 };

    v.deposit(100);
    assert!(v.balance() == 100, 0);
    v.deposit(50);
    assert!(v.balance() == 150, 0);

    test_scenario::drop_storage_object(v);
}

#[test]
fun test_withdraw_by_owner() {
    let mut ctx = test_scenario::new_tx_context();
    test_scenario::set_sender_address(@0x1);
    let uid = object::new(&mut ctx);
    let mut v = Vault { id: uid, owner: @0x1, balance: 200 };

    v.withdraw(70, &ctx);
    assert!(v.balance() == 130, 0);
    v.withdraw(130, &ctx);
    assert!(v.balance() == 0, 0);

    test_scenario::drop_storage_object(v);
}

#[test, expected_failure]
fun test_withdraw_not_owner_fails() {
    test_scenario::set_sender_address(@0x99);
    let mut ctx = test_scenario::new_tx_context();
    let uid = object::new(&mut ctx);
    let mut v = Vault { id: uid, owner: @0x1, balance: 100 };

    v.withdraw(50, &ctx);

    test_scenario::drop_storage_object(v);
}

#[test, expected_failure]
fun test_withdraw_insufficient_balance_fails() {
    let mut ctx = test_scenario::new_tx_context();
    let uid = object::new(&mut ctx);
    let mut v = Vault { id: uid, owner: test_scenario::default_sender(), balance: 10 };

    v.withdraw(20, &ctx);

    test_scenario::drop_storage_object(v);
}

#[test]
fun test_owner_view() {
    let mut ctx = test_scenario::new_tx_context();
    let uid = object::new(&mut ctx);
    let v = Vault { id: uid, owner: @0xAB, balance: 0 };

    assert!(v.owner() == @0xAB, 0);

    test_scenario::drop_storage_object(v);
}
