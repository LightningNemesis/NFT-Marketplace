// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe("MyNFT", function () {
//   let MyNFT;
//   let myNFT;
//   let owner;
//   let recipient;

//   beforeEach(async function () {
//     [owner, recipient] = await ethers.getSigners();
//     MyNFT = await ethers.getContractFactory("MyNFT");
//     myNFT = await MyNFT.deploy();
//     // No need for myNFT.deployed() in newer versions of Hardhat
//   });

//   it("should mint and transfer NFT", async function () {
//     // Mint NFT
//     await myNFT.mint(owner.address, "https://example.com/token/1");
//     expect(await myNFT.ownerOf(1)).to.equal(owner.address);

//     // Transfer NFT
//     await myNFT.transferFrom(owner.address, recipient.address, 1);
//     expect(await myNFT.ownerOf(1)).to.equal(recipient.address);
//   });
// });

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyNFT", function () {
  let MyNFT;
  let myNFT;
  let owner;
  let recipient;

  beforeEach(async function () {
    [owner, recipient] = await ethers.getSigners();
    MyNFT = await ethers.getContractFactory("MyNFT");
    myNFT = await MyNFT.deploy();

    // Log the contract address
    console.log("Contract deployed to:", await myNFT.getAddress());
  });

  it("should mint and transfer NFT", async function () {
    // Mint NFT
    await myNFT.mint(owner.address, "https://example.com/token/1");
    expect(await myNFT.ownerOf(1)).to.equal(owner.address);

    // Transfer NFT
    await myNFT.transferFrom(owner.address, recipient.address, 1);
    expect(await myNFT.ownerOf(1)).to.equal(recipient.address);
  });
});
