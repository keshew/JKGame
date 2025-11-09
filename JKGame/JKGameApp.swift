import SwiftUI

@main
struct JKGameApp: App {
    
    init() {
        let stats = UserDefaultsManager.shared
        let key = "didAddInitialCoins"
        if !UserDefaults.standard.bool(forKey: key) {
            stats.addCoins(1000)
            UserDefaults.standard.set(true, forKey: key)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            OnbView()
        }
    }
}
