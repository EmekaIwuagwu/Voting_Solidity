// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // Represents a single candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Represents a single voter
    struct Voter {
        string fullName;
        string email;
        bool hasVoted;
    }

    address public owner;
    bool public votingOpen;
    uint256 public totalVotes;

    mapping(address => Voter) public voters;
    Candidate[] public candidates;

    // Modifier to restrict access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the contract owner");
        _;
    }

    // Modifier to check if voting is open
    modifier isVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    constructor() {
        owner = msg.sender;
        votingOpen = true;
    }

    // Add a candidate to the election
    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate(_name, 0));
    }

    // Start the voting process
    function startVoting() public onlyOwner {
        votingOpen = true;
    }

    // Close the voting process
    function closeVoting() public onlyOwner {
        votingOpen = false;
    }

    // Vote for a candidate
    function vote(uint256 _candidateIndex, string memory _fullName, string memory _email) public isVotingOpen {
        require(_candidateIndex < candidates.length, "Invalid candidate index");
        require(!voters[msg.sender].hasVoted, "You have already voted");

        voters[msg.sender] = Voter(_fullName, _email, true);
        candidates[_candidateIndex].voteCount++;
        totalVotes++;
    }

    // Get the total number of candidates
    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }

    // Get the details of a candidate by index
    function getCandidate(uint256 _candidateIndex) public view returns (string memory name, uint256 voteCount) {
        require(_candidateIndex < candidates.length, "Invalid candidate index");
        Candidate memory candidate = candidates[_candidateIndex];
        return (candidate.name, candidate.voteCount);
    }

    // Get the details of a voter by address
    function getVoter(address _voterAddress) public view returns (string memory fullName, string memory email, bool hasVoted) {
        Voter memory voter = voters[_voterAddress];
        return (voter.fullName, voter.email, voter.hasVoted);
    }
}
