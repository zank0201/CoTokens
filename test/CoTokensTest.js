// import contract artifact
const CoToken = artifacts.require("./CoToken.sol")
// const zombieNames = ["Zombie1", "Zombie2"]
const truffleAssert = require("truffle-assertions")

//testing start
contract("CoToken", function (accounts) {
    // predefine contract instance
    let CoTokenInstance

    //before each test create new contranct instance
    beforeEach(async function () {
        CoTokenInstance = await CoToken.new()

    })

    //test that mint function mints token to 
    it("should mint number of tokens to address of caller", async function() {

        // call mint function to let transaction take place
        let mint = await CoTokenInstance.mint(accounts[1], 20, {'from': accounts[1], 'value': 0.4 * 1e18})
        // check balance of account 0
        let balance = await CoTokenInstance.balances(accounts[1])
        assert.equal(balance.toNumber(), 20, "Mint not succesful")
    })

    it("should burn number of tokens from address", async function() {
        //first need to mint to certain account then remove
        await CoTokenInstance.mint(accounts[1], 20, {'value': 0.4 * 1e18})
        await CoTokenInstance.burn(accounts[1], 20)
        let balance1 = await CoTokenInstance.balances(accounts[1])
        //console.log(burn.receipt.logs)
        assert.equal(balance1.toNumber(), 0, "Burn not succesful")
    })

    it("should destroy the contract once tokens are in owners hands", async function() {
        //await CoTokenInstance.mint(accounts[0], 20, {'value': 0.4 * 1e18})

        await CoTokenInstance.destroy()
        
        let total = await CoTokenInstance.balances(accounts[0])

        // test will fail since we've minted tokens
        assert.equal(total.toNumber(), 100, "Total supply is not in owners account")



        
    })


    })



