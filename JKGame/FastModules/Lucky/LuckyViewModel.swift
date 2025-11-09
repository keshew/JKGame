import SwiftUI

enum ScratchCardState {
    case scratch
    case winScratch
    case loseScratch
}

struct ScratchCard: Identifiable {
    let id = UUID()
    var state: ScratchCardState = .scratch
    var isRevealed: Bool = false
}

class LuckyViewModel: ObservableObject {
    @Published var openedSymbols: [(index: Int, symbol: Symbol)] = []
    @Published var isGameActive: Bool = false
    @Published var coin =  UserDefaultsManager.shared.coins
    @Published var reward = 0
    @Published var bet = 10
    @Published var winningIndexes: [Int] = []
    @Published var isPlaying = false
    
    let maxOpen = 5
    let symbolArray = [
        Symbol(image: "winScratch", value: "100"),
        Symbol(image: "loseScratch", value: "0"),
        Symbol(image: "winScratch", value: "100"),
        Symbol(image: "loseScratch", value: "0"),
        Symbol(image: "winScratch", value: "100"),
        Symbol(image: "loseScratch", value: "0")
    ]
    
    func openCell(at index: Int) {
        guard isGameActive else { return }
        guard openedSymbols.count < maxOpen else { return }
        guard !openedSymbols.contains(where: { $0.index == index }) else { return }
        
        let randomSymbol = symbolArray.randomElement()!
        openedSymbols.append((index: index, symbol: randomSymbol))
        
        if openedSymbols.count == maxOpen {
            checkWin()
            isGameActive = false
        }
    }
    
    func checkWin() {
        let symbolCounts = Dictionary(grouping: openedSymbols, by: { $0.symbol.image })
            .mapValues { $0.count }

        if let (symbol, _) = symbolCounts.first(where: { $0.value >= 3 }),
           let winningSymbol = symbolArray.first(where: { $0.image == symbol }),
           let multiplier = Int(winningSymbol.value) {
            
            winningIndexes = openedSymbols
                .filter { $0.symbol.image == symbol }
                .map { $0.index }
            
            let winnings = bet * multiplier
            UserDefaultsManager.shared.addCoins(winnings)
            coin = UserDefaultsManager.shared.coins
            
        }
    }

    
    func startGame() {
        let _ = UserDefaultsManager.shared.spendCoins(bet)
        coin = UserDefaultsManager.shared.coins
        openedSymbols = []
        isGameActive = true
    }
}

