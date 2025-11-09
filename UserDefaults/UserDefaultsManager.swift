import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let coinsKey = "coinsValue"
    private let rewardsKey = "rewardsReceived"
    private let lastRewardDateKey = "lastRewardDate"
    private let calendar = Calendar.current

    private init() {}


    var coins: Int {
        get { UserDefaults.standard.integer(forKey: coinsKey) }
        set { UserDefaults.standard.set(newValue, forKey: coinsKey) }
    }

    func addCoins(_ amount: Int) {
        coins += amount
    }

    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        }
        return false
    }


    var lastRewardDate: Date? {
        get { UserDefaults.standard.object(forKey: lastRewardDateKey) as? Date }
        set { UserDefaults.standard.set(newValue, forKey: lastRewardDateKey) }
    }

    func daysSinceLastReward() -> Int {
        guard let lastDate = lastRewardDate else { return Int.max }
        let now = Date()
        let components = calendar.dateComponents([.day], from: lastDate, to: now)
        return components.day ?? Int.max
    }
    
    func isRewardReceived(day: Int) -> Bool {
        let rewards = getRewards()
        return rewards[day] ?? false
    }

    func markRewardReceived(day: Int) {
        var rewards = getRewards()
        rewards[day] = true

        // Конвертируем ключи в строки для сохранения в UserDefaults
        let stringKeyedRewards = Dictionary(uniqueKeysWithValues:
            rewards.map { (key, value) in (String(key), value) }
        )

        UserDefaults.standard.set(stringKeyedRewards, forKey: rewardsKey)
        lastRewardDate = Date()
    }

    private func getRewards() -> [Int: Bool] {
        if let saved = UserDefaults.standard.dictionary(forKey: rewardsKey) as? [String: Bool] {
            var result: [Int: Bool] = [:]
            for (key, value) in saved {
                if let intKey = Int(key) {
                    result[intKey] = value
                }
            }
            return result
        }
        return [:]
    }

}
