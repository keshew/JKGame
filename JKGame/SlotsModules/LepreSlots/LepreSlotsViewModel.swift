import SwiftUI

class LepreSlotsViewModel: ObservableObject {
    @Published var slots: [[String]] = []
    @Published var coin =  UserDefaultsManager.shared.coins
    @Published var bet = 100
    let allFruits = ["lepre1", "lepre2", "lepre3", "lepre4", "lepre5", "lepre6"]
    @Published var winningPositions: [(row: Int, col: Int)] = []
    @Published var isSpinning = false
    @Published var isStopSpininng = false
    @Published var isWin = false
    @Published var win = 0
    var spinningTimer: Timer?
    @ObservedObject private var soundManager = SoundManager.shared
    init() {
        resetSlots()
    }
    
    @Published var betString: String = "10" {
        didSet {
            if let newBet = Int(betString), newBet > 0 {
                bet = newBet
            }
        }
    }
    let symbolArray = [
        Symbol(image: "lepre1", value: "100"),
        Symbol(image: "lepre2", value: "50"),
        Symbol(image: "lepre3", value: "25"),
        Symbol(image: "lepre4", value: "15"),
        Symbol(image: "lepre5", value: "10"),
        Symbol(image: "lepre6", value: "5")
    ]
    
    func resetSlots() {
        slots = (0..<3).map { _ in
            (0..<3).map { _ in
                allFruits.randomElement()!
            }
        }
    }
    
    func spin() {
        let _ = UserDefaultsManager.shared.spendCoins(bet)
        coin = UserDefaultsManager.shared.coins
        isSpinning = true
        soundManager.playSlot1()
        spinningTimer?.invalidate()
        winningPositions.removeAll()
        win = 0
        let columns = 3
        for col in 0..<columns {
            let delay = Double(col) * 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                var spinCount = 0
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    for row in 0..<3 {
                        withAnimation(.spring(response: 0.1, dampingFraction: 1.5, blendDuration: 0)) {
                            self.slots[row][col] = self.allFruits.randomElement()!
                        }
                    }
                    spinCount += 1
                    if spinCount > 12 + col * 4 {
                        timer.invalidate()
                        if col == columns - 1 {
                            self.isSpinning = false
                            self.soundManager.stopSlot()
                            self.checkWin()
                            
                        }
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    
    func checkWin() {
        winningPositions = []
        var totalWin = 0
        var maxMultiplier = 0
        let minCounts = [
            "lepre1": 3,
            "lepre2": 3,
            "lepre3": 3,
            "lepre4": 3,
            "lepre5": 3,
            "lepre6": 3
        ]
        let multipliers = [
            "lepre1": 100,
            "lepre2": 50,
            "lepre3": 25,
            "lepre4": 15,
            "lepre5": 10,
            "lepre6": 5
        ]
        
        for row in 0..<3 {
            let rowContent = slots[row]
            var currentSymbol = rowContent[0]
            var count = 1
            for col in 1..<rowContent.count {
                if rowContent[col] == currentSymbol {
                    count += 1
                } else {
                    if let minCount = minCounts[currentSymbol], count >= minCount {
                        totalWin += multipliers[currentSymbol] ?? 0
                        if let multiplierValue = multipliers[currentSymbol], multiplierValue > maxMultiplier {
                            maxMultiplier = multiplierValue
                        }
                        let startCol = col - count
                        for c in startCol..<col {
                            winningPositions.append((row: row, col: c))
                        }
                    }
                    currentSymbol = rowContent[col]
                    count = 1
                }
            }
            if let minCount = minCounts[currentSymbol], count >= minCount {
                totalWin += multipliers[currentSymbol] ?? 0
                if let multiplierValue = multipliers[currentSymbol], multiplierValue > maxMultiplier {
                    maxMultiplier = multiplierValue
                }
                let startCol = rowContent.count - count
                for c in startCol..<rowContent.count {
                    winningPositions.append((row: row, col: c))
                }
            }
        }
        
        if totalWin != 0 {
            win = totalWin
            isWin = true
            UserDefaultsManager.shared.addCoins(totalWin)
            coin = UserDefaultsManager.shared.coins
        }
    }
}
