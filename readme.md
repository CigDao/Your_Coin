dfx canister --network ic call icrc1_ledger_canister icrc1_transfer '(record {to=record {owner=principal "qi47s-nyaaa-aaaap-ablma-cai";}; fee=null; memo=null; created_at_time=null;amount=5000000000000000000})'


dfx deploy --network ic token --argument '( record {                     
      name = "Your Coin";                         
      symbol = "YC";                           
      decimals = 8;                                           
      fee = 1_000_000;                                        
      max_supply = 100_000_000_000_000_000_000;                         
      initial_balances = vec {};                                                      
      min_burn_amount = 10_000;                         
      minting_account = opt record {                                        
        owner = principal "i47jd-kewyq-vcner-l4xf7-edf77-aw4xp-u2kpb-2qai2-6ie7k-tcngl-oqe";   
        subaccount = null;                          
      };                                
      advanced_settings = null;                               
  })'