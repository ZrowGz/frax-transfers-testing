# Testing FraxFarm Transfers

## What is this?
Upgrades the Frax Finance staking contract, the *Frax Farms* to provide the ability to transfer staked positions that are locked up for a duration, without unlocking them. This doesn't allow for transfer between assets or help with migration from one gauge to another, but it does allow for changing ownership of those locked assets.

The Convex Finance vault changes include exposing the new logic in the FraxFarm, as well as ensuring that a receiving address is capable of handling the assets (ensure that it is another Convex Vault).

The methodology is a mashup between ERC20 & ERC721 standards to create a semi-fungible asset transfer (underlying fungible tokens, held in a non-fungible manner).

## Usage

### Clone repository
### Install Foundry and/or update to the most recent version.
'''
https://book.getfoundry.sh/getting-started/installation
'''
### Install dependencies
```
forge install
```

### Run Tests
```
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/<INSERT_YOUR_ALCHEMY_KEY> -vvvv
```

## License
MIT