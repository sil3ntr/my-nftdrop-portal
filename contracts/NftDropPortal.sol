// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract NftDropPortal {
    uint256 totalDrops;

    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;
    /*
     * A little magic, Google what events are in Solidity!
     */
    event NewDrop(address indexed from, uint256 timestamp, string message);

     /*
     * I created a struct here named Drop.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Drop {
        address dropper; // The address of the user who drops.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user dropped.
    }

    /*
     * I declare a variable Drop that lets me store an array of structs.
     * This is what lets me hold all the drops anyone ever sends to me!
     */
    Drop[] drops;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastDropedAt;

    constructor() payable {
            console.log("This contract has been funded with real fake moneyz!");

         /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function drop(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastDropedAt[msg.sender] + 2 minutes < block.timestamp,
            "Wait 2m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastDropedAt[msg.sender] = block.timestamp;
        totalDrops += 1;
        console.log("%s has dropped this %s", msg.sender, _message);

         /*
         * This is where I actually store the drop data in the array.
         */
        drops.push(Drop(msg.sender, _message, block.timestamp));

         /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Sigh, I'am broke and you are trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        /*
         * I added some fanciness here, Google it and try to figure out what it is!
         * Let me know what you learn in #general-chill-chat
         */
        emit NewDrop(msg.sender, block.timestamp, _message);
    }
      /*
     * I added a function getAllDrops which will return the struct array, drops, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllDrops() public view returns (Drop[] memory) {
        return drops;
    }

    function getTotalDrops() public view returns (uint256) {
        console.log("Wow.. we have %d drops fren!", totalDrops);
        return totalDrops; 
    }

}