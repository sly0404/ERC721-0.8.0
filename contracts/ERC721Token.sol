pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "./IERC721.sol";

contract ERC721Token is IERC721
{
  using SafeMath for uint256;

  bytes4 private constant _INTERFACE_ID_IERC165 = 0x01ffc9a7; //= getSupportsInterfaceSelector();
  bytes4 private constant _INTERFACE_ID_IERC721 = 0x80ac58cd;
  mapping (bytes4 => bool) private _supportedInterfaces;

  // The address of the contract creator
  address internal creator;// The highest valid tokenId, for checking if a tokenId is valid
  uint256 internal maxId;// A mapping storing the balance of each address
  mapping(address => uint256) internal balances;// A mapping of burnt tokens, for checking if a tokenId is valid
  // Not needed if your token can't be burnt
  mapping(uint256 => bool) internal burned;// A mapping of token owners
  mapping(uint256 => address) internal owners;// A mapping of the "approved" address for each token
  mapping (uint256 => address) internal allowance;// A nested mapping for managing "operators"
  mapping (address => mapping (address => bool)) internal authorised;


    constructor(uint initialSupply) public
    {
      // Store the address of the creator
      creator = msg.sender;
      
      // All initial tokens belong to creator, so set the balance
      balances[creator] = initialSupply;  
      // Set maxId to number of tokens
      maxId = initialSupply;
      registerInterface(_INTERFACE_ID_IERC165);
      registerInterface(_INTERFACE_ID_IERC721);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool)
    {
      return _supportedInterfaces[interfaceId];
    }

    function registerInterface(bytes4 interfaceId) internal 
    {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }

    function getSupportsInterfaceSelector() external pure returns (bytes4)
    {
      return this.supportsInterface.selector;
    }

    function isValidToken(uint256 tokenId) internal view returns(bool)
    {
      return tokenId != 0 && tokenId <= maxId && !burned[tokenId];
    }

    function balanceOf(address owner) external view returns (uint256)
    {
      require(owner != address(0), "ERC721: owner must not be address 0x!");
      return balances[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address)
    {
      require(isValidToken(tokenId), "ERC721: owner must not be address 0x!");
      if(owners[tokenId] != address(0))
      {
        return owners[tokenId];
      }
      else
      {
        return creator;
      } 
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable
    {
      
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable
    {
      
    }
    
    /*
    cette fonction est payable afin de mttre la guarantie de mutabilité au minimum, 
      si l'utilisateur veut être plus restrictif il peut l'enlever. C'est pour ça que
      l'implémentation de OpenZeppelin l'enlève.
    */
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