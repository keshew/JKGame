import SwiftUI

class AviaViewModel: ObservableObject {
    @Published var coin: Int = UserDefaultsManager.shared.coins
    @Published var bet: Int = 50
    @Published var reward: Int = 0
    @Published var isPlaying: Bool = false
    @Published var planeRotation: Double = 0
    @Published var planePositionX: CGFloat = 0

    private var fallWorkItem: DispatchWorkItem?
    private var rewardTimer: Timer?
    
    func startGame() {
        guard !isPlaying else { return }
        guard bet <= coin, bet >= 50 else { return }
        
        isPlaying = true
        reward = 0
        let _ = UserDefaultsManager.shared.spendCoins(bet)
        coin = UserDefaultsManager.shared.coins

        planeRotation = 0
        planePositionX = 0

        withAnimation(.linear(duration: 3)) {
            planeRotation = 45
            planePositionX = 150
        }

        startRewardIncrement()

        fallWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.stopRewardIncrement()
            withAnimation(.linear(duration: 2)) {
                self.planeRotation = 90
                self.planePositionX = 300
            }
            self.reward = 0
            self.isPlaying = false
            self.resetPlanePosition()
        }
        fallWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
    }

    func collectReward() {
        guard isPlaying else { return }
        stopRewardIncrement()
        UserDefaultsManager.shared.addCoins(reward)
        coin = UserDefaultsManager.shared.coins
        reward = 0
        isPlaying = false
        resetPlanePosition()
        fallWorkItem?.cancel()
        fallWorkItem = nil
    }

    private func resetPlanePosition() {
        withAnimation(.easeOut(duration: 1)) {
            planeRotation = 0
            planePositionX = 0
        }
    }

    private func startRewardIncrement() {
        rewardTimer?.invalidate()
        rewardTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            let increment = Int(Double(self.bet) * 0.1) 
            self.reward = min(self.reward + increment, self.bet * 10)
        }
    }

    private func stopRewardIncrement() {
        rewardTimer?.invalidate()
        rewardTimer = nil
    }
}

