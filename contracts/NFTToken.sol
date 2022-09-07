pragma solidity ^0.8.0;

import "./ERC721Token.sol";

contract NFTToken is ERC721Token
{
    string public constant TOKEN_NAME = "VToken";
    string public constant TOKEN_SYMBOL = "VTKN";
    uint256 public constant TOTAL_TOKENS = 10;

    constructor ()
    ERC721Token(TOTAL_TOKENS) public
    {
      
    }
}