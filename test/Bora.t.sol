// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Bora} from "../src/Bora.sol";

contract BoraTest is Test {
    Bora public bora;

    address public owner;
    address public dev1;
    address public dev2;
    address public creator1;

    string[] skills;
    string[] requiredSkills;

    event DeveloperRegistered(address indexed developer, string name, uint256 timestamp);
    event OpportunityCreated(
        uint256 indexed opportunityId, address indexed creator, string title, uint256 budget, uint256 timestamp
    );
    event SwipeMade(address indexed user, uint256 indexed opportunityId, bool isLike, uint256 timestamp);
    event MatchCreated(
        uint256 indexed matchId,
        address indexed developer,
        uint256 indexed opportunityId,
        address creator,
        uint256 timestamp
    );
    event JobCompleted(
        uint256 indexed matchId, address indexed developer, uint256 payment, uint256 newReputation, uint256 timestamp
    );

    // Custom errors from Bora contract
    error NotDeveloper();
    error ContractPaused();

    function setUp() public {
        owner = address(this);
        dev1 = makeAddr("dev1");
        dev2 = makeAddr("dev2");
        creator1 = makeAddr("creator1");

        bora = new Bora();

        // Fund accounts
        vm.deal(dev1, 10 ether);
        vm.deal(dev2, 10 ether);
        vm.deal(creator1, 10 ether);

        // Setup skills arrays
        skills.push("Solidity");
        skills.push("JavaScript");
        requiredSkills.push("Solidity");
    }

    // Helper to receive ETH
    receive() external payable {}

    // ============ DEVELOPER PROFILE TESTS ============

    function test_CreateDeveloperProfile() public {
        vm.startPrank(dev1);

        vm.expectEmit(true, false, false, true);
        emit DeveloperRegistered(dev1, "Alice", block.timestamp);

        bora.createDeveloperProfile("Alice", skills, "Experienced blockchain developer");

        Bora.Developer memory dev = bora.getDeveloper(dev1);
        assertEq(dev.name, "Alice");
        assertEq(dev.skills.length, 2);
        assertEq(dev.reputation, 100);
        assertTrue(dev.isActive);
        assertEq(dev.completedJobs, 0);
        assertTrue(bora.isDeveloper(dev1));

        vm.stopPrank();
    }

    function test_RevertWhen_CreateDeveloperProfile_AlreadyRegistered() public {
        vm.startPrank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.expectRevert("Developer already registered");
        bora.createDeveloperProfile("Alice Again", skills, "Bio");
        vm.stopPrank();
    }

    function test_RevertWhen_CreateDeveloperProfile_EmptyName() public {
        vm.prank(dev1);
        vm.expectRevert("Name cannot be empty");
        bora.createDeveloperProfile("", skills, "Bio");
    }

    function test_RevertWhen_CreateDeveloperProfile_NoSkills() public {
        string[] memory emptySkills;
        vm.prank(dev1);
        vm.expectRevert("Must have at least one skill");
        bora.createDeveloperProfile("Alice", emptySkills, "Bio");
    }

    function test_UpdateDeveloperProfile() public {
        vm.startPrank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Old bio");

        string[] memory newSkills = new string[](1);
        newSkills[0] = "Rust";

        bora.updateDeveloperProfile("Alice Updated", newSkills, "New bio");

        Bora.Developer memory dev = bora.getDeveloper(dev1);
        assertEq(dev.name, "Alice Updated");
        assertEq(dev.skills[0], "Rust");

        vm.stopPrank();
    }

    function test_DeactivateDeveloperProfile() public {
        vm.startPrank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");
        bora.deactivateDeveloperProfile();

        Bora.Developer memory dev = bora.getDeveloper(dev1);
        assertFalse(dev.isActive);

        vm.stopPrank();
    }

    // ============ OPPORTUNITY TESTS ============

    function test_CreateOpportunity() public {
        vm.startPrank(creator1);

        vm.expectEmit(true, true, false, true);
        emit OpportunityCreated(0, creator1, "Build DApp", 1 ether, block.timestamp);

        bora.createOpportunity("Build DApp", "Need a developer", requiredSkills, 1 ether);

        Bora.Opportunity memory opp = bora.getOpportunity(0);
        assertEq(opp.id, 0);
        assertEq(opp.creator, creator1);
        assertEq(opp.title, "Build DApp");
        assertEq(opp.budget, 1 ether);
        assertTrue(opp.isActive);

        vm.stopPrank();
    }

    function test_RevertWhen_CreateOpportunity_EmptyTitle() public {
        vm.prank(creator1);
        vm.expectRevert("Title cannot be empty");
        bora.createOpportunity("", "Description", requiredSkills, 1 ether);
    }

    function test_RevertWhen_CreateOpportunity_NoSkills() public {
        string[] memory empty;
        vm.prank(creator1);
        vm.expectRevert("Must specify required skills");
        bora.createOpportunity("Title", "Description", empty, 1 ether);
    }

    function test_RevertWhen_CreateOpportunity_ZeroBudget() public {
        vm.prank(creator1);
        vm.expectRevert("Budget must be greater than 0");
        bora.createOpportunity("Title", "Description", requiredSkills, 0);
    }

    function test_DepositEscrow() public {
        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(creator1);
        bora.depositEscrow{value: 0.5 ether}(0);

        Bora.Opportunity memory opp = bora.getOpportunity(0);
        assertEq(opp.escrowBalance, 0.5 ether);
    }

    function test_CloseOpportunity() public {
        vm.startPrank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);
        bora.depositEscrow{value: 1 ether}(0);

        uint256 balanceBefore = creator1.balance;
        bora.closeOpportunity(0);

        Bora.Opportunity memory opp = bora.getOpportunity(0);
        assertFalse(opp.isActive);
        assertEq(opp.escrowBalance, 0);
        assertEq(creator1.balance, balanceBefore + 1 ether);

        vm.stopPrank();
    }

    // ============ SWIPE TESTS ============

    function test_SwipeOpportunity_Like() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(dev1);
        vm.expectEmit(true, true, false, true);
        emit SwipeMade(dev1, 0, true, block.timestamp);
        bora.swipeOpportunity(0, true);

        Bora.Swipe memory swipe = bora.getSwipe(dev1, 0);
        assertTrue(swipe.isLike);
    }

    function test_SwipeOpportunity_Dislike() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(dev1);
        bora.swipeOpportunity(0, false);

        Bora.Swipe memory swipe = bora.getSwipe(dev1, 0);
        assertFalse(swipe.isLike);
    }

    function test_RevertWhen_SwipeOpportunity_NotDeveloper() public {
        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(dev1);
        vm.expectRevert(NotDeveloper.selector);
        bora.swipeOpportunity(0, true);
    }

    function test_RevertWhen_SwipeOpportunity_AlreadySwiped() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.startPrank(dev1);
        bora.swipeOpportunity(0, true);

        vm.expectRevert("Already swiped this opportunity");
        bora.swipeOpportunity(0, true);
        vm.stopPrank();
    }

    function test_RevertWhen_SwipeOpportunity_OwnOpportunity() public {
        vm.startPrank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.expectRevert("Cannot swipe own opportunity");
        bora.swipeOpportunity(0, true);
        vm.stopPrank();
    }

    // ============ MATCH TESTS ============

    function test_AcceptMatch() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(dev1);
        bora.swipeOpportunity(0, true);

        vm.prank(creator1);
        vm.expectEmit(true, true, true, true);
        emit MatchCreated(0, dev1, 0, creator1, block.timestamp);
        bora.acceptMatch(0, dev1);

        Bora.Match memory matchData = bora.getUserMatches(dev1)[0];
        assertEq(matchData.id, 0);
        assertEq(matchData.developer, dev1);
        assertTrue(matchData.isActive);
        assertFalse(matchData.isCompleted);
    }

    function test_CompleteJob() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.startPrank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);
        bora.depositEscrow{value: 1 ether}(0);
        vm.stopPrank();

        vm.prank(dev1);
        bora.swipeOpportunity(0, true);

        vm.prank(creator1);
        bora.acceptMatch(0, dev1);

        uint256 devBalanceBefore = dev1.balance;

        vm.prank(creator1);
        bora.completeJob(0, 50);

        Bora.Developer memory dev = bora.getDeveloper(dev1);
        assertEq(dev.reputation, 150);
        assertEq(dev.completedJobs, 1);

        // Check payment (1 ETH - 2.5% fee)
        uint256 expectedPayment = 1 ether - (1 ether * 250 / 10000);
        assertEq(dev1.balance, devBalanceBefore + expectedPayment);
    }

    function test_CompleteJobWithoutEscrow() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(dev1);
        bora.swipeOpportunity(0, true);

        vm.prank(creator1);
        bora.acceptMatch(0, dev1);

        vm.prank(creator1);
        bora.completeJob(0, 50);

        Bora.Developer memory dev = bora.getDeveloper(dev1);
        assertEq(dev.reputation, 150);
        assertEq(dev.completedJobs, 1);
    }

    // ============ ADMIN TESTS ============

    function test_SetPlatformFee() public {
        bora.setPlatformFee(500);
        assertEq(bora.platformFee(), 500);
    }

    function test_RevertWhen_SetPlatformFee_TooHigh() public {
        vm.expectRevert("Fee too high");
        bora.setPlatformFee(1001);
    }

    function test_TogglePause() public {
        assertFalse(bora.paused());
        bora.togglePause();
        assertTrue(bora.paused());
        bora.togglePause();
        assertFalse(bora.paused());
    }

    function test_RevertWhen_CreateProfile_WhenPaused() public {
        bora.togglePause();

        vm.prank(dev1);
        vm.expectRevert(ContractPaused.selector);
        bora.createDeveloperProfile("Alice", skills, "Bio");
    }

    function test_WithdrawPlatformFees() public {
        // Setup and complete a job to generate fees
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.startPrank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);
        bora.depositEscrow{value: 1 ether}(0);
        vm.stopPrank();

        vm.prank(dev1);
        bora.swipeOpportunity(0, true);

        vm.prank(creator1);
        bora.acceptMatch(0, dev1);

        vm.prank(creator1);
        bora.completeJob(0, 50);

        // Now withdraw fees
        uint256 contractBalance = address(bora).balance;
        uint256 ownerBalanceBefore = address(this).balance;

        bora.withdrawPlatformFees();

        assertEq(address(this).balance, ownerBalanceBefore + contractBalance);
        assertEq(address(bora).balance, 0);
    }

    // ============ VIEW FUNCTION TESTS ============

    function test_GetActiveOpportunities() public {
        vm.startPrank(creator1);
        bora.createOpportunity("Job 1", "Description", requiredSkills, 1 ether);
        bora.createOpportunity("Job 2", "Description", requiredSkills, 2 ether);
        vm.stopPrank();

        Bora.Opportunity[] memory active = bora.getActiveOpportunities();
        assertEq(active.length, 2);
        assertEq(active[0].title, "Job 1");
        assertEq(active[1].title, "Job 2");
    }

    function test_GetActiveOpportunities_FiltersClosed() public {
        vm.startPrank(creator1);
        bora.createOpportunity("Job 1", "Description", requiredSkills, 1 ether);
        bora.createOpportunity("Job 2", "Description", requiredSkills, 2 ether);
        bora.closeOpportunity(0);
        vm.stopPrank();

        Bora.Opportunity[] memory active = bora.getActiveOpportunities();
        assertEq(active.length, 1);
        assertEq(active[0].title, "Job 2");
    }

    function test_GetTotalOpportunities() public {
        vm.prank(creator1);
        bora.createOpportunity("Job 1", "Description", requiredSkills, 1 ether);

        assertEq(bora.getTotalOpportunities(), 1);
    }

    function test_GetTotalMatches() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(dev1);
        bora.swipeOpportunity(0, true);

        vm.prank(creator1);
        bora.acceptMatch(0, dev1);

        assertEq(bora.getTotalMatches(), 1);
    }

    function test_GetUserMatches() public {
        vm.prank(dev1);
        bora.createDeveloperProfile("Alice", skills, "Bio");

        vm.prank(creator1);
        bora.createOpportunity("Build DApp", "Description", requiredSkills, 1 ether);

        vm.prank(dev1);
        bora.swipeOpportunity(0, true);

        vm.prank(creator1);
        bora.acceptMatch(0, dev1);

        Bora.Match[] memory matches = bora.getUserMatches(dev1);
        assertEq(matches.length, 1);
        assertEq(matches[0].developer, dev1);
    }
}
