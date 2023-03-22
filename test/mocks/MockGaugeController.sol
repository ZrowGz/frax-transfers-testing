// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

// import "lib/forge-std/src/console2.sol";

// /// @title Mock Frax Gauge Controller

// contract MockFraxGaugeController {

//     uint256 public time_total;
//     uint256 public global_emission_rate;

//     address[] public gauges;
//     mapping(address => uint256) public gauge_relative_weights;
//     uint256 public total_weight;

//     constructor (uint256 _global_emission_rate) {
//         time_total = block.timestamp;
//         global_emission_rate = _global_emission_rate; // FXS distributed per week
//         // gauges = _gauges;
//     }

//     function add_gauge(address gauge_address, int128 gauge_type, uint256 weight) external {
//         gauge_type;
//         weight;
//         gauges.push(gauge_address);
//     }

//     // function vote(address gauge_address, uint256 gaugeWeight) external {
//     //     console2.log("time total: ", time_total);
//     //     console2.log("now: ", block.timestamp);
//     //     require(block.timestamp < time_total + 604800, "Voting period has ended");
//     //     total_weight += gaugeWeight;
//     //     gauge_relative_weights[gauge_address] = gaugeWeight;
//     //     console2.log("gauge relative weight: ", gauge_relative_weights[gauge_address]);
//     //     console2.log("total weight: ", total_weight);
//     // }
    

//     function reset() external {
//         console2.log("time total: ", time_total);
//         console2.log("now: ", block.timestamp);
//         require(block.timestamp > time_total + 604800, "Not enough time has passed");
//         total_weight = 0;
//         for (uint256 i; i < gauges.length; i++) {
//             gauge_relative_weights[gauges[i]] = 0;
//         }
//     }

//     function change_emission_rate(uint256 new_rate) external {
//         global_emission_rate = new_rate;
//     }

//     function gauge_relative_weight_write(address gauge_address, uint256 time) external view returns (uint256){
//         //
//         time;
//         console2.log("gauge relative weight write: ", gauge_relative_weights[gauge_address], time);//gauge_relative_weights[gauge_address] / total_weight,
//         return gauge_relative_weights[gauge_address];// / total_weight;
//     }

//     function gauge_relative_weight(address gauge_address, uint256 time) external view returns (uint256){
//         //
//         time;
//         console2.log("gauge relative weight: ", gauge_relative_weights[gauge_address], time);
//         return gauge_relative_weights[gauge_address];
//     }
// }