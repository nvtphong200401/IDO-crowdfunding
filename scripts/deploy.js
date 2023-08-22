const hre = require("hardhat");
const helpers = require("@nomicfoundation/hardhat-network-helpers");

async function deployContracts() {
  const [projectOwner] = await ethers.getSigners();

  // We get the contract to deploy
  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy();

  await crowdfunding.deployed();

  console.log("Crowdfunding deployed to:", crowdfunding.address);

  // Deploy Project Token
  const GumToken = await ethers.getContractFactory("GumToken");
  const gumtoken = await GumToken.deploy();

  await gumtoken.deployed();

  console.log("GumToken Contract Address is", gumtoken.address);

 
   return { gumtoken, crowdfunding, projectOwner,};
}

async function main() {
  const { gumtoken, crowdfunding, projectOwner } = await helpers.loadFixture(deployContracts);
  //fund contract
  maxCap = 9 * (10 ** 10);
  const TransferTokens = await (gumtoken.connect(projectOwner).mint(crowdfunding.address, maxCap))
  TransferTokens.wait()
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
