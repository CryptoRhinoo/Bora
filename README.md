# 🚀 BORA - Web3 Talent Marketplace

**Swipe. Match. Build. Your gateway to Web3 opportunities.**

[![Live Demo](https://img.shields.io/badge/demo-live-success)](https://bora-app.vercel.app)
[![Base Sepolia](https://img.shields.io/badge/Base-Sepolia-blue)](https://sepolia.basescan.org)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

![BORA Banner](./assets/banner.png)

## 🎯 What is BORA?

BORA revolutionizes how Web3 developers and projects connect. Inspired by the simplicity of dating apps, BORA makes finding blockchain opportunities as easy as swiping.

### The Problem
- Web3 developers waste time searching across multiple platforms
- Projects struggle to find qualified talent
- There's no simple way to validate onchain reputation

### The Solution: BORA
✅ **One app** - Everything in one place  
✅ **Simple swipe** - Like or Pass in seconds  
✅ **Automatic matches** - When there's mutual interest  
✅ **Onchain reputation** - Your verifiable history on blockchain  

---

## 🏗️ Technical Architecture

### Tech Stack

```
Frontend:     React 18 + Vite + TailwindCSS
Blockchain:   Base Sepolia (Ethereum L2)
Smart Contract: Solidity 0.8.24
Wallet:       Coinbase Smart Wallet SDK
Deployment:   Vercel (Frontend) + Foundry (Contracts)
```

### Main Components

```
┌─────────────────────────────────────────┐
│         Frontend (React)                │
│  ┌──────────┐  ┌──────────┐            │
│  │  Swipe   │  │ Profile  │            │
│  │   UI     │  │ Manager  │            │
│  └──────────┘  └──────────┘            │
│  ┌──────────┐  ┌──────────┐            │
│  │ Matches  │  │  Wallet  │            │
│  │  List    │  │ Connect  │            │
│  └──────────┘  └──────────┘            │
└─────────┬───────────────────────────────┘
          │
          │ Web3 Calls
          ▼
┌─────────────────────────────────────────┐
│     Smart Contract (Bora.sol)           │
│                                         │
│  • Developer Profiles                   │
│  • Opportunities (Jobs)                 │
│  • Swipe Logic (Like/Pass)              │
│  • Match Detection                      │
│  • Reputation System                    │
│  • Event Emission                       │
└─────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│         Base Sepolia Network            │
└─────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Git
- Metamask or any compatible wallet

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/CryptoRhinoo/Bora.git
cd Bora

# 2. Install dependencies
npm install

# 3. Configure environment variables
cp .env.example .env
# Edit .env with your credentials

# 4. Start development
npm run dev
```

### Smart Contract Setup

```bash
# Navigate to contracts folder
cd contracts

# Install Foundry (if you don't have it)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Compile contracts
forge build

# Deploy to Base Sepolia
forge create --rpc-url https://sepolia.base.org \
  --private-key $PRIVATE_KEY \
  src/Bora.sol:Bora
```

---

## 📁 Project Structure

```
bora/
├── contracts/                 # Smart Contracts
│   ├── src/
│   │   └── Bora.sol          # Main contract
│   ├── test/
│   │   └── Bora.t.sol        # Tests
│   ├── script/
│   │   └── Deploy.s.sol      # Deployment script
│   └── foundry.toml
│
├── frontend/                  # React Application
│   ├── src/
│   │   ├── components/
│   │   │   ├── SwipeCard.jsx
│   │   │   ├── Profile.jsx
│   │   │   ├── Matches.jsx
│   │   │   └── WalletConnect.jsx
│   │   ├── hooks/
│   │   │   └── useContract.js
│   │   ├── utils/
│   │   │   └── web3.js
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── public/
│   └── package.json
│
├── assets/                    # Images and resources
├── README.md
├── .env.example
└── package.json
```

---

## 🎮 How to Use BORA

### For Developers

1. **Connect Your Wallet**
   - Click "Connect Wallet"
   - Accept connection with Coinbase Smart Wallet

2. **Create Your Profile**
   - Name
   - Skills (Solidity, React, etc.)
   - Short bio

3. **Start Swiping**
   - ← Swipe left = Not interested
   - → Swipe right = Interested
   - When there's a mutual match, you can contact!

4. **Build Reputation**
   - Complete jobs
   - Receive feedback
   - Earn onchain reputation

### For Projects/Companies

1. **Post Opportunities**
   - Job title
   - Description
   - Required skills
   - Budget in ETH

2. **Review Candidates**
   - See who swiped on your opportunity
   - Accept to create match
   - Contact directly

---

## 🔗 Smart Contract - Main Functions

### Write (State-Changing)

```solidity
// Create developer profile
function createDeveloperProfile(
    string memory name,
    string[] memory skills
) external

// Create opportunity
function createOpportunity(
    string memory title,
    string memory description,
    string[] memory requiredSkills,
    uint256 budget
) external

// Swipe on an opportunity
function swipeOpportunity(
    uint256 opportunityId,
    bool isLike
) external

// Accept a match
function acceptMatch(uint256 matchId) external

// Complete job and increase reputation
function completeJob(
    uint256 matchId,
    address developer
) external
```

### Read (View Functions)

```solidity
// Get developer profile
function getDeveloper(address user) external view returns (Developer memory)

// Get opportunity
function getOpportunity(uint256 id) external view returns (Opportunity memory)

// List available opportunities
function getAvailableOpportunities() external view returns (Opportunity[] memory)

// View your matches
function getUserMatches(address user) external view returns (Match[] memory)

// Check reputation
function getReputation(address user) external view returns (uint256)
```

---

## 🔐 Environment Variables

```env
# .env
VITE_COINBASE_PROJECT_ID=your_coinbase_project_id
VITE_CONTRACT_ADDRESS=0x...deployed_contract_address
VITE_BASE_SEPOLIA_RPC=https://sepolia.base.org
VITE_WALLET_CONNECT_PROJECT_ID=your_walletconnect_id
```

### Get Credentials

1. **Coinbase Developer Platform**
   - Visit: https://portal.cdp.coinbase.com
   - Create project
   - Copy Project ID

2. **WalletConnect** (optional)
   - Visit: https://cloud.walletconnect.com
   - Create project
   - Copy Project ID

---

## 📋 Base Batches Checklist ✅

- [x] App running on public URL
- [x] Public GitHub repository
- [x] Contract deployed on Base Sepolia
- [x] Minimum 1 transaction on testnet
- [x] Coinbase Smart Wallet integrated
- [x] 1-minute demo video
- [x] README with complete instructions
- [x] Technical documentation

---

## 🎥 Demo Video

📹 **[Watch Demo (1 minute)](https://youtube.com/watch?v=...)**

### Video Content
- 0:00-0:15 → Problem presentation
- 0:15-0:30 → Connect wallet and create profile
- 0:30-0:45 → Swipe opportunities and match
- 0:45-1:00 → Show onchain transaction

---

## 🔗 Important Links

- 🌐 **Live App**: [bora-app.vercel.app](https://bora-app.vercel.app)
- 📜 **Smart Contract**: [BaseScan](https://sepolia.basescan.org/address/0x...)
- 🎥 **Demo Video**: [YouTube](https://youtube.com/watch?v=...)
- 🐙 **GitHub**: [CryptoRhinoo/Bora](https://github.com/CryptoRhinoo/Bora)
- 📖 **Docs**: [Complete Documentation](./docs/ARCHITECTURE.md)

---

## 🧪 Testing

```bash
# Run smart contract tests
cd contracts
forge test

# Tests with coverage
forge coverage

# Frontend tests
cd frontend
npm run test
```

---

## 🚢 Deployment

### Frontend (Vercel)

```bash
# Connect repo with Vercel
vercel

# Configure environment variables in Vercel Dashboard
# Deploy
vercel --prod
```

### Smart Contract (Base Sepolia)

```bash
# Make sure you have ETH on Base Sepolia
# Faucet: https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet

forge script script/Deploy.s.sol:DeployBora \
  --rpc-url https://sepolia.base.org \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify
```

---

## 🛣️ Roadmap

### ✅ Phase 1 - MVP (Current)
- Developer profiles
- Swipe on opportunities
- Match system
- Basic reputation

### 🚧 Phase 2 - Q1 2026
- Integrated chat
- Escrow system for payments
- Achievement NFT badges
- Advanced filters

### 🔮 Phase 3 - Q2 2026
- AI matching algorithm
- GitHub integration
- Mainnet launch
- Governance token

---

## 🤝 Contributing

Contributions are welcome! 

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👥 Team

**CryptoRhinoo** - Founder & Lead Developer  
📧 Email: cryptorhinoo@bora.app  
🐦 Twitter: [@CryptoRhinoo](https://twitter.com/CryptoRhinoo)

---

## 📄 License

This project is under the MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- Base Team for the infrastructure
- Coinbase for Smart Wallet SDK
- Colombian Web3 developer community 🇨🇴

---

## 📞 Support

Have questions? 

- 💬 [Discord Community](https://discord.gg/bora)
- 📧 Email: support@bora.app
- 🐛 [Report Bug](https://github.com/CryptoRhinoo/Bora/issues)

---

**Made with ❤️ in Colombia 🇨🇴 for the global Web3 community**

*BORA - Building Opportunities, Rewarding Achievement*