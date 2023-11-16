#!/bin/bash

export ARCHIVE_CONTROLLER=$(dfx identity get-principal)
export TRIGGER_THRESHOLD=2000
export NUM_OF_BLOCK_TO_ARCHIVE=1000
export CYCLE_FOR_ARCHIVE_CREATION=10000000000000

export MINTER=$(dfx identity get-principal)
export DEFAULT=$(dfx identity get-principal)
export SONIC="tpqyu-cs7yl-qyntm-pxmiy-r26zg-ye5fo-m4smt-nizfj-47u75-gk25q-wae"

export TOKEN_NAME="Your Coin"
export TOKEN_SYMBOL="YC"
export DECIMALS=8
export PRE_MINTED_TOKENS=10_000_000_000_005_000_000
export MAX_SUPPLY=100000000000000000000
export TRANSFER_FEE=1_000_000

dfx deploy --network ic icrc1_ledger_canister --argument "(variant {Init = 
record {
     token_symbol = \"${TOKEN_SYMBOL}\";
     token_name = \"${TOKEN_NAME}\";
     minting_account = record { owner = principal \"${MINTER}\" };
     transfer_fee = ${TRANSFER_FEE};
     metadata = vec {};
     initial_balances = vec { record { record { owner = principal \"${SONIC}\"; }; ${PRE_MINTED_TOKENS}; }; };
     archive_options = record {
         num_blocks_to_archive = ${NUM_OF_BLOCK_TO_ARCHIVE};
         trigger_threshold = ${TRIGGER_THRESHOLD};
         controller_id = principal \"${ARCHIVE_CONTROLLER}\";
         cycles_for_archive_creation = opt ${CYCLE_FOR_ARCHIVE_CREATION};
     };
 }
})"