pragma solidity ^0.4.0;

contract Bonero {

    address public lender;
    address public debtor;

    uint256 public timePublished;
    uint256 public timeSubscription;
    uint256 public timeClousure;
    uint256 public time;

    uint public requested;
    uint public principal;
    uint public interest;
    uint public owed;
    uint public amortization;

    
    // enum state {Subscription, Capitalization, Paying, Default };
    enum State { Open, Hold, Closed }
    State public state;
    
    event Finished();
    
    modifier OnlyOpen() { require(state == State.Open); _; }
    modifier OnlyHold() { require(state == State.Hold); _; }
    modifier Minimum() { _; }
    
    modifier Financials() {
        
            time = (block.timestamp - timeSubscription) / 60;
            
            uint i = 1;
            
            uint owed = principal;
            
            while (i < time) {
            
            owed  = owed  * 10010  /  10000   ;
            
            i = i + 1;

            }

            interest = owed - principal;


        _;
    }
    

    function Bonero() public {
        debtor = msg.sender;
        state = State.Open;
        timePublished = block.timestamp;        
        requested = 1000000000000000000;
     
    }    
  
    function Deposit() payable OnlyOpen returns (bool success)  {
        require(msg.value > 1000 ); 
        require(msg.sender != debtor);
        debtor.transfer(msg.value);
        lender = msg.sender;
        principal = msg.value;
        state = State.Hold;
        timeSubscription = block.timestamp;
        return true;
    }
    

    function LoanUpdate() Financials returns (bool success) {
        
        return true;
    }

    function Payout() payable OnlyHold Minimum Financials returns (bool success) {
        
        if ( principal  <= msg.value) 
        {
            lender.transfer(principal);
            debtor.transfer(msg.value-principal);
            amortization = principal;
            timeClousure = block.timestamp;
            state = State.Closed;
            return true;
        } 
        else
        {
            debtor.transfer(msg.value);
            return false;
        }
        
    }
    
    
}
