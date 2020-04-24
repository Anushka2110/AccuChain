pragma solidity ^0.5.0;

import "./TranscriptVerification.sol";
import "./State.sol";
import "./InteractWithState.sol";

contract Main is State, TranscriptVerification, InteractWithState{
    
    uint public lastInstituteId = 0;
    uint public lastTranscriptId = 0;
    
    function registerInstitute() public {
        uint id = ++lastInstituteId;
        addInstitute(id);
    }
    
    function addTranscript(uint instituteId, bytes32 transcriptHash, uint8 v, bytes32 r, bytes32 s) public {
        uint id = ++lastTranscriptId;
        addTranscript(id, instituteId, transcriptHash, v, r, s);
    }
    
    function isTranscriptAuthentic(string memory transcriptHash, address signer, uint8 v, bytes32 r, bytes32 s) public pure returns(bool){
        
        address sig = verifyTranscript(transcriptHash, v, r, s);
        
        if(sig == signer)
            return true;
        else return false;
    }
    
}