const hre = require("hardhat");

async function main() {
  // Deploy Project Token
  const GumToken = await ethers.getContractFactory("GumToken");
  const gum = await GumToken.deploy();

  await gum.deployed();

  console.log("GumToken Contract Address is", gum.address);

  // We get the contract to deploy
  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy();

  await crowdfunding.deployed();

  console.log("Crowdfunding deployed to:", crowdfunding.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
