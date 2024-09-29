pragma solidity ^0.4.24;
import "./SafeMath.sol";

contract Calc {
    uint256 public value;
    
    function add(uint _value1, uint _value2) public {
        value = SafeMath.add(_value1, _value2);
    }
}
