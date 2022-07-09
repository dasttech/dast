require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
const fs = require('fs');
const mnemonic = fs.readFileSync('.secret').toString().trim();
if (!mnemonic || mnemonic.split(' ').length !== 12) {
  console.log('unable to retrieve mnemonic from .secret');
  return;
}

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});


// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.6",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
      details:{
        yul:true
      }
    }
  },
  networks: {
     ropsten: {
      chainId: 3,
      url: 'https://ropsten.infura.io/v3/01cee0da686f45b284603965699bac60',
      accounts: {
        mnemonic: mnemonic,
        initialIndex: 0,
        path: "m/44'/60'/0'/0",
        count: 10,
        gasPrice:2000000000
      },
    },
    bsctestnet: {
      chainId: 97,
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      accounts: {
        mnemonic: mnemonic,
        initialIndex: 0,
        path: "m/44'/60'/0'/0",
        count: 10,
        gasPrice:2000000000
      },
    },
    bscmainet: {
      chainId: 56,
      url: 'https://bsc-dataseed.binance.org/',
      accounts: {
        mnemonic: mnemonic,
        initialIndex: 0,
        path: "m/44'/60'/0'/0",
        count: 10,
      },
    },
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: {
        mnemonic: "unhappy cherry quote garlic design soccer vivid fresh glimpse frame grant vibrant",
        initialIndex: 0,
        path: "m/44'/60'/0'/0",
        count: 10,
        gasPrice:2000000000
      },
  }
  },
};
