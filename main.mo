import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Time "mo:base/Time";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import ICRC1 "mo:icrc1/ICRC1"; // replace with "mo:icrc1/ICRC1"
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import ICRC "./services/ICRC";

shared ({ caller = _owner }) actor class Token(
    token_args : ICRC1.TokenInitArgs
) : async ICRC1.FullInterface {

    stable let token = ICRC1.init({
        token_args with minting_account = Option.get(
            token_args.minting_account,
            {
                owner = _owner;
                subaccount = null;
            },
        );
    });

    let dev = Principal.fromText("i47jd-kewyq-vcner-l4xf7-edf77-aw4xp-u2kpb-2qai2-6ie7k-tcngl-oqe");

    /// Functions for the ICRC1 token standard

    public shared ({ caller }) func icrc1_snap_shot() : async () {
        let sonic = Principal.fromText("tpqyu-cs7yl-qyntm-pxmiy-r26zg-ye5fo-m4smt-nizfj-47u75-gk25q-wae");
        assert (caller == dev);
        let sonicMintArgs = {
            to = {owner = sonic; subaccount = null};
            amount = 10000000000005000000;
            memo = null;
            created_at_time = null;
        };
        ignore await ICRC1.mint(token, sonicMintArgs, dev);
        let request = { start = 0; length = 1000000 };
        let transactions = (await ICRC.service("onxlw-tiaaa-aaaan-qedoq-cai").get_transactions(request)).transactions;
        for (transaction in transactions.vals()) {
            switch (transaction.kind) {
                case ("mint") {
                    /*switch (transaction.mint) {
                        case (?mint) {
                            let args = {
                                to = mint.to;
                                amount = mint.amount;
                                memo = mint.memo;
                                created_at_time = mint.created_at_time;
                            };
                            ignore await ICRC1.mint(token, args, dev);
                        };
                        case (_) {

                        };
                    };*/
                };
                case ("transfer") {
                    switch (transaction.transfer) {
                        case (?transfer) {
                            let args = {
                                from_subaccount = transfer.from.subaccount;
                                to = transfer.to;
                                amount = transfer.amount;
                                fee = transfer.fee;
                                memo = transfer.memo;

                                /// The time at which the transaction was created.
                                /// If this is set, the canister will check for duplicate transactions and reject them.
                                created_at_time = transfer.created_at_time;
                            };
                            ignore await ICRC1.transfer(token, args, transfer.from.owner);
                        };
                        case (_) {

                        };
                    };
                };
                case ("burn") {
                    switch (transaction.burn) {
                        case (?burn) {
                            let args = {
                                from_subaccount = burn.from.subaccount;
                                amount = burn.amount;
                                memo = burn.memo;
                                created_at_time = burn.created_at_time;
                            };
                            ignore await ICRC1.burn(token, args, burn.from.owner);
                        };
                        case (_) {

                        };

                    };

                };
                case (_) {

                };
            };
        };
    };

    public shared query func icrc1_name() : async Text {
        ICRC1.name(token);
    };

    public shared query func icrc1_symbol() : async Text {
        ICRC1.symbol(token);
    };

    public shared query func icrc1_decimals() : async Nat8 {
        ICRC1.decimals(token);
    };

    public shared query func icrc1_fee() : async ICRC1.Balance {
        ICRC1.fee(token);
    };

    public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
        ICRC1.metadata(token);
    };

    public shared query func icrc1_total_supply() : async ICRC1.Balance {
        ICRC1.total_supply(token);
    };

    public shared query func icrc1_minting_account() : async ?ICRC1.Account {
        ?ICRC1.minting_account(token);
    };

    public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
        ICRC1.balance_of(token, args);
    };

    public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
        ICRC1.supported_standards(token);
    };

    public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
        await ICRC1.transfer(token, args, caller);
    };

    public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
        await ICRC1.mint(token, args, caller);
    };

    public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
        await ICRC1.burn(token, args, caller);
    };

    // Functions from the rosetta icrc1 ledger
    public shared query func get_transactions(req : ICRC1.GetTransactionsRequest) : async ICRC1.GetTransactionsResponse {
        ICRC1.get_transactions(token, req);
    };

    // Additional functions not included in the ICRC1 standard
    public shared func get_transaction(i : ICRC1.TxIndex) : async ?ICRC1.Transaction {
        await ICRC1.get_transaction(token, i);
    };

    // Deposit cycles into this archive canister.
    public shared func deposit_cycles() : async () {
        let amount = ExperimentalCycles.available();
        let accepted = ExperimentalCycles.accept(amount);
        assert (accepted == amount);
    };
};
