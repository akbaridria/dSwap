// SPDX-License-Identifier: GPL-3.0-or-later

//solhint-disable-next-line compiler-version
pragma solidity >=0.5.0;

interface IDswapCallee {
    function dSwapCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}
