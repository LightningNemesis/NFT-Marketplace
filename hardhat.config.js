require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.27",
  networks: {
    skopje: {
      url: "https://skopje-rpc.gptprotocol.io",
      // url: process.env.NETWORK_URL,
      chainId: 476462898,
      accounts: [
        process.env.CREATOR_PRIVATE_KEY,
        process.env.RECEIVER_PRIVATE_KEY,
      ],
    },
  },
};
