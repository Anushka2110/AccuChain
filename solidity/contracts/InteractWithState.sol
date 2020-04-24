pragma solidity ^0.5.0;

import "./State.sol";

contract InteractWithState is State {
    
    event instituteAdded(uint id, address addr, uint timestamp);
    event transcriptAdded(uint id, uint instituteId, bytes32 transcriptHash, uint timestamp);
    
    modifier doesInstituteExist(uint _id) {
        require(institutes[_id].addr != address(0), "institute does not exist" );
        _;
    }
    
    modifier doesTranscriptExist(uint _id) {
        require(transcripts[_id].transcriptHash != bytes32(0), "transcript does not exist" );
        _;
    }
    
    modifier isInstituteIdValid(uint _id) {
        require(institutes[_id].addr == address(0), "Institute id invalid");
        _;
    }
    
    modifier isTranscriptIdValid(uint _id) {
        require(transcripts[_id].transcriptHash == bytes32(0), "transcript id invalid");
        _;
    }
    
    modifier onlyInstitute(uint id) {
        require(tx.origin == institutes[id].addr, "You are not the institute");
        _;
    }
    
    function getInstituteById(uint _id) public doesInstituteExist(_id) view returns(address, uint){
        Institute memory i = institutes[_id];
        return (i.addr, i.timestamp);
    }
    
    function getTranscriptById(uint _id) public doesTranscriptExist(_id) view returns (uint ,bytes32, uint8, bytes32, bytes32, uint){
        Transcript memory t = transcripts[_id];
        return (t.instituteId ,t.transcriptHash, t.v, t.r, t.s, t.timestamp);
    }
    
    function addInstitute(uint _id) public isInstituteIdValid(_id) {
        Institute memory i = Institute(tx.origin, now);
        institutes[_id] = i;
        emit instituteAdded(_id, institutes[_id].addr, institutes[_id].timestamp);
    }
    
    function addTranscript(uint _id, uint _instituteId, bytes32 transcriptHash, uint8 v, bytes32 r, bytes32 s) public doesInstituteExist(_instituteId) onlyInstitute(_instituteId) isTranscriptIdValid(_id) {
        Transcript memory t = Transcript(_instituteId, transcriptHash, v, r, s, now);
        transcripts[_id] = t;
        emit transcriptAdded(_id, transcripts[_id].instituteId, transcripts[_id].transcriptHash, transcripts[_id].timestamp);
    }
}