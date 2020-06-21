pragma solidity 0.5.15;

import "../ERC20/ERC20.sol";
import "../governance/Owner.sol";

contract IBTCToken is ERC20 , Owner {

    bool public contractState;

    address public TAddr;

    modifier isInActive(){
        require(contractState == false);
        _;
    }
    modifier isTreasury(){
        require(msg.sender == TAddr);
        _;
    }

    constructor(  )
        public
    {
        name = "IBTC";
        symbol = "IBTC";
        desc = "IBTC";
        decimals = 18;
        OwnerAddress = msg.sender;
        contractState = false;
    }

    function setTreasury ( address _TAddres)
        isOwner
        isInActive
        public
        returns ( bool )
    {
        TAddr = _TAddres;
        contractState = true;
        return true;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function mint(address recipient, uint256 amount)
        isTreasury
        public
        returns (bool result )
    {
        _mint( recipient , amount );
        result = true;
    }

    function transfer(address recipient, uint256 amount)
        public
        returns (bool result )
    {
        _transfer(msg.sender, recipient , amount );
        result = true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(_allowances[sender][msg.sender] >= amount, "ERC20: Not enough in deligation");
        _transfer(msg.sender, recipient , amount );
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }


    function allowance(address TokenOwner, address spender) public view returns (uint256) {
        return _allowances[TokenOwner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

}
