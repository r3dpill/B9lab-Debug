//Debug Exercise 1
PiggyBank
In this contract, value that is sent by the owner is being stored only if it is sent by the owner. It is returned in full when the contract is destroyed after the owner, and only the owner, sends the password to the kill function.

compiler version missing ^
Why use uint248 for balance and not uint (msg.value is type uint)
Constructor function typo named as piggyBank rather than PiggyBank
Constructor function is not payable
Specify visibility of functions
Rather than relying on the fallback function why not have a 'AddFunds' function?
Consider using a modifier function to ensure only the owner can add funds
Use require() in place of revert() to check owner is calling fallback function
Use require() in place of revert() to check owner used valid password for kill function
It would be safer to only allow the owner to call the kill function in case the pwd is compromised


//Debug Exercise 2
Store
In this contract, a shop system processes a payment, sends the payment to a wallet contract and then instructs the warehouse to ship the purchase. What could go wrong?

Functions in Interface should be declared as External
Interface produces error under ^0.4.5 compiler - changed to ^0.4.24
Use Constructor function to reduce risk of incorrect function name
Specify visibility of constructor as public
No check to see whether supplied contract address for WarehouseI is valid
Specify visibility of purchase function to public
purchase function should be payable
purchase function does not check to see if transfer of funds to wallet was a success before shipping
added require() to wallet.send with error message on failure
no call to setDeliveryAddress to confirm where goods should be sent
added event to log what has been shipped


//Debug Exercise 3
Splitter
In this contract, every value sent is supposed to be equally split between account one, account two and the contract itself. Beside finding out problems with it, how could an attacker game this contract and what would be the end result?

Updated compiler version to be ^0.4.24
Amended name of constructor function
Set visibility of functions to be public
Made constructor payable to prevent calls with any value being passed to fallback function
use require() in place of revert() as more readable
add check that an address for two has been supplied
consider adding a specific 'splitFunds' function rather than relying on the fallback function
the fallback function is vulnerable to a reentrance attack; to remove this risk add some defensive accounting which tracks the available funds using a variable which is reduced before any payout is made
there is no mechanism for removing the 1/3 of funds retained at the end of each split - add a kill function to terminate the contract and distribute these funds using selfdestruct()
added event LogPayout to track what gets paid to whom