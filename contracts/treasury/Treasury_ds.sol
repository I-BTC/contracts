pragma solidity 0.5.15;

import "../token/IBTCToken.sol";

contract Treasury_ds is Owner {
    using SafeMath for uint256;

    bool public contractState;

    IBTCToken Token;

    address public TokenAddr;

    address masterAddr;

    uint256 public Rate;

    uint256 public totalSale;

    uint256 public tokenLimit;

    mapping ( uint256 => LLimit ) public Levels;

    struct LLimit{
        uint256 percent;
        uint256 salesLimit;
    }

    uint256 public MaxLevel;

//    Child -> Parent Mapping
    mapping ( address => address ) public PCTree;

    mapping ( address => userData ) public userLevel;

    struct userData{
        uint256 level;
        uint256 sales;
        uint256 share;
    }

    modifier isInActive(){
        require(contractState == false);
        _;
    }

    modifier isActive(){
        require(contractState == true);
        _;
    }

    modifier isSameLength ( uint256 _s1 , uint256 _s2 ){
        require(_s1 == _s2);
        _;
    }

    modifier isVaildClaim( uint256 _amt ){
        require( userLevel[msg.sender].share >= _amt );
        _;
    }

    modifier isVaildReferer( address _ref ){
        require( userLevel[_ref].level != 0 );
        _;
    }

    modifier isSaleClose ( uint256 _amt ){
        require( totalSale.add(_amt) <= tokenLimit );
        _;
    }

    event puchaseEvent( address indexed _buyer , address indexed _referer , uint256 _value , uint256 _tokens );

    event claimEvent( address indexed _buyer ,  uint256 _value , uint256 _pendingShare );

}
