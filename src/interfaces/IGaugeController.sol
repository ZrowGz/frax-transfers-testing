// SPDX-License-Identifier: MIT
pragma solidity >0.8.6;

interface IGaugeController {
    struct VotedSlope {
        uint256 slope;
        uint256 power;
        uint256 end;
    }

    struct Point {
        uint256 bias;
        uint256 slope;
    }

    function admin() external view returns (address);

    function vote_user_slopes(address, address) external view returns (VotedSlope memory);

    function gauge_relative_weight(address) external view returns (uint256);

    function last_user_vote(address, address) external view returns (uint256);

    function points_weight(address, uint256) external view returns (Point memory);

    function checkpoint_gauge(address) external;

    function time_total() external view returns (uint256);
}

interface ISaddleGaugeController is IGaugeController {
    function set_voting_enabled(bool) external;
}
