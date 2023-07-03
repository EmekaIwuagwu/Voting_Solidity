// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }
    
    struct Voter {
        string fullName;
        string email;
        bool hasVoted;
    }
    
    address public admin;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    
    event Vote(address indexed voter, uint256 candidateIndex);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the contract admin can perform this operation");
        _;
    }
    
    constructor(string[] memory candidateNames) {
        admin = msg.sender;
        
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }
    
    function registerVoter(string memory fullName, string memory email) external {
        require(bytes(fullName).length > 0, "Full name must not be empty");
        require(bytes(email).length > 0, "Email must not be empty");
        require(!voters[msg.sender].hasVoted, "The voter has already cast their vote");
        
        voters[msg.sender] = Voter({
            fullName: fullName,
            email: email,
            hasVoted: false
        });
    }
    
    function vote(uint256 candidateIndex) external {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        require(!voters[msg.sender].hasVoted, "The voter has already cast their vote");
        
        voters[msg.sender].hasVoted = true;
        candidates[candidateIndex].voteCount++;
        
        emit Vote(msg.sender, candidateIndex);
    }
    
    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }
    
    function getCandidate(uint256 candidateIndex) external view returns (string memory, uint256) {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        
        Candidate storage candidate = candidates[candidateIndex];
        return (candidate.name, candidate.voteCount);
    }
    
    function getVoter(address voterAddress) external view returns (string memory, string memory, bool) {
        Voter storage voter = voters[voterAddress];
        return (voter.fullName, voter.email, voter.hasVoted);
    }
    
    function isAdmin() external view returns (bool) {
        return msg.sender == admin;
    }
    
    function addCandidate(string memory candidateName) external onlyAdmin {
        require(bytes(candidateName).length > 0, "Candidate name must not be empty");
        
        candidates.push(Candidate({
            name: candidateName,
            voteCount: 0
        }));
    }
    
    function removeCandidate(uint256 candidateIndex) external onlyAdmin {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        
        // Reorder array to maintain consistency
        for (uint256 i = candidateIndex; i < candidates.length - 1; i++) {
            candidates[i] = candidates[i + 1];
        }
        
        candidates.pop();
    }
}
