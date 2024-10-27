pragma solidity ^0.4.20;

contract C {
    function sendAddress() public returns(address){
        return tx.origin;
    }
}

contract B {
    function callContractC() public returns(address){
        C _c = new C();
        return _c.sendAddress();
    }
}


contract A {
    function callContractB() public returns(address){
        B _b = new B();
        return _b.callContractC();
    }
}
