import SwiftUI

class PlinkoViewModel: ObservableObject {
    @Published var coin =  UserDefaultsManager.shared.coins
    let contact = PlinkoModel()
    
    func createGameScene(gameData: GameData) -> GameSpriteKit {
        let scene = GameSpriteKit()
        scene.game  = gameData
        return scene
    }
}
