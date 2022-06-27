const { expect } = require("chai");
const { ethers } = require("hardhat");
let assetStoreAddress;


describe("AssetStore", async function () {

  it("should deployed AssetStore", async () => {
    // const [owner, addr1, addr2] = await ethers.getSigners();

    const AssetStore = await ethers.getContractFactory("AssetStore");
    const assetstore = await AssetStore.deploy();
    const assetStore = await assetstore.deployed();
    assetStoreAddress = assetStore.address;
    console.log(assetStoreAddress);
  });



  // it("Should return the new greeting once it's changed", async function () {
  //   const Greeter = await ethers.getContractFactory("Greeter");
  //   const greeter = await Greeter.deploy("Hello, world!");
  //   await greeter.deployed();

  //   expect(await greeter.greet()).to.equal("Hello, world!");

  //   const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

  //   // wait until the transaction is mined
  //   await setGreetingTx.wait();

  //   expect(await greeter.greet()).to.equal("Hola, mundo!");
  // });
});
