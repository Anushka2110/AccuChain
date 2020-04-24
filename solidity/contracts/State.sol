pragma solidity ^0.5.0;

contract State {
    
    address owner;
    address public implementation;
    
    struct Institute{
        address addr;
        uint timestamp;
    }
    struct Transcript{
        uint instituteId;
        bytes32 transcriptHash;
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint timestamp; 
    }
    
    mapping(uint => Institute) institutes;
    mapping(uint => Transcript) transcripts;
    
}