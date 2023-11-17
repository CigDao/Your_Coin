import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Time "mo:base/Time";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import ICRC1 "mo:icrc1/ICRC1"; // replace with "mo:icrc1/ICRC1"
import Account "mo:icrc1/ICRC1/Account";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Error "mo:base/Error";
import Buffer "mo:base/Buffer";
import ICRC "./services/ICRC";
import Prim "mo:prim";
import Dip20 "./services/Dip20";
import Constants "Constants";

shared ({ caller = _owner }) actor class Token(
    token_args : ICRC1.TokenInitArgs
) : async ICRC1.FullInterface {

    stable var token = ICRC1.init({
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

    /*public shared ({ caller }) func airdrop() : async () {
        assert (caller == dev);
        var _balances : Buffer.Buffer<(ICRC1.Account, ICRC1.Balance)> = Buffer.fromArray([]);
        let holders = await _getHolders();

        for ((holder, amount) in holders.vals()) {
            let account = {
                owner = holder;
                subaccount = null;
            };
            if (Account.validate(account)) {
                if (amount > 0) {
                    _balances.add((account, amount));
                };
            };
        };

        let args = {
            name = token_args.name;
            symbol = token_args.symbol;
            decimals = token_args.decimals;
            fee = token_args.fee;
            max_supply = token_args.max_supply;
            initial_balances = Buffer.toArray(_balances);
            min_burn_amount = token_args.min_burn_amount;

            /// optional value that defaults to the caller if not provided
            minting_account = token_args.minting_account;

            advanced_settings = token_args.advanced_settings;
        };
        token := ICRC1.init({
            args with minting_account = Option.get(
                args.minting_account,
                {
                    owner = _owner;
                    subaccount = null;
                },
            );
        });
    };*/

    /*public shared ({ caller }) func icrc1_snap_shot() : async () {
        assert(caller == dev);
        let sonic = Principal.fromText("tpqyu-cs7yl-qyntm-pxmiy-r26zg-ye5fo-m4smt-nizfj-47u75-gk25q-wae");
        let sonicMintArgs = {
            to = { owner = sonic; subaccount = null };
            amount = 10000000000005000000;
            memo = null;
            created_at_time = null;
        };
        ignore await ICRC1.mint(token, sonicMintArgs, dev);
        let request = { start = 0; length = 1000000 };
        let transactions = (await ICRC.service("t2hbe-cqaaa-aaaan-qenha-cai").get_transactions(request)).transactions;
        for (transaction in transactions.vals()) {
            switch (transaction.kind) {
                case ("MINT") {
                    switch (transaction.mint) {
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
                    };
                };
                case ("TRANSFER") {
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
                case ("BURN") {
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
    };*/

    /*stable var drops : [(Principal, Nat)] = [];

    public query func fetchDrops() : async [(Principal, Nat)] {
        drops;
    };

    public query func dropsSize() : async Nat {
        drops.size();
    };

    public shared ({ caller }) func claimRemaining() : async () {
        let dev = Principal.fromText("i47jd-kewyq-vcner-l4xf7-edf77-aw4xp-u2kpb-2qai2-6ie7k-tcngl-oqe");
        assert (caller == dev);

    };

    public shared ({ caller }) func getAirDropAmount() : async Nat {
        let dev = Principal.fromText("i47jd-kewyq-vcner-l4xf7-edf77-aw4xp-u2kpb-2qai2-6ie7k-tcngl-oqe");
        assert (caller == dev);
        var amount = 0;
        let holders = await _getHolders();
        for ((holder, balance) in holders.vals()) {
            let validHolder = _isValidHolder(holder);
            if (validHolder == true) amount := amount + balance;
        };
        amount;
    };*/

    /*public shared ({ caller }) func airdrop(token : Text) : async () {
        let dev = Principal.fromText("i47jd-kewyq-vcner-l4xf7-edf77-aw4xp-u2kpb-2qai2-6ie7k-tcngl-oqe");
        assert (caller == dev);
        let fee = await ICRC.service(token).icrc1_fee();
        let holders = await _getHolders();
        for ((holder, balance) in holders.vals()) {
            ignore await ICRC.service(token).icrc1_transfer(_transferArgsFactory(balance, fee, holder));
            drops := Array.append(drops, [(holder, balance)]);
        };
    };*/

    /*private func _getHolderCount() : async Nat {
        let tokenInfo = await Dip20.service(Constants.OLD_YC_CANISTER).getTokenInfo();
        tokenInfo.holderNumber;
    };

    private func _getHolders() : async [(Principal, Nat)] {
        let count = await _getHolderCount();
        await Dip20.service(Constants.OLD_YC_CANISTER).getHolders(0, count);
    };

    private func _isValidHolder(holder : Principal) : Bool {
        var result = true;
        let liquidityWallet = Principal.fromText("utrha-5yaaa-aaaan-qa5ja-cai");
        let teamWallet = Principal.fromText("fttjr-2aaaa-aaaak-qbe7q-cai");
        let marketingWallet = Principal.fromText("h7ych-5iaaa-aaaao-aaxua-cai");
        let distribution = Principal.fromText("cjzlc-riaaa-aaaal-qbgwa-cai");
        let dao = Principal.fromText("7tac7-rqaaa-aaaak-ac47q-cai");
        let taxCanister = Principal.fromText("fppg4-cyaaa-aaaap-aanza-cai");
        let treasuryCanister = Principal.fromText("unwqb-kyaaa-aaaak-ac5aa-cai");
        let swapCanister = Principal.fromText("6ox57-5aaaa-aaaap-qaw4q-cai");
        let temp : [Principal] = [liquidityWallet, teamWallet, marketingWallet, distribution, dao, taxCanister, treasuryCanister, swapCanister];

        for (principal in temp.vals()) {
            if (holder == principal) result := false;
        };
        result;
    };*/

    public query func getMemorySize() : async Nat {
        let size = Prim.rts_memory_size();
        size;
    };

    public query func getHeapSize() : async Nat {
        let size = Prim.rts_heap_size();
        size;
    };

    public query func getCycles() : async Nat {
        Prim.cyclesBalance();
    };

    private func _getMemorySize() : Nat {
        let size = Prim.rts_memory_size();
        size;
    };

    private func _getHeapSize() : Nat {
        let size = Prim.rts_heap_size();
        size;
    };

    private func _getCycles() : Nat {
        Prim.cyclesBalance();
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
        await ICRC1.mint(token, args, dev);
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
