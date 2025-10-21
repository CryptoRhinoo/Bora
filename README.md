# 🚀 BORA - Web3 Talent Marketplace

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-blue)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg)](https://getfoundry.sh/)

BORA is a decentralized talent marketplace connecting Web3 developers with opportunities through a Tinder-like swipe interface. Built with Solidity and deployed on EVM-compatible chains.

## ✨ Features

- 👨‍💻 **Developer Profiles**: Create and manage professional profiles with skills and reputation
- 💼 **Job Opportunities**: Post and browse Web3 job opportunities
- 👍 **Swipe Matching**: Tinder-style interface for matching developers with opportunities
- 🤝 **Smart Matching**: Automated matching system when both parties show interest
- 💰 **Escrow System**: Secure payment system with platform fees
- ⭐ **Reputation System**: Track developer performance and completed jobs
- 🔒 **Pausable**: Admin controls for emergency situations

## 🏗️ Architecture

### Core Components

- **Developer Profiles**: Store developer information, skills, and reputation
- **Opportunities**: Job postings with budgets and required skills
- **Swipe System**: Like/dislike mechanism for matching
- **Match System**: Manage active matches and job completion
- **Escrow**: Secure payment handling with platform fees (2.5% default)

### Smart Contract Structure
```
Bora.sol
├── Developer Management
│   ├── createDeveloperProfile()
│   ├── updateDeveloperProfile()
│   └── deactivateDeveloperProfile()
├── Opportunity Management
│   ├── createOpportunity()
│   ├── depositEscrow()
│   └── closeOpportunity()
├── Matching System
│   ├── swipeOpportunity()
│   ├── acceptMatch()
│   └── completeJob()
└── Admin Functions
    ├── setPlatformFee()
    ├── togglePause()
    └── withdrawPlatformFees()
```

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/downloads)

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/bora.git
cd bora

# Install dependencies
forge install

# Build the project
forge build
```

### Running Tests
```bash
# Run all tests
forge test

# Run tests with verbosity
forge test -vvv

# Run specific test
forge test --match-test test_CreateDeveloperProfile -vvv

# Generate gas report
forge test --gas-report

# Generate coverage report
forge coverage
```

## 📝 Usage Examples

### For Developers
```solidity
// 1. Create developer profile
string[] memory skills = ["Solidity", "React", "Web3.js"];
bora.createDeveloperProfile(
    "Alice",
    skills,
    "Experienced blockchain developer"
);

// 2. Browse and swipe opportunities
bora.swipeOpportunity(opportunityId, true); // Like
```

### For Opportunity Creators
```solidity
// 1. Create opportunity
string[] memory requiredSkills = ["Solidity", "Security"];
bora.createOpportunity(
    "Smart Contract Audit",
    "Need experienced auditor",
    requiredSkills,
    1 ether
);

// 2. Deposit escrow
bora.depositEscrow{value: 1 ether}(opportunityId);

// 3. Accept match when developer swipes
bora.acceptMatch(opportunityId, developerAddress);

// 4. Complete job and release payment
bora.completeJob(matchId, 50); // +50 reputation points
```

## 🔧 Deployment

### Deploy to Sepolia Testnet
```bash
# Create .env file
cp .env.example .env
# Edit .env with your keys

# Source environment variables
source .env

# Deploy
forge script script/Bora.s.sol:DeployBora \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    -vvvv
```

### Deploy to Base Sepolia
```bash
forge script script/Bora.s.sol:DeployBora \
    --rpc-url $BASE_SEPOLIA_RPC_URL \
    --broadcast \
    --verify \
    --etherscan-api-key $BASESCAN_API_KEY \
    -vvvv
```

## 🧪 Test Coverage
```bash
forge coverage --report summary
```

Current coverage: ~85%

## 📊 Gas Optimization

The contract implements several gas optimization techniques:
- Efficient struct packing
- Minimal storage operations
- Event-driven architecture
- Batch operations where possible

## 🔐 Security Features

- ✅ Reentrancy guards on critical functions
- ✅ Access control modifiers
- ✅ Pausable functionality
- ✅ Input validation
- ✅ Safe math (Solidity 0.8.24+)
- ✅ Checks-Effects-Interactions pattern

## 🗺️ Roadmap

- [ ] Multi-signature escrow releases
- [ ] Dispute resolution system
- [ ] NFT achievement system
- [ ] Integration with ENS
- [ ] Cross-chain deployment
- [ ] Frontend DApp interface

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **CryptoRhinoo** - *Initial work*

## 🙏 Acknowledgments

- Built with [Foundry](https://getfoundry.sh/)
- Inspired by Tinder's matching system
- Community feedback and contributions

## 📞 Contact

- Twitter: [@YourTwitter](https://twitter.com/yourhandle)
- Discord: Your Discord Server
- Email: your@email.com

---

Made with ❤️ for the Web3 community
