"use client"

import { useState } from "react"
import { useAccount, useConnect, useDisconnect } from 'wagmi'
import { Wallet, LogOut, Copy, Check } from "lucide-react"
import { ThemeToggle } from "@/components/ThemeToggle"

export function WalletConnect() {
  const { address, isConnected } = useAccount()
  const { connect, connectors, isPending } = useConnect()
  const { disconnect } = useDisconnect()
  const [copied, setCopied] = useState(false)

  const copyAddress = () => {
    if (address) {
      navigator.clipboard.writeText(address)
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    }
  }

  const formatAddress = (addr: string) => {
    return `${addr.slice(0, 6)}...${addr.slice(-4)}`
  }

  if (isConnected && address) {
    return (
      <div className="flex items-center gap-2">
        <div className="flex items-center gap-2 bg-card px-3 py-2 rounded-lg text-sm border border-border">
          <span className="text-foreground font-mono">{formatAddress(address)}</span>
          <button
            onClick={copyAddress}
            className="text-muted-foreground hover:text-foreground transition-colors"
            title="Copy address"
          >
            {copied ? <Check size={14} className="text-primary" /> : <Copy size={14} />}
          </button>
        </div>
        <ThemeToggle />
        <button
          onClick={() => disconnect()}
          className="p-2 hover:bg-muted rounded-lg transition-colors text-muted-foreground hover:text-foreground"
          title="Disconnect wallet"
        >
          <LogOut size={18} />
        </button>
      </div>
    )
  }

  return (
    <div className="flex items-center gap-2">
      <ThemeToggle />
      <button
        onClick={() => connect({ connector: connectors[0] })}
        disabled={isPending}
        className="flex items-center gap-2 px-5 py-2.5 border border-primary/40 text-primary rounded-full hover:bg-primary hover:text-primary-foreground transition-all font-medium disabled:opacity-50 disabled:cursor-not-allowed"
      >
        <Wallet size={18} />
        <span>{isPending ? "Connecting..." : "Connect MetaMask"}</span>
      </button>
    </div>
  )
}
