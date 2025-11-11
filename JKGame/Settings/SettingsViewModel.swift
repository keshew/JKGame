import SwiftUI

class SettingsViewModel: ObservableObject {
    let contact = SettingsModel()
    @ObservedObject private var soundManager = SoundManager.shared
    @Published var isOn: Bool {
        didSet {
            UserDefaults.standard.set(isOn, forKey: "isOns")
            soundManager.toggleSound()
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    @Published var isNotifOn: Bool {
        didSet {
            soundManager.toggleMusic()
            UserDefaults.standard.set(isNotifOn, forKey: "isNotifOn")
        }
    }
    @Published var isVib: Bool {
        didSet {
            UserDefaults.standard.set(isVib, forKey: "isVib")
        }
    }
    
    init() {
        self.isOn = UserDefaults.standard.bool(forKey: "isOns")
        self.isNotifOn = UserDefaults.standard.bool(forKey: "isNotifOn")
        self.isVib = UserDefaults.standard.bool(forKey: "isVib")
    }
    
}
