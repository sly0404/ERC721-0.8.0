pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NFTToken.sol";

contract TestERC721
{
    bytes4 private constant _INTERFACE_ID_IERC165 = 0x01ffc9a7;
    uint256 public constant TOKENS_TOTAL_QUANTITY = 10;
    uint256 public constant TOKENS_TOTAL_QUANTITY_2 = 11;
    
    //string private testMessage = string(abi.encodePacked("accounts[0] must have ",balanceReceiver," GWEIS."));
    //DeployedAddresses.NFTToken() == 0x345ca3e014aaf5dca488057592ee47305d9b3e10
    NFTToken private nftToken = NFTToken(DeployedAddresses.NFTToken());
    string private errorTestGetSupportsInterfaceSelectorMessage = "wrong interface selector!";
    string private errorTestSupportsInterfaceMessage = "interface not supported!";
    string private errorTestTokensTotalQuantityMessage = "wrong quantity!";
    string private errorTestGetMsgSenderMessage = "wrong msg sender!"; 
    string private errorTestGetCreatorMessage = "wrong creator!";
    string private errorTestOwnerOf = "wrong owner!";
    address private constant ACCOUNT = 0x25075f2Adf4A1dFed4DffeFb9747112cA5C168d3;
    address private constant MSG_SENDER = 0x4E72770760c011647D4873f60A3CF6cDeA896CD8;// 0x4e72770760c011647d4873f60a3cf6cdea896cd8;
    address private constant CREATOR = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57; //0x627306090abab3a6e1400e9345bc60c78a8bef57;
    function testGetSupportsInterfaceSelector() public
    {
        Assert.equal(nftToken.getSupportsInterfaceSelector(), _INTERFACE_ID_IERC165, errorTestGetSupportsInterfaceSelectorMessage);
    }

    function testSupportsInterface() public
    {
        Assert.isTrue(nftToken.supportsInterface(_INTERFACE_ID_IERC165), errorTestSupportsInterfaceMessage);
    }

    function testTokensTotalQuantity() public
    {
        Assert.equal(nftToken.balanceOf(msg.sender), TOKENS_TOTAL_QUANTITY, errorTestTokensTotalQuantityMessage);
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

    function testGetMsgSender() public
    {
        string memory msgSender = addressToString(nftToken.getMsgSender());
        string memory errorMessage = concatenate(errorTestGetMsgSenderMessage, msgSender);
        Assert.equal(nftToken.getMsgSender(), MSG_SENDER,  errorMessage);
    }

    function testGetCreator() public
    {
        string memory msgCreator = addressToString(nftToken.getCreator());
        string memory errorMessage = concatenate(errorTestGetCreatorMessage, msgCreator);
        Assert.equal(nftToken.getCreator(), CREATOR, errorMessage);
    }

    /*
    function testIssueTokens() public
    {

        uint256 extraTokens = 2;
        nftToken.issueTokens(extraTokens);
        Assert.equal(nftToken.balanceOf(nftToken.getMsgSender()), TOKENS_TOTAL_QUANTITY_2, errorTestTokensTotalQuantity);

        Avec cet exemple là, lors de l'initialisation du constructeur, on a bien TOKENS_TOTAL_QUANTITY tokens
        qui ont été crées pour creator == 0x627306090abab3a6e1400e9345bc60c78a8bef57 mais pas pour nftToken.getMsgSender() == 0x4E72770760c011647D4873f60A3CF6cDeA896CD8.
        Du coup, lorsque le code rentre dans la fonction issueTokens, on a 
        balances[msg.sender] = balances[msg.sender].add(extraTokens); 
        Comme balances[msg.sender] pour msg.sender == 0x4E72770760c011647D4873f60A3CF6cDeA896CD8 est 
        inialement à 0, on a bien balances[msg.sender] qui a été incrémenté de 2 et on a donc bien
        nftToken.balanceOf(nftToken.getMsgSender()) == 2.
        
        

        
        uint256 extraTokens = 2;
        nftToken.issueTokens(extraTokens);
        if faut commenter la ligne require(msg.sender == creator, errorMessage); dans la fonction issueTokens
        du contract ERC721Token sinon, depuis ce test, l'égalité n'est pas vérifiée et une erreur est envoyée.
        
        Assert.equal(nftToken.balanceOf(nftToken.getCreator()), TOKENS_TOTAL_QUANTITY_2, errorTestTokensTotalQuantityMessage);
    }
    */

    function testOwnerOf() public
    {
        uint256 tokenId = 3;
        address owner = nftToken.ownerOf(tokenId);
        string memory msgOwnerOf = addressToString(owner);
        string memory errorMessage = concatenate(errorTestOwnerOf, msgOwnerOf);
        Assert.equal(owner, CREATOR, errorMessage);
    }

    function testTransferFrom() public
    {
        
    }
}