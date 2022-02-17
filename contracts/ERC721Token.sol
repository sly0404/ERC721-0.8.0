pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "./IERC721.sol";

contract ERC721Token is IERC721
{
  using SafeMath for uint256;

  bytes4 private constant _INTERFACE_ID_IERC165 = 0x01ffc9a7; //= getSupportsInterfaceSelector();
  mapping (bytes4 => bool) private _supportedInterfaces;

    constructor(uint initialSupply) public
    {
      _registerInterface(_INTERFACE_ID_IERC165);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool)
    {
      return _supportedInterfaces[interfaceId];
    }

    function _registerInterface(bytes4 interfaceId) internal 
    {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }

    function getSupportsInterfaceSelector() external pure returns (bytes4)
    {
      return this.supportsInterface.selector;
    }

    function balanceOf(address _owner) external view returns (uint256)
    {
      return 0x12;
    }

    function ownerOf(uint256 _tokenId) external view returns (address)
    {
      return address(0);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable
    {
      
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable
    {
      
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable
    {
      
    }

    function approve(address _approved, uint256 _tokenId) external payable
    {
      
    }

    function setApprovalForAll(address _operator, bool _approved) external
    {
      
    }

    function getApproved(uint256 _tokenId) external view returns (address)
    {
      
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool)
    {
      
    }
}