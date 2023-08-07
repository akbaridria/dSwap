// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity =0.8.4;

import {IDSwapFactory} from "./interfaces/IDSwapFactory.sol";
import {IDswapPair} from "./interfaces/IDswapPair.sol";
import {dSwapPair} from "./dSwapPair.sol";

contract dSwapFactory is IDSwapFactory {
    bytes32 public constant PAIR_HASH =
        keccak256(type(dSwapPair).creationCode);

    address public override feeTo;
    address public override feeToSetter;

    mapping(address => mapping(address => address)) public override getPair;
    address[] public override allPairs;

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view override returns (uint256) {
        return allPairs.length;
    }

    function createPair(
        address tokenA,
        address tokenB
    ) external override returns (address pair) {
        require(tokenA != tokenB, "dSwap: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "dSwap: ZERO_ADDRESS");
        require(
            getPair[token0][token1] == address(0),
            "dSwap: PAIR_EXISTS"
        ); // single check is sufficient

        pair = address(
            new dSwapPair{
                salt: keccak256(abi.encodePacked(token0, token1))
            }()
        );
        IDswapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external override {
        require(msg.sender == feeToSetter, "dSwap: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external override {
        require(msg.sender == feeToSetter, "dSwap: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
