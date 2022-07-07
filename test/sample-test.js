const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {

const  AdminAdd= "0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42"

let AC;
let accessControl
let   owner, addr1, addr2, addr3, addrs

  beforeEach(async()=>{
      AC = await ethers.getContractFactory("AccessControl");
      accessControl = await AC.deploy("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");
    await accessControl.deployed();

    ;[owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners()
    // console.log("owner Address:::::",owner.address)
  })

  it("Should return the ADMIN_ADDRESS", async function () {

    const ADMIN_ADDRESS =  await accessControl.ADMIN()
    expect(ADMIN_ADDRESS).to.equal(AdminAdd)
 
  });

 

  it("Should return True if hasRole Assigned", async function () {

    let expectedResult=true
    const hasRole =  await accessControl.hasRole(AdminAdd,"0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")
    expect(hasRole).to.equal(expectedResult)

  });


  it("Should be Reverted As  Addr1  is not assigned Role, async function ", async function () {

 
    
    await expect(accessControl.connect(addr1).grantRole(AdminAdd,"0x70997970c51812dc3a010c7d01b50e0d17dc79c8" )).to.be.revertedWith("AccessControl: account 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 is missing role 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42")
    console.log("---------REVERTED-----------")
 
     
  });


  it("Return True If GrantRole Function is working ", async function () {

 
    const expectedval= await accessControl.grantRole(AdminAdd,"0x70997970c51812dc3a010c7d01b50e0d17dc79c8" )

     expect(await accessControl.hasRole(AdminAdd,"0x70997970c51812dc3a010c7d01b50e0d17dc79c8") ).to.equal(true)
     
 
     
  });

  it("Return False as we are calling the function from another adress instead of ROLE address ", async function () {

 
    // const expectedval= await accessControl.connect(addr1).renounceRole(AdminAdd,"0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" )

    await expect(accessControl.connect(addr1).renounceRole(AdminAdd,"0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).to.be.revertedWith("AccessControl: can only renounce roles for self");
     
 // for reverting we use expect outsid eotherwise test fail : revert message should be same as in contract
     
  });
  it.only("Has value to be false as we are removing it from the mapping ", async function () {

 
    // const expectedval= await accessControl.connect(addr1).renounceRole(AdminAdd,"0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" )

    const result=  expect(await accessControl.renounceRole(AdminAdd,"0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"))
     
     expect(await accessControl.hasRole(AdminAdd,"0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).to.equal(false);// 
 
     
  });


});
