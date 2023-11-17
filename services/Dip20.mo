import Principal "mo:base/Principal";
import Time "mo:base/Time";

module {

    public type TxReceipt = {
        #Ok : Text;
        #Err : {
            #InsufficientAllowance;
            #InsufficientBalance;
            #ErrorOperationStyle;
            #Unauthorized;
            #LedgerTrap;
            #ErrorTo;
            #Other : Text;
            #BlockUsed;
            #ActiveProposal;
            #AmountTooSmall;
            #AccountNotFound;
        };
    };

    public type TokenInfo = {
        holderNumber : Nat;
        deployTime : Time.Time;
        metadata : Metadata;
        historySize : Nat;
        cycles : Nat;
        feeTo : Principal;
    };
    public type Metadata = {
        fee : Nat;
        decimals : Nat8;
        owner : Principal;
        logo : Text;
        name : Text;
        totalSupply : Nat;
        symbol : Text;
    };

    public func service(canister : Text) : actor {
        balanceOf : shared query Principal -> async Nat;
        allowance : shared query (Principal, Principal) -> async Nat;
        transferFrom : shared (Principal, Principal, Nat) -> async TxReceipt;
        transfer : shared (Principal, Nat) -> async TxReceipt;
        withdraw : shared (Nat, Text) -> async TxReceipt;
        getMetadata : shared query () -> async (Metadata);
        getTokenFee : shared query () -> async Nat;
        getTokenInfo : shared query () -> async TokenInfo;
        getHolders : shared query (Nat, Nat) -> async [(Principal, Nat)];
    } {
        return actor (canister) : actor {
            balanceOf : shared query Principal -> async Nat;
            allowance : shared query (Principal, Principal) -> async Nat;
            transferFrom : shared (Principal, Principal, Nat) -> async TxReceipt;
            transfer : shared (Principal, Nat) -> async TxReceipt;
            withdraw : shared (Nat, Text) -> async TxReceipt;
            getMetadata : shared query () -> async (Metadata);
            getTokenFee : shared query () -> async Nat;
            getTokenInfo : shared query () -> async TokenInfo;
            getHolders : shared query (Nat, Nat) -> async [(Principal, Nat)];
        };
    };
};