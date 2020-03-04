pragma solidity ^0.5.0;
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CoToken is Ownable, ERC20{
    
    // create variables which contain name, symbol and total supply
    
    
    string public Name = "Co";
    string public Symbol = "CO";
    // current token supply
    uint public TotalSupply = 100;
    
    //create mapping of balances 
    mapping (address => uint) public balances;
    //function to calculate price of purchase given
    //bonding curve where f(x) = 0.01x + 0.2
    
        function buyPrice (uint _nCo) public pure returns(uint) {
        //bonding curve function
        //price = f(x)
        // price in ether
        
       uint price = (0.01 * 1e18 wei * _nCo) + (0.2 * 1e18 wei);
        
        return price ;
    }
    // function to calculate price for sale of nco tokens
    function sellPrice(uint _nCo) public pure returns(uint) {
       
    uint price = (0.01 * 1e18 wei * _nCo) + (0.2 * 1e18 wei);

        return price ;
    }
    
    // implement mint funtion which will create tokens
    // requires correct current price to be transferred
    function mint(address _to, uint _nCo) public payable {
        // use erc20 mint function
        //number of tokens bought use buy price function and work backwards
        

        require(msg.value == buyPrice(_nCo), "Not enough tokens were given.");
       // _mint(_to, _nCo);
        
        // add balance to token buyer
        _mint(_to, _nCo);
   
        TotalSupply = TotalSupply.sub(_nCo);
        
    }

    
    //function ehich will sell tokens back to curve 
    // can only be called by ownership
    function burn(address _from, uint _nCo) onlyOwner public payable{
        
        require(sellPrice(_nCo) == msg.value, "Not enough money was given for the tokens");
        // remove tokens from seller
        // balances[_from] = balances[_from].sub(_nCo);
        //add tokens to balance of owner
        // balances[msg.sender] = balances[msg.sender].add(_nCo);
    
        //_burn(_from, _nCo);
        _burn(_from, _nCo);
        TotalSupply = TotalSupply.add(_nCo);
        
    }
    
    // destroy function which  destrucs contrac
    // requires owner to be called
    // only called if all Cotokens belong to owner
    function destroy() onlyOwner public {
        //uint ownerBalance = balances[msg.sender];

        require(TotalSupply == 100, "All tokens do not belong to owner");
        selfdestruct(msg.sender);
    }
    
}