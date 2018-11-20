This file and amended .sol files for each exercise uploaded here:
https://github.com/r3dpill/B9lab-Debug

Debug Exercise 1
PiggyBank
In this contract, value that is sent by the owner is being stored only if it is sent by the owner. It is returned in full when the contract is destroyed after the owner, and only the owner, sends the password to the kill function.

1. Compiler version missing the initial line 'pragma solidity ^0.4.24' (as an example version number). This specifies the minimum version of the compiler to be used which will have an impact on what is/ not flagged as an error and allow the code to benefit from enhancements in the solc compiler over time.
2. Why use uint248 for balance and not uint (msg.value is type uint)?
3. Constructor function typo named as piggyBank rather than PiggyBank. This is extremely dangerous as anyone can now call the piggyBank function which was intended only for the contract owner. As of Solidity v0.4.22 the constructor function is explicitly named as constructor().
4. The constructor() function is intended to receive funds but does not include the keyword 'payable'. From compiler v0.4 onwards calls to the function which try to send ether will fail.
5. Functions do not have visibility specifiers. These can be public, external, internal, or private. As well as setting from where a function may be called, the choice of visibility may also change gas usage (for example when handling arrays, external will use less gas than public).
6. There is no check to ensure the addition of funds does not cause balance to wrap-around
e.g. 'assert(balance + msg.value >= balance);'.
7. Rather than relying on the fallback function why not have a 'AddFunds' function? It is best practice to explicitly code all required functions and leave the fallback function empty where possible.
8. Consider using a modifier function to ensure only the owner can add funds. A modifier is cleaner and can be reused in other functions - ultimately it could be contained in a separate contract e.g 'Owned.sol' which would allow use in many other contracts via Inheritance.
9. Use require() in place of revert() to check owner is calling fallback function. In general require() should be used to check conditions, typically towards the start of a function. It may also be helpful to include a comment which is passed back on failure of the require statement e.g. require(owner = msg.sender, 'function caller not the owner').
10. Use require() in place of revert() to check owner used valid password for kill function.
11. Used abi.encoded(owner,  password) to pass to keccak256 function since variable-argument versions of keccak256 have been deprecated.
12. It would be safer to only allow the owner to call the kill function in case the pwd is compromised. The modifier 'isOwner()' discussed in item(8) could also be used for this purpose.


Debug Exercise 2
Store
In this contract, a shop system processes a payment, sends the payment to a wallet contract and then instructs the warehouse to ship the purchase. What could go wrong?

1. Functions in the Interface contract should be declared as External.
2. Interface produces error under ^0.4.5 compiler - changed to ^0.4.24.
3. Use Constructor function to reduce risk of incorrect function name (case sensitive). This is required as of ^0.4.22 in any case.
4. Specify visibility of constructor as public.
5. No check to see whether supplied contract address for WarehouseI is valid - see more details here:
https://github.com/ethereum/EIPs/issues/165.
6. Functions do not have visibility specifiers. These can be public, external, internal, or private. As well as setting from where a function may be called, the choice of visibility may also change gas usage (for example when handling arrays, external will use less gas than public).
7. The purchase() function is intended to receive funds but does not include the keyword 'payable'. From compiler v0.4 onwards calls which send ether to a function which is not 'payable' will fail.
8. Use wallet.transfer in place of .send as this will throw an error on failure.
9. I added a call to the WarehouseI 'setDeliveryAddress' function in the main contract's purchase() function in order to confirm where the goods should be sent; additional variable (string where) also passed to purchase().
10. Added an event to log what has been shipped, where to and the wallet address of the customer.


Debug Exercise 3
Splitter
In this contract, every value sent is supposed to be equally split between account one, account two and the contract itself. Beside finding out problems with it, how could an attacker game this contract and what would be the end result?

1. Updated compiler version to be ^0.4.24. This specifies the minimum version of the compiler to be used which in turn dictates which updates/ enhancements to solidity language are included and what is flagged as an error.
2. Amended name of constructor function to be constructor(). This removes the risk of a typo in the constructor function name and is a requirement from solc v0.4.22 onwards.
3. Set visibility of functions to be public. All functions should have visibility specifiers (althought he defualt is 'public') and care should be taken to select the right one for security and gas utilisation reasons.
4. The constructor() function is intended to receive funds but does not include the keyword 'payable'. From compiler v0.4 onwards calls to the function which try to send ether will fail.
5. Use require() in place of revert() to check that a non-zero amount of ETH has been sent. In general require() should be used to check conditions, typically towards the start of a function. It may also be helpful to include a comment which is passed back on failure of the require statement.
6. I also added an additional require() statement to check that an address for two has been supplied as input to the Splitter function.
7. Consider adding a specific 'splitFunds' function rather than relying on the fallback function - in general it is best practice to code for specific behaviour as opposed to relying on default 'catch-all' code in a fallback function.
8. The fallback function is vulnerable to a reentrance attack. An attacker could make a second (and subsequent) call to the fallback function before the first payment was reflected accurately in address(this).balance; to remove this risk it is important to add some 'defensive accounting' which tracks the available funds using a variable which is reduced BEFORE any payout is made.
9. Use .transfer in place of .call.value since .transfer will throw an error on failure and is limited to 2300 gas making reentrance attacks less of an issue.
10. There is no mechanism for removing the 1/3 of funds retained at the end of each split - add a kill function to terminate the contract and distribute these funds using selfdestruct()
11. Added event LogPayout to track what gets paid to whom.
