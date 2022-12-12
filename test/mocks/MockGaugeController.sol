// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract MockGaugeController {
    uint256 _gauge_relative_weight_write;
    uint256 _global_emission_rate;
    uint256 _time_total;
    mapping(address => uint256) _gauge_weight;
    address owner;

    constructor(
        uint256 __gauge_relative_weight_write,
        uint256 __global_emission_rate,
        uint256 __time_total
    ) {
        _gauge_relative_weight_write = __gauge_relative_weight_write;
        _global_emission_rate = __global_emission_rate;
        _time_total = __time_total;
        owner = msg.sender;
    }

    function set_gauge_weight(address gauge, uint256 gauge_weight) external {
        _gauge_weight[gauge] = gauge_weight;
    }

    function get_gauge_weight(address gauge) external view returns (uint256) {
        return _gauge_weight[gauge];
    }

    function time_total() external view returns (uint256) {
        return _time_total;
    }

    function global_emission_rate() external view returns (uint256) {
        return _global_emission_rate;
    }

    function gauge_relative_weight_write(address, uint256) external view returns (uint256) {
        return _gauge_relative_weight_write;
    }
}
