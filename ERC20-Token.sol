// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Token{
    // Returns the total token supply.
    function totalSupply() public view virtual returns (uint) {}

    // Returns the account balance of account 
    function balanceOf(address account) public view virtual returns(uint){}
    // transfer value tokens to address to and must fire transfer event 
    function transfer(address to,uint value) public virtual returns(bool){}

    // Allows spender to withdraw from your account multiple times, up to the amount. If this function is called again it overwrites the current allowance with amount.
    function approve(address spender,uint amount) public virtual returns(bool){}

    // Transfers amount tokens from address _from to address _to, and MUST fire the Transfer event.
    function transferFrom(address sender,address recipient,uint amount) public virtual returns(bool){}

    // Returns the amount which spender is still allowed to withdraw from owner.
    function allowance(address owner,address spender) public view virtual returns(uint){}

    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address  spender, uint256 value);
}

contract standardToken is Token{
    uint _totalSupply;
    string public name;
    string public symbol;
    uint public decimals;
    mapping(address=>uint) balances;
    mapping(address=>mapping(address=>uint)) allowances;

    constructor(string memory _name,string memory _symbol,uint _decimals,uint tsupply){
        name=_name;
        symbol=_symbol;
        decimals=_decimals;
        _totalSupply=tsupply * 10 ** _decimals;
        balances[msg.sender] = _totalSupply;
    } 

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }
   
    function balanceOf(address account) public view override returns(uint){
        return balances[account];
    }
    
    function transfer(address to,uint value) public override returns(bool){
        require(balances[msg.sender]>=value,"Not enough Tokens");

        balances[msg.sender]-=value;
        balances[to]+=value;
        emit Transfer(msg.sender,to,value);
        return true;
    }

    function approve(address spender,uint amount) public override returns(bool){
        allowances[msg.sender][spender]=amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender,address recipient,uint amount) public override returns(bool){
        require(balances[sender]>=amount,"Not enough tokens in your account");
        require(allowances[sender][msg.sender]>=amount);

        balances[sender]-=amount;
        balances[recipient]+=amount;
        allowances[sender][recipient]-=amount;

        emit Transfer(sender,recipient,amount);
        return true;
    }

    function allowance(address owner,address spender) public view override returns(uint){
        return allowances[owner][spender];
    }
}

// 0x5485E3DF25E348B51A44250E4817A6ebc8E90fAa