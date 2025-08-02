// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; //version

contract SimpleStorage {
    //types: boolean, uint, int, address, bytes
    uint256 public myFavoriteNumber; //0

    //uint256[] listOfFavoriteNumbers;
    struct Person {
        uint256 favoriteNumber;
        string name;
    }



   // Person public john = Person(7, "John");
   Person [] public listOfPeople; //[]

   mapping (string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual  {
        myFavoriteNumber = _favoriteNumber;
    }

    //view, pure modifiers
    function retrieve() public view returns(uint256) {
        return myFavoriteNumber;
    }

    //calldata, memory, storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

contract SimpleStorage2 {}