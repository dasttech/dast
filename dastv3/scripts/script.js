  // We require the Hardhat Runtime Environment explicitly here. This is optional
  // but useful for running the script in a standalone fashion through `node <script>`.
  //
  // When running the script with `npx hardhat run <script>` you'll find the Hardhat
  // Runtime Environment's members available in the global scope.
  const hre = require("hardhat");
  const fs = require('fs');
  const platform_token = fs.readFileSync(".password").toString().trim();

  async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  await hre.run('compile');
  
  // GLOBAL VARIABLES
   
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
  const auth = await Auth.deploy(platform_token);

  await auth.deployed();

    
    // Deploy Users
    const UserLib = await hre.ethers.getContractFactory("UserLib",{
      libraries: {
        Utils:utils.address
      }
    });
    const userLib = await UserLib.deploy();
    await userLib.deployed();

  const Users = await hre.ethers.getContractFactory("Users",{
    libraries: {
      Utils:utils.address,
      UserLib:userLib.address
    }
  });

  const users = await Users.deploy(auth.address);

  await users.deployed();

  //Deploy Assets
  const Assets = await hre.ethers.getContractFactory("Assets");

  const assets = await Assets.deploy(auth.address);

  await assets.deployed();


  // Deploy Users
  const RecoveryLib = await hre.ethers.getContractFactory("RecoveryLib");
  const recoveryLib = await UserLib.deploy();
  await recoveryLib.deployed();

  //Deploy Recover
  const Recovery = await hre.ethers.getContractFactory("Recovery",{
    libraries:{
      Utils: utils.address
    }
  });
  const recovery = await Recovery.deploy(auth.address,users.address);
  await recovery.deployed();


  //SOME CONTRACT MODIFICATIONS

  try{

    let AuthContr = await hre.ethers.getContractAt("Auth",auth.address);
    await AuthContr.setUser(platform_token,users.address);

  }catch(err){
    console.log(err);
  }

  const today = new Date();
  fs.appendFileSync('contractAddresses.txt', `Auth: ${today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()+" " +today.getHours()+":"+today.getMinutes()} Auth deployed to:${auth.address+"'"}\n`, 
  (err)=> {
    if (err) throw err;
  });
  
    console.log("Auth deployed to:", auth.address);
    
  fs.appendFileSync('contractAddresses.txt', `Users: ${today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()+" " +today.getHours()+":"+today.getMinutes()} Users deployed to:${users.address+"'"}\n`, 
  (err)=> {
    if (err) throw err;
  });
 
    console.log("Users deployed to:", users.address);

    fs.appendFileSync('contractAddresses.txt', `Assets: ${today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()+" " +today.getHours()+":"+today.getMinutes()} Assets deployed to:${assets.address+"'"}\n`, 
    (err)=> {
      if (err) throw err;
    });
   
      console.log("Assets deployed to:", assets.address);

      fs.appendFileSync('contractAddresses.txt', `Recovery: ${today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()+" " +today.getHours()+":"+today.getMinutes()} Recovery deployed to:${recovery.address+"'"}\n\n`, 
      (err)=> {
        if (err) throw err;
      });
     
        console.log("Recovery deployed to:", recovery.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
