"use client"

import { useState } from "react"
import { Heart, X, Menu, Bell, User, Home, Zap, Settings, Star, Lock, TrendingUp } from "lucide-react"
import { WalletConnect } from "@/components/wallet-connect"

export default function BoraApp() {
  const [view, setView] = useState("landing")
  const [currentCard, setCurrentCard] = useState(0)
  const [matches, setMatches] = useState<typeof opportunities>([])
  const [swipeDirection, setSwipeDirection] = useState<string | null>(null)
  const [showMatch, setShowMatch] = useState(false)

  const opportunities = [
    {
      id: 1,
      title: "DeFi Dashboard Frontend",
      budget: 5000,
      skills: ["React", "Web3.js", "Tailwind"],
      description:
        "Build a responsive dashboard for tracking DeFi portfolio performance with real-time data visualization and wallet integration.",
      creator: "CryptoVentures",
      reputation: 4.8,
      escrow: true,
    },
    {
      id: 2,
      title: "NFT Marketplace Smart Contract",
      budget: 8500,
      skills: ["Solidity", "Hardhat", "OpenZeppelin"],
      description:
        "Develop secure and gas-optimized smart contracts for an NFT marketplace with royalty distribution and lazy minting.",
      creator: "ArtChain Labs",
      reputation: 4.9,
      escrow: true,
    },
    {
      id: 3,
      title: "Web3 Mobile Wallet UI",
      budget: 6200,
      skills: ["React Native", "ethers.js", "TypeScript"],
      description:
        "Design and implement an intuitive mobile wallet interface with biometric authentication and multi-chain support.",
      creator: "BlockWallet Inc",
      reputation: 4.7,
      escrow: true,
    },
  ]

  const activeMatches = [
    { id: 1, title: "DeFi Dashboard", client: "CV", progress: 65, status: "In Progress", escrow: 5000 },
    { id: 2, title: "Token Swap Interface", client: "AL", progress: 30, status: "In Progress", escrow: 3500 },
    { id: 3, title: "DAO Voting Portal", client: "BW", progress: 100, status: "Completed", escrow: 4800 },
  ]

  const handleSwipe = (direction: string) => {
    setSwipeDirection(direction)
    setTimeout(() => {
      if (direction === "right") {
        setMatches([...matches, opportunities[currentCard]])
        setShowMatch(true)
        setTimeout(() => setShowMatch(false), 2000)
      }
      if (currentCard < opportunities.length - 1) {
        setCurrentCard(currentCard + 1)
      } else {
        setCurrentCard(0)
      }
      setSwipeDirection(null)
    }, 300)
  }

  if (view === "landing") {
    return (
      <div className="min-h-screen bg-background text-foreground overflow-hidden">
        <div className="absolute inset-0 overflow-hidden opacity-20">
          <div className="absolute top-20 left-10 w-96 h-96 bg-energy-blue/40 rounded-full blur-3xl"></div>
          <div className="absolute bottom-20 right-10 w-96 h-96 bg-hot-pink/40 rounded-full blur-3xl"></div>
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-neon-pulse/30 rounded-full blur-3xl"></div>
          <div className="absolute top-40 right-1/4 w-80 h-80 bg-electric-green/30 rounded-full blur-3xl"></div>
          <div className="absolute bottom-40 left-1/4 w-80 h-80 bg-sunset-orange/30 rounded-full blur-3xl"></div>
        </div>

        <div className="relative z-10 flex justify-between items-center p-6 border-b border-border/30">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 gradient-rainbow rounded-xl flex items-center justify-center font-heading font-bold text-xl text-white shadow-lg">
              B
            </div>
            <span className="text-2xl font-heading font-bold tracking-tight gradient-rainbow bg-clip-text text-transparent">BORA</span>
          </div>
          <WalletConnect />
        </div>

        <div className="relative z-10 flex flex-col items-center justify-center min-h-[80vh] px-6">
          <div className="max-w-4xl mx-auto text-center space-y-6">
            <h1 className="text-6xl md:text-7xl font-heading font-bold tracking-tight text-balance">
              Find Your Perfect <span className="gradient-sunset bg-clip-text text-transparent">Match</span>
            </h1>
            <p className="text-2xl md:text-3xl text-muted-foreground font-heading font-light">
              <span className="text-energy-blue">Swipe.</span> <span className="text-hot-pink">Match.</span> <span className="text-electric-green">Build.</span>
            </p>
            <p className="text-base text-muted-foreground max-w-2xl mx-auto leading-relaxed">
              Connect with opportunities in the Web3 ecosystem. Professional matching for developers and projects.
            </p>
          </div>

          <div className="flex flex-col sm:flex-row gap-4 mt-12">
            <button
              onClick={() => setView("swipe")}
              className="px-8 py-4 gradient-ocean text-white rounded-full font-heading font-semibold text-lg hover:opacity-90 transition-all shadow-lg shadow-energy-blue/20"
            >
              I'm a Developer
            </button>
            <button
              onClick={() => setView("dashboard")}
              className="px-8 py-4 border-2 border-hot-pink text-hot-pink rounded-full font-heading font-semibold text-lg hover:bg-hot-pink/10 transition-all"
            >
              I'm Hiring
            </button>
          </div>

          <div className="flex flex-wrap justify-center gap-8 mt-16 text-sm">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 bg-energy-blue rounded-full animate-pulse"></div>
              <span className="text-muted-foreground">2,847 Active Developers</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 bg-hot-pink rounded-full animate-pulse"></div>
              <span className="text-muted-foreground">1,293 Opportunities</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 bg-electric-green rounded-full animate-pulse"></div>
              <span className="text-muted-foreground">184 Matches Today</span>
            </div>
          </div>
        </div>
      </div>
    )
  }

  if (view === "swipe") {
    const opportunity = opportunities[currentCard]

    return (
      <div className="min-h-screen bg-background">
        <div className="flex justify-between items-center p-4 border-b border-border">
          <button onClick={() => setView("landing")} className="p-2 hover:bg-muted rounded-lg transition-colors">
            <Menu size={24} />
          </button>
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-primary rounded-xl flex items-center justify-center font-heading font-bold text-primary-foreground">
              B
            </div>
            <span className="font-heading font-bold text-xl">BORA</span>
          </div>
          <button onClick={() => setView("dashboard")} className="p-2 hover:bg-muted rounded-lg transition-colors">
            <Bell size={24} />
          </button>
        </div>

        {/* Swipe Card Container */}
        <div className="flex flex-col items-center justify-center min-h-[calc(100vh-200px)] px-4 py-8">
          {opportunity ? (
            <div
              className={`w-full max-w-md bg-card border border-border rounded-3xl p-8 shadow-xl transform transition-all duration-300 ${
                swipeDirection === "left"
                  ? "-translate-x-full rotate-12 opacity-0"
                  : swipeDirection === "right"
                    ? "translate-x-full -rotate-12 opacity-0"
                    : "translate-x-0 rotate-0 opacity-100"
              }`}
            >
              {/* Budget & Escrow */}
              <div className="flex justify-between items-start mb-6">
                <div>
                  <div className="text-4xl font-heading font-bold text-primary">
                    ${opportunity.budget.toLocaleString()}
                  </div>
                  <div className="text-sm text-muted-foreground mt-1">Budget (USD)</div>
                </div>
                {opportunity.escrow && (
                  <div className="flex items-center gap-1.5 bg-primary/10 text-primary px-3 py-1.5 rounded-full text-sm font-medium border border-primary/20">
                    <Lock size={14} />
                    <span>Escrow</span>
                  </div>
                )}
              </div>

              <h2 className="text-2xl font-heading font-bold mb-4 text-balance">{opportunity.title}</h2>

              <div className="flex flex-wrap gap-2 mb-6">
                {opportunity.skills.map((skill, idx) => (
                  <span
                    key={idx}
                    className="px-3 py-1.5 bg-accent/10 text-accent rounded-full border border-accent/20 cursor-move hover:bg-accent/20 transition-all font-medium"
                  >
                    {skill}
                  </span>
                ))}
              </div>

              {/* Description */}
              <p className="text-muted-foreground mb-6 leading-relaxed line-clamp-3">{opportunity.description}</p>

              {/* Creator Info */}
              <div className="flex items-center justify-between pt-6 border-t border-border">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center text-sm font-heading font-bold text-primary-foreground">
                    {opportunity.creator.substring(0, 2)}
                  </div>
                  <div>
                    <div className="text-sm font-semibold">{opportunity.creator}</div>
                    <div className="flex items-center gap-1 text-xs text-muted-foreground">
                      <Star size={12} className="fill-amber-400 text-amber-400" />
                      <span>{opportunity.reputation}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center">
              <div className="text-6xl mb-4">✨</div>
              <div className="text-xl font-heading text-muted-foreground mb-4">No more opportunities</div>
              <button
                onClick={() => setCurrentCard(0)}
                className="mt-4 px-6 py-2 bg-primary text-primary-foreground rounded-full hover:opacity-90 transition-all font-medium"
              >
                Start Over
              </button>
            </div>
          )}
        </div>

        {opportunity && (
          <div className="flex justify-center gap-8 pb-8">
            <button
              onClick={() => handleSwipe("left")}
              className="w-16 h-16 bg-destructive/10 text-destructive rounded-full flex items-center justify-center hover:bg-destructive/20 hover:scale-105 transition-all border border-destructive/30"
            >
              <X size={32} strokeWidth={2.5} />
            </button>
            <button
              onClick={() => handleSwipe("right")}
              className="w-16 h-16 bg-primary/10 text-primary rounded-full flex items-center justify-center hover:bg-primary/20 hover:scale-105 transition-all border border-primary/30"
            >
              <Heart size={32} strokeWidth={2.5} />
            </button>
          </div>
        )}

        {/* Match Modal */}
        {showMatch && (
          <div className="fixed inset-0 bg-background/80 backdrop-blur-sm flex items-center justify-center z-50">
            <div className="text-center animate-bounce">
              <div className="text-6xl mb-4">🎉</div>
              <div className="text-4xl font-heading font-bold text-primary">It's a Match!</div>
            </div>
          </div>
        )}
      </div>
    )
  }

  if (view === "dashboard") {
    return (
      <div className="min-h-screen bg-background">
        {/* Top Bar */}
        <div className="flex justify-between items-center p-4 border-b border-border">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-primary rounded-xl flex items-center justify-center font-heading font-bold text-primary-foreground">
              B
            </div>
            <span className="font-heading font-bold text-xl">BORA</span>
          </div>
          <div className="flex items-center gap-4">
            <WalletConnect />
            <div className="flex items-center gap-1.5 bg-accent/10 px-3 py-2 rounded-lg border border-accent/20">
              <Star size={16} className="fill-amber-400 text-amber-400" />
              <span className="font-heading font-semibold">85</span>
            </div>
          </div>
        </div>

        <div className="flex">
          {/* Sidebar */}
          <div className="w-20 border-r border-border flex flex-col items-center py-8 gap-6 bg-card/30">
            <button
              onClick={() => setView("dashboard")}
              className="p-3 bg-primary/10 text-primary rounded-xl border border-primary/20"
            >
              <Home size={24} />
            </button>
            <button
              onClick={() => setView("swipe")}
              className="p-3 hover:bg-muted rounded-xl text-muted-foreground hover:text-foreground transition-colors"
            >
              <Zap size={24} />
            </button>
            <button className="p-3 hover:bg-muted rounded-xl text-muted-foreground hover:text-foreground transition-colors">
              <TrendingUp size={24} />
            </button>
            <button
              onClick={() => setView("profile")}
              className="p-3 hover:bg-muted rounded-xl text-muted-foreground hover:text-foreground transition-colors"
            >
              <User size={24} />
            </button>
            <button className="p-3 hover:bg-muted rounded-xl text-muted-foreground hover:text-foreground transition-colors mt-auto">
              <Settings size={24} />
            </button>
          </div>

          {/* Main Content */}
          <div className="flex-1 p-8">
            <div className="flex justify-between items-center mb-8">
              <h1 className="text-3xl font-heading font-bold">Active Matches</h1>
              <button
                onClick={() => setView("swipe")}
                className="px-6 py-2.5 bg-primary text-primary-foreground rounded-full hover:opacity-90 transition-all font-medium shadow-lg shadow-primary/20"
              >
                Find More
              </button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {activeMatches.map((match) => (
                <div
                  key={match.id}
                  className="bg-card border border-border rounded-2xl p-6 hover:border-primary/40 hover:shadow-lg transition-all cursor-pointer"
                >
                  <div className="flex items-start justify-between mb-4">
                    <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center font-heading font-bold text-primary-foreground">
                      {match.client}
                    </div>
                    <span
                      className={`px-3 py-1 rounded-full text-xs font-medium border ${
                        match.status === "Completed"
                          ? "bg-primary/10 text-primary border-primary/20"
                          : "bg-accent/10 text-accent border-accent/20"
                      }`}
                    >
                      {match.status}
                    </span>
                  </div>

                  <h3 className="font-heading font-bold text-lg mb-3">{match.title}</h3>

                  <div className="flex items-center gap-2 text-sm text-muted-foreground mb-4">
                    <Lock size={14} />
                    <span>${match.escrow.toLocaleString()} escrowed</span>
                  </div>

                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span className="text-muted-foreground">Progress</span>
                      <span className="font-heading font-semibold">{match.progress}%</span>
                    </div>
                    <div className="w-full bg-muted rounded-full h-2 overflow-hidden">
                      <div
                        className="bg-primary h-2 rounded-full transition-all"
                        style={{ width: `${match.progress}%` }}
                      ></div>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
              <div className="bg-primary/5 rounded-2xl p-6 border border-primary/20">
                <div className="text-4xl font-heading font-bold text-primary mb-2">{matches.length + 12}</div>
                <div className="text-muted-foreground">Total Matches</div>
              </div>
              <div className="bg-accent/5 rounded-2xl p-6 border border-accent/20">
                <div className="text-4xl font-heading font-bold text-accent mb-2">$24.5k</div>
                <div className="text-muted-foreground">Total Earned</div>
              </div>
              <div className="bg-neon/5 rounded-2xl p-6 border border-neon/20">
                <div className="text-4xl font-heading font-bold text-neon mb-2">4.8★</div>
                <div className="text-muted-foreground">Avg Rating</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  if (view === "profile") {
    return (
      <div className="min-h-screen bg-background">
        {/* Top Bar */}
        <div className="flex justify-between items-center p-4 border-b border-border">
          <button onClick={() => setView("dashboard")} className="p-2 hover:bg-muted rounded-lg transition-colors">
            <Menu size={24} />
          </button>
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-primary rounded-xl flex items-center justify-center font-heading font-bold text-primary-foreground">
              B
            </div>
            <span className="font-heading font-bold text-xl">BORA</span>
          </div>
          <button className="px-4 py-2 bg-primary text-primary-foreground rounded-lg hover:opacity-90 transition-all font-medium">
            Save
          </button>
        </div>

        <div className="max-w-6xl mx-auto p-8">
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Left Column */}
            <div className="space-y-6">
              <div className="bg-card border border-border rounded-2xl p-6">
                <div className="w-32 h-32 bg-primary rounded-full mx-auto mb-4 flex items-center justify-center text-4xl font-heading font-bold text-primary-foreground">
                  JD
                </div>
                <div className="text-center">
                  <h2 className="text-2xl font-heading font-bold mb-2">John Developer</h2>
                  <div className="text-sm text-muted-foreground mb-4 font-mono">0x742d...3f9a</div>
                  <div className="flex items-center justify-center gap-1 text-amber-400 mb-2">
                    <Star size={20} className="fill-amber-400" />
                    <span className="text-2xl font-heading font-bold text-foreground">85</span>
                    <span className="text-muted-foreground">/100</span>
                  </div>
                  <div className="text-sm text-muted-foreground">Reputation Score</div>
                </div>
              </div>

              <div className="bg-card border border-border rounded-2xl p-6">
                <h3 className="font-heading font-bold mb-4">Quick Stats</h3>
                <div className="space-y-3">
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Completed Jobs</span>
                    <span className="font-heading font-semibold">24</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Success Rate</span>
                    <span className="font-heading font-semibold text-primary">96%</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Response Time</span>
                    <span className="font-heading font-semibold">2.3h</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Right Column */}
            <div className="lg:col-span-2 space-y-6">
              <div className="bg-card border border-border rounded-2xl p-6">
                <h3 className="font-heading font-bold text-xl mb-4">About</h3>
                <textarea
                  className="w-full bg-muted/50 rounded-lg p-4 text-foreground border border-border focus:border-primary focus:outline-none resize-none transition-colors"
                  rows={4}
                  placeholder="Tell potential clients about yourself..."
                  defaultValue="Full-stack Web3 developer with 5+ years of experience building DeFi protocols and NFT platforms. Passionate about creating secure, scalable smart contracts and beautiful user interfaces."
                />
              </div>

              <div className="bg-card border border-border rounded-2xl p-6">
                <h3 className="font-heading font-bold text-xl mb-4">Skills</h3>
                <div className="flex flex-wrap gap-2">
                  {[
                    "Solidity",
                    "React",
                    "Web3.js",
                    "Node.js",
                    "TypeScript",
                    "Hardhat",
                    "ethers.js",
                    "Tailwind CSS",
                  ].map((skill, idx) => (
                    <span
                      key={idx}
                      className="px-4 py-2 bg-accent/10 text-accent rounded-full border border-accent/20 cursor-move hover:bg-accent/20 transition-all font-medium"
                    >
                      {skill}
                    </span>
                  ))}
                  <button className="px-4 py-2 border-2 border-dashed border-border text-muted-foreground rounded-full hover:border-primary hover:text-primary transition-all">
                    + Add Skill
                  </button>
                </div>
              </div>

              <div className="bg-card border border-border rounded-2xl p-6">
                <h3 className="font-heading font-bold text-xl mb-4">Completed Projects</h3>
                <div className="space-y-4">
                  {[
                    { title: "DeFi Staking Platform", client: "CryptoVentures", rating: 5, earnings: 5000 },
                    { title: "NFT Minting dApp", client: "ArtChain Labs", rating: 5, earnings: 4200 },
                    { title: "DAO Governance Portal", client: "BlockWallet Inc", rating: 4.8, earnings: 6800 },
                  ].map((project, idx) => (
                    <div
                      key={idx}
                      className="flex items-center justify-between p-4 bg-muted/50 rounded-lg border border-border"
                    >
                      <div>
                        <div className="font-heading font-semibold">{project.title}</div>
                        <div className="text-sm text-muted-foreground">{project.client}</div>
                      </div>
                      <div className="text-right">
                        <div className="flex items-center gap-1 text-amber-400 mb-1">
                          <Star size={14} className="fill-amber-400" />
                          <span className="text-sm font-heading font-semibold text-foreground">{project.rating}</span>
                        </div>
                        <div className="text-sm text-primary font-heading font-medium">
                          ${project.earnings.toLocaleString()}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return null
}
