// SPDX-License-Identifier: MIT

// This contract is provided "as-is" under the principle of code-is-law.
// Any actions taken by this contract are considered the expected outcomes from a legal perspective.
// The deployer and maintainers have no liability in the result of any error.
// By interacting with this contract in any way you agree to these terms.

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

pragma solidity ^0.8.0;

contract SeedFarm {
    using SafeERC20 for IERC20;

    //SeedSwap Token
    seedSwapToken public SNFT;
    //SeedSwap Project Dev Address
    address public devaddr;



}