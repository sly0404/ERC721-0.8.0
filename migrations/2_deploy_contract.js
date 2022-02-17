const NFTToken = artifacts.require("NFTToken");

const web3 = require("web3-utils");

module.exports = (deployer, network, [owner]) =>
{
  return deployer.then(() => deployer.deploy(NFTToken))
                  .then(() => NFTToken.deployed())

};
