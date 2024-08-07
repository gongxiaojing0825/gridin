// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract GIMToken is ERC20, ERC20Burnable, Pausable, Ownable {
    using SafeMath for uint256;

    uint256 private constant TOTAL_SUPPLY = 1_000_000_000 * 10**18; // 1 billion tokens
    
    uint256 private constant GOVERNANCE_ALLOCATION = TOTAL_SUPPLY.mul(20).div(100);
    uint256 private constant CORE_TEAM_ALLOCATION = TOTAL_SUPPLY.mul(15).div(100);
    uint256 private constant INVESTORS_ALLOCATION = TOTAL_SUPPLY.mul(25).div(100);
    uint256 private constant ECOSYSTEM_ALLOCATION = TOTAL_SUPPLY.mul(30).div(100);
    uint256 private constant TREASURY_ALLOCATION = TOTAL_SUPPLY.mul(10).div(100);

    uint256 private constant SECONDS_PER_MONTH = 30 days;

    struct VestingSchedule {
        uint256 totalAllocation;
        uint256 cliffDuration;
        uint256 vestingDuration;
        uint256 vestingStartTime;
        uint256 released;
    }

    mapping(address => VestingSchedule) public vestingSchedules;

    constructor() ERC20("Gridin.ai", "GIM") {
        _mint(address(this), TOTAL_SUPPLY);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setVestingSchedule(
        address beneficiary,
        uint256 totalAllocation,
        uint256 cliffDurationMonths,
        uint256 vestingDurationMonths
    ) public onlyOwner {
        require(vestingSchedules[beneficiary].totalAllocation == 0, "Vesting schedule already set");
        
        vestingSchedules[beneficiary] = VestingSchedule({
            totalAllocation: totalAllocation,
            cliffDuration: cliffDurationMonths.mul(SECONDS_PER_MONTH),
            vestingDuration: vestingDurationMonths.mul(SECONDS_PER_MONTH),
            vestingStartTime: block.timestamp,
            released: 0
        });
    }

    function releaseVestedTokens(address beneficiary) public {
        VestingSchedule storage schedule = vestingSchedules[beneficiary];
        require(schedule.totalAllocation > 0, "No vesting schedule found");

        uint256 releasable = vestedAmount(beneficiary).sub(schedule.released);
        require(releasable > 0, "No tokens are due for release");

        schedule.released = schedule.released.add(releasable);
        _transfer(address(this), beneficiary, releasable);
    }

    function vestedAmount(address beneficiary) public view returns (uint256) {
        VestingSchedule storage schedule = vestingSchedules[beneficiary];
        
        if (block.timestamp < schedule.vestingStartTime.add(schedule.cliffDuration)) {
            return 0;
        } else if (block.timestamp >= schedule.vestingStartTime.add(schedule.vestingDuration)) {
            return schedule.totalAllocation;
        } else {
            return schedule.totalAllocation.mul(
                block.timestamp.sub(schedule.vestingStartTime)
            ).div(schedule.vestingDuration);
        }
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(_msgSender()) >= amount, "ERC20: transfer amount exceeds balance");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(balanceOf(sender) >= amount, "ERC20: transfer amount exceeds balance");
        return super.transferFrom(sender, recipient, amount);
    }

    // Function to set up initial allocations (to be called after deployment)
    function setupInitialAllocations(
        address governanceWallet,
        address coreTeamWallet,
        address investorsWallet,
        address ecosystemWallet,
        address treasuryWallet
    ) public onlyOwner {
        setVestingSchedule(governanceWallet, GOVERNANCE_ALLOCATION, 6, 24);
        setVestingSchedule(coreTeamWallet, CORE_TEAM_ALLOCATION, 12, 36);
        setVestingSchedule(investorsWallet, INVESTORS_ALLOCATION, 3, 18);
        setVestingSchedule(ecosystemWallet, ECOSYSTEM_ALLOCATION, 0, 48);
        setVestingSchedule(treasuryWallet, TREASURY_ALLOCATION, 6, 60);

        // Release 10% of investor allocation and 5% of ecosystem allocation immediately
        _transfer(address(this), investorsWallet, INVESTORS_ALLOCATION.mul(10).div(100));
        _transfer(address(this), ecosystemWallet, ECOSYSTEM_ALLOCATION.mul(5).div(100));
    }
}