// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

/// @title Mock Frax Gauge Controller

contract MockFraxGaugeController {

    uint256 public time_total;
    uint256 public global_emission_rate;

    address[] public gauges;
    mapping(address => uint256) public gauge_relative_weights;
    uint256 public total_weight;

    constructor (uint256 _global_emission_rate) {
        time_total = block.timestamp;
        global_emission_rate = _global_emission_rate; // FXS distributed per week
        // gauges = _gauges;
    }

    function add_gauge(address gauge_address, int128 gauge_type, uint256 weight) external {
        gauge_type;
        weight;
        gauges.push(gauge_address);
    }

    function vote(address gauge_address, uint256 gaugeWeight) external {
        require(block.timestamp < time_total + 604800, "Voting period has ended");
        total_weight += gaugeWeight;
        gauge_relative_weights[gauge_address] = gaugeWeight;
    }

    function reset() external {
        require(block.timestamp > time_total + 604800, "Not enough time has passed");
        total_weight = 0;
        for (uint256 i; i < gauges.length; i++) {
            gauge_relative_weights[gauges[i]] = 0;
        }
    }

    function change_emission_rate(uint256 new_rate) external {
        global_emission_rate = new_rate;
    }

    function gauge_relative_weight_write(address gauge_address, uint256 time) external view returns (uint256){
        //
        time;
        return gauge_relative_weights[gauge_address] / total_weight;
    }

    function gauge_relative_weight(address gauge_address, uint256 time) external view returns (uint256){
        //
        time;
        return gauge_relative_weights[gauge_address];
    }
}