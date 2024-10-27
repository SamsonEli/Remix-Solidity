pragma solidity ^0.8.4;


contract BellRinger {
    uint public bellRung; 

    event BellRung(uint rangForNTime, address source);


    function ringTheBell() public {
        bellRung++;
        
        emit BellRung(bellRung, msg.sender);

    }


}
