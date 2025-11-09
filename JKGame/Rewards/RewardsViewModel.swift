import SwiftUI
import Combine

class RewardsViewModel: ObservableObject {
    @Published var rewards: [Rewards] = []
    @Published var coins: Int = UserDefaultsManager.shared.coins
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadRewards()
        // подписываемся на монеты если нужно обновить UI при изменении монет в менеджере
        // (В данном примере нет publisher в UserDefaultsManager, можно добавить)
    }

    func loadRewards() {
        // Пример: 6 дней наград
        rewards = (1...6).map { day in
            Rewards(number: day,
                    isGot: UserDefaultsManager.shared.isRewardReceived(day: day),
                    isDone: day <= UserDefaultsManager.shared.daysSinceLastReward())
        }
    }

    func canReceive(day: Int) -> Bool {
        // Можно получить награду если день <= дней прошедших и она ещё не вскрыта
        let daysPassed = UserDefaultsManager.shared.daysSinceLastReward()
        return day <= daysPassed && !UserDefaultsManager.shared.isRewardReceived(day: day)
    }

    func receiveReward(day: Int) {
        guard canReceive(day: day) else { return }
        // Добавляем монеты, отмечаем получение
        UserDefaultsManager.shared.addCoins(500) // пример награды 500 монет
        UserDefaultsManager.shared.markRewardReceived(day: day)

        coins = UserDefaultsManager.shared.coins
        loadRewards() // обновляем состояние наград
    }
}
