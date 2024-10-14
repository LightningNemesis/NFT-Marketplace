async function main() {
  const [creator, receiver] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", creator.address);
  console.log("Receiver account:", receiver.address);

  const MyNFT = await ethers.getContractFactory("MyNFTMarketplace");
  const myNFT = await MyNFT.deploy();

  // The contract is already deployed at this point, no need for myNFT.deployed()
  console.log("MyNFTMarketplace deployed to:", await myNFT.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
