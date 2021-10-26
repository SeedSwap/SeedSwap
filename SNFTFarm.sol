// SPDX-License-Identifier: MIT

// This contract is provided "as-is" under the principle of code-is-law.
// Any actions taken by this contract are considered the expected outcomes from a legal perspective.
// The deployer and maintainers have no liability in the result of any error.
// By interacting with this contract in any way you agree to these terms.

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

pragma solidity ^0.8.0;

contract SNFTFarm {
    
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => uint256) public startTime;
    mapping(address => uint256) public snftBalance;
    
    string public name = "SNFTFarm";
    
    IERC20 public SNFTLP;
    IERC20 public SNFTToken;
    address public tresaddr;
    uint256 public rewardPerBlock;
    uint256 public farmStartBlock;
    uint256 public mulRewRedAfterBlock;
    uint256[] public rewardMultiplier =[659563, 659563, 494672, 494672, 494672, 329781, 164890, 164890, 247336, 164890, 82445, 82445, 123668, 82445, 41222, 41222, 31925];

    event Stake(address indexed from, uint256 amount);
    event Unstake(address indexed from, uint256 amount);
    event YieldWithdraw(address indexed to, uint256 amount);
    
    constructor(
        IERC20 _SNFTLP,
        IERC20 _snftToken,
        address _tresaddr,
        uint256 _rewardPerBlock,
        ) 
        
        {
            SNFTLP = _SNFTLP;
            SNFTToken = _snftToken;
            tresaddr = _tresaddr;
            rewardPerBlock = _rewardPerBlock;
            farmStartBlock = block.number;
            for
        }
        
    function stake(uint256 amount) public { 
    require(amount > 40 && SNFTLP.balanceOf(msg.sender) >= amount, "Under minimum staking requirements");
            
     if(isStaking[msg.sender] == true){
        uint256 toTransfer = calculateYieldTotal(msg.sender);
        snftBalance[msg.sender] += toTransfer;
        }
        uint256 afterFees = ((amount * 975) / 1000);
        uint256 tresFee = ((amount * 25) / 1000);
        SNFTLP.transferFrom(msg.sender, address(this), afterFees);
        SNFTLP.transferFrom(msg.sender, address(tresaddr), tresFee);
        stakingBalance[msg.sender] += afterFees;
        startTime[msg.sender] = block.number;
        isStaking[msg.sender] = true;
        emit Stake(msg.sender, amount);
    }
    
    function unstake(uint256 amount) public {
        require(isStaking[msg.sender] = true && stakingBalance[msg.sender] >= amount, "Insufficient Staked LP Tokens");
        uint256 yieldTransfer = calculateYieldTotal(msg.sender);
        uint256 balTransfer = amount;
        amount = 0;
        stakingBalance[msg.sender] -= balTransfer;
        if(startTime[msg.sender] == block.number){
        SNFTLP.transfer(msg.sender, ((balTransfer * 75) / 100);
        SNFTLP.transfer(tresaddr, ((balTransfer * 25) / 100);
        } else {
            SNFTLP.transfer(msg.sender, balTransfer);
        }
        //25% fee for withdrawals of LP tokens in the same block this is to prevent abuse from flashloans
        startTime[msg.sender] = block.number;
        snftBalance[msg.sender] += yieldTransfer;
        if(stakingBalance[msg.sender] == 0){
            isStaking[msg.sender] = false;
        }
        emit Unstake(msg.sender, balTransfer);
    }

    function calculateYieldTime(address user) public view returns(uint256){
        uint256 end = block.number;
        uint256 totalTime = end - startTime[user];
        return totalTime;
    }

    function calculateYieldTotal(address user) public view returns(uint256) {
        if(isStaking[user]
    } 

    function withdrawYield() public {
        uint256 toTransfer = calculateYieldTotal(msg.sender);

        require(toTransfer > 0 || snftBalance[msg.sender] > 0, "Insufficient amount" );
            
        if(snftBalance[msg.sender] != 0){
            uint256 oldBalance = snftBalance[msg.sender];
            snftBalance[msg.sender] = 0;
            toTransfer += oldBalance;
        }

        startTime[msg.sender] = block.number;
        SNFTToken.transfer(msg.sender, toTransfer);
        emit YieldWithdraw(msg.sender, toTransfer);
    } 
    
}