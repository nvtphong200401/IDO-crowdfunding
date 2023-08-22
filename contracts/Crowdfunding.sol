//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "hardhat/console.sol";
import "./Project.sol";

contract Crowdfunding {
    using SafeERC20 for IERC20;

    using SafeMath for uint256;

    event ProjectStarted(
        address projectContractAddress,
        address creator,
        IERC20 token,
        uint256 tokenPrice,
        uint256 minContribution,
        uint256 projectDeadline,
        uint256 goalAmount,
        uint256 currentAmount,
        uint256 noOfContributors,
        string title,
        string desc,
        uint256 currentState
    );

    event ContributionReceived(
        address projectAddress,
        uint256 contributedAmount,
        address indexed contributor
    );

    Project[] private projects;

    // @dev Anyone can start a fund rising
    // @return null

    function createProject(
        IERC20 token,
        uint256 tokenPrice,
        uint256 minimumContribution,
        uint256 deadline,
        uint256 targetContribution,
        string memory projectTitle,
        string memory projectDesc
    ) public {
        deadline = deadline;
        Project newProject = new Project(
            msg.sender,
            token,
            tokenPrice,
            minimumContribution,
            deadline,
            targetContribution,
            projectTitle,
            projectDesc
        );
        projects.push(newProject);
        IERC20(token).safeTransfer(address(newProject), 10**7);
        emit ProjectStarted(
            address(newProject),
            msg.sender,
            token,
            tokenPrice,
            minimumContribution,
            deadline,
            targetContribution,
            0,
            0,
            projectTitle,
            projectDesc,
            0
        );
    }

    // @dev Get projects list
    // @return array

    function returnAllProjects() external view returns (Project[] memory) {
        return projects;
    }

    // @dev User can contribute
    // @return null

    function contribute(address _projectAddress) public payable {
        uint256 minContributionAmount = Project(_projectAddress)
            .minimumContribution();
        Project.State projectState = Project(_projectAddress).state();
        require(projectState == Project.State.Fundraising, "Invalid state");
        require(
            msg.value >= minContributionAmount,
            "Contribution amount is too low !"
        );
        // Call function
        Project(_projectAddress).contribute{value: msg.value}(msg.sender);
        // Trigger event
        emit ContributionReceived(_projectAddress, msg.value, msg.sender);
    }
}
