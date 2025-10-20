// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Bora
 * @author CryptoRhinoo
 * @notice Smart contract for BORA - Web3 Talent Marketplace
 * @dev Implements profiles, opportunities, swipes, matches and reputation system
 */
contract Bora {
    
    // ============ STATE VARIABLES ============
    
    uint256 private _opportunityIdCounter;
    uint256 private _matchIdCounter;
    
    address public owner;
    bool public paused;
    
    // Platform fee (in basis points, 250 = 2.5%)
    uint256 public platformFee = 250;
    uint256 public constant MAX_FEE = 1000; // 10% max
    
    // ============ STRUCTS ============
    
    struct Developer {
        address wallet;
        string name;
        string[] skills;
        string bio;
        uint256 reputation;
        bool isActive;
        uint256 createdAt;
        uint256 completedJobs;
    }
    
    struct Opportunity {
        uint256 id;
        address creator;
        string title;
        string description;
        string[] requiredSkills;
        uint256 budget;
        uint256 escrowBalance;
        bool isActive;
        uint256 createdAt;
        uint256 matchCount;
    }
    
    struct Swipe {
        address user;
        uint256 opportunityId;
        bool isLike;
        uint256 timestamp;
    }
    
    struct Match {
        uint256 id;
        address developer;
        uint256 opportunityId;
        address creator;
        bool isActive;
        bool isCompleted;
        uint256 timestamp;
    }
    
    // ============ MAPPINGS ============
    
    mapping(address => Developer) public developers;
    mapping(uint256 => Opportunity) public opportunities;
    mapping(address => mapping(uint256 => Swipe)) public swipes;
    mapping(uint256 => Match) public matches;
    mapping(address => uint256[]) private userMatches;
    mapping(uint256 => address[]) private opportunitySwipes;
    mapping(address => bool) public isDeveloper;
    
    // ============ EVENTS ============
    
    event DeveloperRegistered(
        address indexed developer,
        string name,
        uint256 timestamp
    );
    
    event OpportunityCreated(
        uint256 indexed opportunityId,
        address indexed creator,
        string title,
        uint256 budget,
        uint256 timestamp
    );
    
    event SwipeMade(
        address indexed user,
        uint256 indexed opportunityId,
        bool isLike,
        uint256 timestamp
    );
    
    event MatchCreated(
        uint256 indexed matchId,
        address indexed developer,
        uint256 indexed opportunityId,
        address creator,
        uint256 timestamp
    );
    
    event JobCompleted(
        uint256 indexed matchId,
        address indexed developer,
        uint256 payment,
        uint256 newReputation,
        uint256 timestamp
    );
    
    event ReputationUpdated(
        address indexed developer,
        uint256 newReputation,
        uint256 timestamp
    );
    
    event EscrowDeposited(
        uint256 indexed opportunityId,
        uint256 amount,
        uint256 timestamp
    );
    
    event PlatformFeeUpdated(
        uint256 oldFee,
        uint256 newFee,
        uint256 timestamp
    );
    
    // ============ MODIFIERS ============
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    modifier onlyDeveloper() {
        require(isDeveloper[msg.sender], "Not a registered developer");
        _;
    }
    
    modifier validOpportunity(uint256 _opportunityId) {
        require(_opportunityId < _opportunityIdCounter, "Invalid opportunity ID");
        require(opportunities[_opportunityId].isActive, "Opportunity not active");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
    
    // ============ CONSTRUCTOR ============
    
    constructor() {
        owner = msg.sender;
        _opportunityIdCounter = 0;
        _matchIdCounter = 0;
        paused = false;
    }
    
    // ============ ADMIN FUNCTIONS ============
    
    function togglePause() external onlyOwner {
        paused = !paused;
    }
    
    function setPlatformFee(uint256 _newFee) external onlyOwner {
        require(_newFee <= MAX_FEE, "Fee too high");
        uint256 oldFee = platformFee;
        platformFee = _newFee;
        emit PlatformFeeUpdated(oldFee, _newFee, block.timestamp);
    }
    
    function withdrawPlatformFees() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No fees to withdraw");
        payable(owner).transfer(balance);
    }
    
    // ============ DEVELOPER FUNCTIONS ============
    
    function createDeveloperProfile(
        string memory _name,
        string[] memory _skills,
        string memory _bio
    ) external whenNotPaused {
        require(!isDeveloper[msg.sender], "Developer already registered");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_skills.length > 0, "Must have at least one skill");
        
        developers[msg.sender] = Developer({
            wallet: msg.sender,
            name: _name,
            skills: _skills,
            bio: _bio,
            reputation: 100,
            isActive: true,
            createdAt: block.timestamp,
            completedJobs: 0
        });
        
        isDeveloper[msg.sender] = true;
        
        emit DeveloperRegistered(msg.sender, _name, block.timestamp);
    }
    
    function updateDeveloperProfile(
        string memory _name,
        string[] memory _skills,
        string memory _bio
    ) external onlyDeveloper whenNotPaused {
        Developer storage dev = developers[msg.sender];
        
        if (bytes(_name).length > 0) {
            dev.name = _name;
        }
        if (_skills.length > 0) {
            dev.skills = _skills;
        }
        if (bytes(_bio).length > 0) {
            dev.bio = _bio;
        }
    }
    
    function deactivateDeveloperProfile() external onlyDeveloper {
        developers[msg.sender].isActive = false;
    }
    
    // ============ OPPORTUNITY FUNCTIONS ============
    
    function createOpportunity(
        string memory _title,
        string memory _description,
        string[] memory _requiredSkills,
        uint256 _budget
    ) external whenNotPaused {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(_requiredSkills.length > 0, "Must specify required skills");
        require(_budget > 0, "Budget must be greater than 0");
        
        uint256 newOpportunityId = _opportunityIdCounter;
        
        opportunities[newOpportunityId] = Opportunity({
            id: newOpportunityId,
            creator: msg.sender,
            title: _title,
            description: _description,
            requiredSkills: _requiredSkills,
            budget: _budget,
            escrowBalance: 0,
            isActive: true,
            createdAt: block.timestamp,
            matchCount: 0
        });
        
        _opportunityIdCounter++;
        
        emit OpportunityCreated(
            newOpportunityId,
            msg.sender,
            _title,
            _budget,
            block.timestamp
        );
    }
    
    function depositEscrow(uint256 _opportunityId) 
        external 
        payable 
        validOpportunity(_opportunityId)
        whenNotPaused
    {
        Opportunity storage opp = opportunities[_opportunityId];
        require(opp.creator == msg.sender, "Not the creator");
        require(msg.value > 0, "Must deposit funds");
        
        opp.escrowBalance += msg.value;
        
        emit EscrowDeposited(_opportunityId, msg.value, block.timestamp);
    }
    
    function closeOpportunity(uint256 _opportunityId) external {
        Opportunity storage opp = opportunities[_opportunityId];
        require(opp.creator == msg.sender, "Not the creator");
        require(opp.isActive, "Opportunity already closed");
        
        // Refund escrow if exists
        if (opp.escrowBalance > 0) {
            uint256 refund = opp.escrowBalance;
            opp.escrowBalance = 0;
            payable(msg.sender).transfer(refund);
        }
        
        opp.isActive = false;
    }
    
    // ============ SWIPE FUNCTIONS ============
    
    function swipeOpportunity(
        uint256 _opportunityId,
        bool _isLike
    ) external onlyDeveloper validOpportunity(_opportunityId) whenNotPaused {
        require(
            swipes[msg.sender][_opportunityId].timestamp == 0,
            "Already swiped this opportunity"
        );
        
        Opportunity storage opp = opportunities[_opportunityId];
        require(opp.creator != msg.sender, "Cannot swipe own opportunity");
        
        swipes[msg.sender][_opportunityId] = Swipe({
            user: msg.sender,
            opportunityId: _opportunityId,
            isLike: _isLike,
            timestamp: block.timestamp
        });
        
        if (_isLike) {
            opportunitySwipes[_opportunityId].push(msg.sender);
        }
        
        emit SwipeMade(msg.sender, _opportunityId, _isLike, block.timestamp);
    }
    
    // ============ MATCH FUNCTIONS ============
    
    function acceptMatch(
        uint256 _opportunityId,
        address _developer
    ) external validOpportunity(_opportunityId) whenNotPaused {
        Opportunity storage opp = opportunities[_opportunityId];
        require(opp.creator == msg.sender, "Not the opportunity creator");
        require(isDeveloper[_developer], "Not a valid developer");
        require(developers[_developer].isActive, "Developer not active");
        
        Swipe memory devSwipe = swipes[_developer][_opportunityId];
        require(devSwipe.isLike, "Developer didn't like this opportunity");
        
        uint256 newMatchId = _matchIdCounter;
        
        matches[newMatchId] = Match({
            id: newMatchId,
            developer: _developer,
            opportunityId: _opportunityId,
            creator: msg.sender,
            isActive: true,
            isCompleted: false,
            timestamp: block.timestamp
        });
        
        userMatches[_developer].push(newMatchId);
        userMatches[msg.sender].push(newMatchId);
        
        opp.matchCount++;
        
        _matchIdCounter++;
        
        emit MatchCreated(
            newMatchId,
            _developer,
            _opportunityId,
            msg.sender,
            block.timestamp
        );
    }
    
    function completeJob(
        uint256 _matchId,
        uint256 _reputationIncrease
    ) external whenNotPaused {
        Match storage matchData = matches[_matchId];
        require(matchData.creator == msg.sender, "Not the match creator");
        require(matchData.isActive, "Match not active");
        require(!matchData.isCompleted, "Job already completed");
        require(_reputationIncrease > 0 && _reputationIncrease <= 100, "Invalid reputation increase");
        
        Developer storage dev = developers[matchData.developer];
        Opportunity storage opp = opportunities[matchData.opportunityId];
        
        matchData.isCompleted = true;
        matchData.isActive = false;
        
        // Process payment if escrow exists
        uint256 payment = 0;
        if (opp.escrowBalance > 0) {
            payment = opp.escrowBalance;
            
            // Calculate platform fee
            uint256 fee = (payment * platformFee) / 10000;
            uint256 developerPayment = payment - fee;
            
            opp.escrowBalance = 0;
            
            // Transfer to developer
            payable(matchData.developer).transfer(developerPayment);
            // Fee stays in contract for owner to withdraw
        }
        
        // Update reputation and completed jobs
        dev.reputation += _reputationIncrease;
        dev.completedJobs++;
        
        emit JobCompleted(
            _matchId,
            matchData.developer,
            payment,
            dev.reputation,
            block.timestamp
        );
        
        emit ReputationUpdated(
            matchData.developer,
            dev.reputation,
            block.timestamp
        );
    }
    
    // ============ VIEW FUNCTIONS ============
    
    function getDeveloper(address _developer) 
        external 
        view 
        returns (Developer memory) 
    {
        require(isDeveloper[_developer], "Developer not found");
        return developers[_developer];
    }
    
    function getOpportunity(uint256 _opportunityId) 
        external 
        view 
        returns (Opportunity memory) 
    {
        require(_opportunityId < _opportunityIdCounter, "Opportunity not found");
        return opportunities[_opportunityId];
    }
    
    function getActiveOpportunities() 
        external 
        view 
        returns (Opportunity[] memory) 
    {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < _opportunityIdCounter; i++) {
            if (opportunities[i].isActive) {
                activeCount++;
            }
        }
        
        Opportunity[] memory activeOpps = new Opportunity[](activeCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < _opportunityIdCounter; i++) {
            if (opportunities[i].isActive) {
                activeOpps[currentIndex] = opportunities[i];
                currentIndex++;
            }
        }
        
        return activeOpps;
    }
    
    function getUserMatches(address _user) 
        external 
        view 
        returns (Match[] memory) 
    {
        uint256[] memory matchIds = userMatches[_user];
        Match[] memory userMatchArray = new Match[](matchIds.length);
        
        for (uint256 i = 0; i < matchIds.length; i++) {
            userMatchArray[i] = matches[matchIds[i]];
        }
        
        return userMatchArray;
    }
    
    function getOpportunitySwipes(uint256 _opportunityId) 
        external 
        view 
        returns (address[] memory) 
    {
        require(
            opportunities[_opportunityId].creator == msg.sender, 
            "Not the creator"
        );
        return opportunitySwipes[_opportunityId];
    }
    
    function getSwipe(address _user, uint256 _opportunityId)
        external
        view
        returns (Swipe memory)
    {
        return swipes[_user][_opportunityId];
    }
    
    function getTotalOpportunities() external view returns (uint256) {
        return _opportunityIdCounter;
    }
    
    function getTotalMatches() external view returns (uint256) {
        return _matchIdCounter;
    }
    
    // ============ FALLBACK ============
    
    receive() external payable {}
}
