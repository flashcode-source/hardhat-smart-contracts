
const { ethers } = require("hardhat")

const { NFT_WHITELIST_CONTRACT, BASEURI } = require("../constants")

async function main() {
  const cryptoDevs = await ethers.getContractFactory('CryptoDevs')
  const cryptoDevsDeploy = await cryptoDevs.deploy(BASEURI, NFT_WHITELIST_CONTRACT)
  await cryptoDevsDeploy.deployed();
  console.log("The CryptoDevs Contract address is:", cryptoDevsDeploy.address)

}

main().then(() => process.exit(0))
.catch((err) => {
  console.log(err);
  process.exit(1);
})