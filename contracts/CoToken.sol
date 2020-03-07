pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CoToken is Ownable {
    
    // current token supply
    uint public TotalSupply = 100;
// mapping of balances
    mapping (address => uint) public balances;

        constructor() public { 
        balances[msg.sender] = TotalSupply;

    }
    // functiion transfer tokens between accounts
    function transferFrom(address _from, address _to, uint numberOfTokens) public {
        // transfer recipent can only recieve money if there are tokens in balance of sender
        //require(balances[_from] >= _nCo);
        balances[_from] -= numberOfTokens;
        balances[_to] += numberOfTokens;
        TotalSupply -= numberOfTokens;
    } 
    
    // 
    //function to calculate price of purchase given
    //bonding curve where f(x) = 0.01x + 0.2
    // create constructor with name of owner

    function buyPrice (uint _nCo) internal pure returns(uint) {
        //bonding curve function
        //price = f(x)
        // price in ether
        
       uint price = (0.01 * 1e18 wei * _nCo) + (0.2 * 1e18 wei);
        
        return price ;
    }
    // function to calculate price for sale of nco tokens
    function sellPrice(uint _nCo) internal pure returns(uint) {
       
    uint price = (0.01 * 1e18 wei * _nCo) + (0.2 * 1e18 wei);

        return price ;
    }
    
    // implement mint funtion which will create tokens
    // requires correct current price to be transferred
    function mint(address _to, uint numberOfTokens) public payable {
        // use erc20 mint function
        //number of tokens bought use buy price function and work backwards
        

        require(msg.value == buyPrice(numberOfTokens), "Not enough tokens were given.");
        // call TransferFrom function to mint tokens to account
        transferFrom(owner(), _to, numberOfTokens);
        
    }

    
    //function ehich will sell tokens back to curve 
    // can only be called by ownership
    function burn(address _from, uint _nCo) public onlyOwner {  
        //add tokens to balance of owner
        require(balances[_from]>= _nCo);
        transferFrom(_from, msg.sender, _nCo);
     
    }
    
    // destroy function which  destrucs contrac
    // requires owner to be called
    // only called if all Cotokens belong to owner
    function destroy() onlyOwner external {
        //uint ownerBalance = balances[msg.sender];

        require(balances[msg.sender] == 100, "All tokens do not belong to owner");
        selfdestruct(msg.sender);
    }
    
    
}