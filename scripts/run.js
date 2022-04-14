const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory("NftDropPortal");
    const waveContract = await waveContractFactory.deploy({
      value: hre.ethers.utils.parseEther("0.01"),
    });
    await waveContract.deployed();
    console.log("Contract addy:", waveContract.address);

     /*
   * Get Contract balance
   */
    let contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

  
    let dropCount;
    dropCount = await waveContract.getTotalDrops();
    console.log(dropCount.toNumber());
  
    /**
     * Let's send a few Drops!
     */
    let dropTxn = await waveContract.drop("Oh snap, check out this mad jpeg https://ipfs.io/ipfs/QmQwidAc3AFX4xtVT6wrYrzcpYqsxurZhFTEdEj7Lod4pD ");
    await dropTxn.wait(); // Wait for the transaction to be mined
  
    const [_, randomPerson] = await hre.ethers.getSigners();
    dropTxn = await waveContract.connect(randomPerson).drop("No drop, just wanted to say hi !");
    await dropTxn.wait(); // Wait for the transaction to be mined

    /*
   * Get Contract balance to see what happened!
   */
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

  
    let allDrops = await waveContract.getAllDrops();
    console.log(allDrops);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();