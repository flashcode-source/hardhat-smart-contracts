require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config()

module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: process.env.URI_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
