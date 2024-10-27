pragma solidity ^0.4.0;

contract Mydata {
    Person[] public people;

    uint256 public peopleCount;

    struct Person {
        string _firstName;
        string _lastName;
    }

    function addPerson(string _firstName, string _lastName) public {
        peopleCount = people.push(Person(_firstName, _lastName));
    }
}
