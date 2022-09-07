pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "./IERC721.sol";
import "./IERC721TokenReceiver.sol";

contract ERC721Token is IERC721
{
  using SafeMath for uint256;

  bytes4 private constant _INTERFACE_ID_IERC165 = 0x01ffc9a7; //= getSupportsInterfaceSelector();
  bytes4 private constant _INTERFACE_ID_IERC721 = 0x80ac58cd;
  mapping (bytes4 => bool) private _supportedInterfaces;

  // The address of the contract creator
  address internal creator;
  // The highest valid tokenId, for checking if a tokenId is valid
  uint256 internal maxId;
  // A mapping storing the balance of each address
  mapping(address => uint256) internal balances;
  // A mapping of burnt tokens, for checking if a tokenId is valid
  // Not needed if your token can't be burnt
  mapping(uint256 => bool) internal burned;
  // A mapping of token owners
  mapping(uint256 => address) internal owners;
  // A mapping of the "approved" address for each token
  mapping (uint256 => address) internal allowance;
  // A nested mapping for managing "operators"
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

    function getMsgSender() external view returns (address)
    {
      return msg.sender;
    }

    function getCreator() external view returns (address)
    {
      return creator;
    }

    function balanceOf(address owner) external view returns (uint256)
    {
      require(owner != address(0), "ERC721: owner must not be address 0x!");
      return balances[owner];
    }

    /*
    il faut déclarer la visibilité de cette fonction en public car An external function cannot be called internally
    cf https://docs.soliditylang.org/en/v0.4.24/contracts.html#visibility-and-getters
    */
    function ownerOf(uint256 tokenId) public view returns (address)
    {
      require(isValidToken(tokenId), "ERC721: tokenId not valid!");
      if(owners[tokenId] != address(0))
      {
        return owners[tokenId];
      }
      else
      {
        return creator;
      } 
    }

    //changement calldata en memory car calldata seulement dans la déclaration
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public 
    {
      transferFrom(from, to, tokenId);
      uint32 size;
      assembly 
      {
        size := extcodesize(to)
      }
      if(size > 0)
      {
        IERC721TokenReceiver receiver = IERC721TokenReceiver(to);
        require(receiver.onERC721Received(msg.sender,from,tokenId,data) == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),"ERC721: transfer to non ERC721Receiver implementer");
      }
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public
    {
      safeTransferFrom(from, to, tokenId, "");
    }
    
    /*
    cette fonction est payable afin de mttre la guarantie de mutabilité au minimum, 
      si l'utilisateur veut être plus restrictif il peut l'enlever. C'est pour ça que
      l'implémentation de OpenZeppelin l'enlève.
    */
    function transferFrom(address from, address to, uint256 tokenId) public
    {
      address owner = ownerOf(tokenId);
      bool requirement = owner == msg.sender || isApprovedForAll(to, msg.sender)
        || allowance[tokenId] == msg.sender;
      require (requirement);
      require (owner == from);
      require(to != address(0), "ERC721: to must not be address 0x!");
      //déjà testé dans ownerOf
      //require(isValidToken(tokenId), "ERC721: tokenId not valid!");
      owners[tokenId] = to;
      balances[to] = balances[to].add(1);
      balances[owner] = balances[owner].sub(1);
      if(allowance[tokenId] != address(0))
      {
        allowance[tokenId] = to;
        emit Approval(owner, to, tokenId);
      }
      emit Transfer(from, to, tokenId);
    }

    function approve(address approved, uint256 tokenId) external payable
    {
      address owner = ownerOf(tokenId);
      require(owner == msg.sender || isApprovedForAll(owner,msg.sender));
      allowance[tokenId] = approved;
      emit Approval(owner, approved, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external
    {
      authorised[msg.sender][operator] = approved;
      emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId) external view returns (address)
    {
      require(isValidToken(tokenId), "ERC721: tokenId not valid!");
      return allowance[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool)
    {
      return authorised[owner][operator];
    }

    function concatenate(string memory a,string memory b) public pure returns (string memory)
    {
        return string(bytes.concat(bytes(a), " ", bytes(b)));
    }

    function addressToString(address _addr) public pure returns(string memory)
    {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(51);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < 20; i++) 
        {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function issueTokens(uint256 extraTokens) public
    { 
      // Make sure only the contract creator can call this
      string memory msgSenderAddressMessage = concatenate(" msgSender = ", addressToString(msg.sender));
      string memory creatorAddressMessage = concatenate(" creator = ", addressToString(creator));
      string memory errorMessage = concatenate("ERC721: creator must be msg.sender!", concatenate(msgSenderAddressMessage, creatorAddressMessage));
     
      //require(msg.sender == creator, errorMessage);
      balances[msg.sender] = balances[msg.sender].add(extraTokens);

      //We have to emit an event for each token that gets created
      for(uint i = maxId.add(1); i <= maxId.add(extraTokens); i++)
      {
        emit Transfer(address(0), creator, i);
      }
      maxId.add(extraTokens);
      //maxId += extraTokens;
       //<- SafeMath for this operation 
    // was done in for loop above
    }

    function burnToken(uint256 tokenId) external
    {
      address owner = ownerOf(tokenId);
      bool requirement = owner == msg.sender || allowance[tokenId] == msg.sender 
          || authorised[owner][msg.sender];
        require (requirement);
        burned[tokenId] = true;
        balances[owner].sub(1);    
        emit Transfer(owner, address(0), tokenId);
    }
}