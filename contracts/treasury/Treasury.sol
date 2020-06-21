pragma solidity 0.5.15;

import "./Treasury_ds.sol";

contract Treasury is Treasury_ds{


    constructor(  )
        public
    {
        OwnerAddress = msg.sender;
        contractState = false;
    }

    function setParent( address[] memory _masterParent , uint256 _limit )
        internal
    {
        for (uint i=0; i<_masterParent.length; i++) {
            userLevel[_masterParent[i]].level = _limit;
            PCTree[_masterParent[i]] = address(0);
        }
    }

    function setLevels( uint256[] memory _percent , uint256[] memory _salesLimit )
        isSameLength( _salesLimit.length , _percent.length )
        internal
    {
        for (uint i=0; i<_salesLimit.length; i++) {
            Levels[i+1] = LLimit( _percent[i] ,_salesLimit[i] );
        }
    }

    function setupTreasury ( address _TAddr ,  uint256 _limit , uint256 _rate , uint256[] memory _percent ,uint256[] memory _salesLimit , address _masterParent )
        isInActive
        isOwner
        public
        returns ( bool )
    {
        tokenLimit = _limit;
        Token = IBTCToken( _TAddr );
        TokenAddr = _TAddr;
        Rate = _rate;
        MaxLevel = _salesLimit.length;
        setLevels( _percent , _salesLimit );
        PCTree[_masterParent] = address(0);
        masterAddr = _masterParent;
        userLevel[_masterParent].level = MaxLevel;
        contractState = true;
        return true;
    }

    function calcRate ( uint256 _value )
        public
        view
        returns ( uint256 )
    {
        return _value.mul( 10**18 ).div( Rate );
    }

    function LoopFx ( address _addr , uint256 _token ,  uint256 _value , uint256 _shareRatio )
        internal
        returns ( uint256 value )
    {
        userLevel[ _addr ].sales = userLevel[ _addr ].sales.add( _token );
        if( _shareRatio < Levels[ userLevel[ _addr ].level ].percent ){
            uint256 diff = Levels[ userLevel[ _addr ].level ].percent.sub(_shareRatio);
            userLevel[ _addr ].share = userLevel[ _addr ].share.add( _value.mul(diff).div(10000) );
            value = Levels[ userLevel[ _addr ].level ].percent;
        }else if( _shareRatio == Levels[ userLevel[ _addr ].level ].percent ){
            value = Levels[ userLevel[ _addr ].level ].percent;
        }
        return value;
    }

    function LevelChange ( address _addr )
        internal
    {
        uint256 curLevel = userLevel[_addr ].level;
        while( curLevel <= MaxLevel){
            if( ( userLevel[ _addr ].sales < Levels[ curLevel ].salesLimit ) ){
                break;
            }else{
                userLevel[_addr ].level = curLevel;
            }
            curLevel = curLevel.add(1);
        }
    }

    function purchase ( address _referer )
        isActive
        isVaildReferer( _referer )
        payable
        public
        returns ( bool )
    {
        address Parent;
        uint256 cut = 0;
        uint256 tokens = calcRate(msg.value);
        uint256 lx = 0;
        bool overflow = false;
        iMint( msg.sender , tokens);
        if( userLevel[ msg.sender ].level == 0 ){
            userLevel[ msg.sender ].level = 1;
        }
        if( PCTree[msg.sender] == address(0)){
            Parent = _referer;
            PCTree[msg.sender] = Parent;
        }else{
            Parent = PCTree[msg.sender];
        }
        while( lx < 100 ){
            lx = lx.add(1);
            cut = LoopFx( Parent , tokens , msg.value , cut );
            LevelChange( Parent );
            if( PCTree[ Parent ] == address(0)){
                break;
            }
            Parent = PCTree[ Parent ];
            if( lx == 100){
                overflow = true;
            }
        }
        if( overflow ){
            cut = LoopFx( masterAddr , tokens , msg.value , cut );
        }
        emit puchaseEvent( msg.sender , PCTree[msg.sender] , msg.value , tokens );
        return true;
    }

    function iMint ( address _addr , uint256 _value )
        isSaleClose( _value )
        internal
    {
        Token.mint( _addr , _value );
        totalSale = totalSale.add( _value );
    }

    function claim (uint256 _amt)
        isVaildClaim( _amt )
        payable
        public
        returns ( bool )
    {
        userLevel[ msg.sender ].share = userLevel[ msg.sender ].share.sub( _amt );
        msg.sender.transfer( _amt );
        emit claimEvent( msg.sender , _amt , userLevel[ msg.sender ].share );
        return true;
    }

    function viewStatus( address _addr )
        view
        public
        returns ( uint256 _level , uint256 _sales , uint256 _claim )
    {
        _level = userLevel[ _addr ].level;
        _sales = userLevel[ _addr ].sales;
        _claim = userLevel[ _addr ].share;
    }

    function checkRef ( address _ref)
        public
        view
        returns ( bool )
    {
        return ( userLevel[_ref].level != 0 );
    }

}
