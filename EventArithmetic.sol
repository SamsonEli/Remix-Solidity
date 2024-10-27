pragma solidity ^0.6.3;

contract EventArithmetic {
    
    event performOperation(
    address indexed _from,
    string _operation
    );

    function performMath(uint _a,uint _b) public returns(uint _sum){
        _sum = _a+_b;
        emit performOperation(msg.sender, 'addition');
    }
}
