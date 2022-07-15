// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fs = require('fs');

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  await hre.run('compile');
   
  // Deploying Libraries
  
  const Utils = await hre.ethers.getContractFactory("Utils");
  const utils = await Utils.deploy();
  await utils.deployed();

  const Structs = await hre.ethers.getContractFactory("Structs");
  const structs = await Structs.deploy();
  await structs.deployed();

  const Hash = await hre.ethers.getContractFactory("Hashing",{
    libraries:{
      Utils:utils.address
    }
  });
  const hash = await Hash.deploy();
  await hash.deployed();

  

  // Deploying Auth
  const Auth = await hre.ethers.getContractFactory("Auth",
  {
    libraries: {
      Hashing: hash.address,
      Utils:utils.address
    },
  });
  const auth = await Auth.deploy("1234567890");

  await auth.deployed();
   
    // Deploy Users
const Users = await hre.ethers.getContractFactory("Users");

const users = await Users.deploy(auth.address);

  await users.deployed();

  const today = new Date();
  fs.appendFileSync('contractAddresses.txt', `Auth: ${today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()+" " +today.getHours()+":"+today.getMinutes()} Auth deployed to:${auth.address+"'"}\n`, 
  (err)=> {
    if (err) throw err;
  });
  
    console.log("Auth deployed to:", auth.address);
    
  fs.appendFileSync('contractAddresses.txt', `Users: ${today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()+" " +today.getHours()+":"+today.getMinutes()} Users deployed to:${users.address+"'"}\n\n`, 
  (err)=> {
    if (err) throw err;
  });
 
    console.log("Users deployed to:", users.address);
}



// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
