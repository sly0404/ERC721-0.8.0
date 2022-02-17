//migrate --reset

token = await NFTToken.deployed()

token.getBalanceOfSelector()
token.getSupportsInterfaceSelector()
token.getSelectorKeccak()
token.getSelectorKeccak2()
token.supportsInterface('0x01ffc9a7')
token.supportsInterface("0x01ffc9a7")
token.supportsInterface('0x70a08231')

token.getIERC721Selector()
token.isValidToken(0)
token.isValidToken(65000)
token.isValidToken(70009)

token.balanceOf("0x25075f2Adf4A1dFed4DffeFb9747112cA5C168d3")
token.issueTokens(3)