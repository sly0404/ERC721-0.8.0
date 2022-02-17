pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NFTToken.sol";

contract TestERC721
{
    bytes4 private constant _INTERFACE_ID_IERC165 = 0x01ffc9a7;
    
    //string private testMessage = string(abi.encodePacked("accounts[0] must have ",balanceReceiver," GWEIS."));
    NFTToken private nftToken = NFTToken(DeployedAddresses.NFTToken());
    string private errorTestGetSupportsInterfaceSelectorMessage = "wrong interface selector!";
    string private errorTestSupportsInterfaceMessage = "interface not supported!";
    
    function testGetSupportsInterfaceSelector() public
    {
        Assert.equal(nftToken.getSupportsInterfaceSelector(), _INTERFACE_ID_IERC165, errorTestGetSupportsInterfaceSelectorMessage);
    }

    function testSupportsInterface() public
    {
        Assert.isTrue(nftToken.supportsInterface(_INTERFACE_ID_IERC165), errorTestSupportsInterfaceMessage);
    }
}