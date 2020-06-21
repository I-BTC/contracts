pragma solidity 0.5.15;

contract Owner {

    address public OwnerAddress;

    modifier isOwner(){
        require( msg.sender == OwnerAddress);
        _;
    }

    function changeOwner( address newOwner )
        public
        isOwner
        returns ( bool )
    {
        OwnerAddress = newOwner;
        emit ownerChange( newOwner );
        return true;
    }

    event ownerChange ( address _newOwner );
}
