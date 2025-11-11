import SwiftUI
import SpriteKit
import Combine

class GameData: ObservableObject {
    @Published var reward: Double = 0.0
    @Published var bet: Int = 50
    @Published var numberOfBets: Int = 1 {
        didSet {
            if numberOfBets < 1 { numberOfBets = 1 }
            if numberOfBets > 4 { numberOfBets = 4 }
        }
    }
    @Published var balance: Int = UserDefaultsManager.shared.coins
    @Published var isPlayTapped: Bool = false
    @Published var labels: [String] = ["x1.1", "x1.3", "x1.6", "x2", "x5", "x5", "x2", "x1.6", "x1.3", "x1.1"]
    
    var createBallPublisher = PassthroughSubject<Void, Never>()
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    var formattedBetTotal: String {
        let total = bet * numberOfBets
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: total)) ?? "\(total)"
    }
    
    func decreaseBet() {
        if bet - 50 >= 50 {
            bet -= 50
        }
    }
    func increaseBet() {
        let newBet = bet + 50
        if newBet * numberOfBets <= balance {
            bet = newBet
        }
    }
    func setBet(to value: Int) {
        if value * numberOfBets <= balance {
            bet = value
        }
    }
    func maxBet() {
        let max = balance / numberOfBets
        bet = max - max % 50
        if bet < 50 { bet = 50 }
    }
    
    func decreaseBalls() {
        if numberOfBets > 1 {
            numberOfBets -= 1
            if bet * numberOfBets > balance {
                bet = balance / numberOfBets
                bet -= bet % 50
                if bet < 50 { bet = 50 }
            }
        }
    }
    func increaseBalls() {
        if numberOfBets < 4 {
            if bet * (numberOfBets + 1) <= balance {
                numberOfBets += 1
            }
        }
    }
    
    func dropBalls() {
        guard bet * numberOfBets <= balance else {
            return
        }
        let _ = UserDefaultsManager.shared.spendCoins(bet * numberOfBets)
        balance = UserDefaultsManager.shared.coins
        reward = 0.0
        isPlayTapped = true
        createBallPublisher.send(())
    }
    func resetGame() {
        bet = 50
        numberOfBets = 1
        reward = 0
        isPlayTapped = false
    }
    
    func addWin(_ amount: Double) {
        reward += amount
        UserDefaultsManager.shared.addCoins(Int(reward))
        balance = UserDefaultsManager.shared.coins
    }
    
    func finishGame() {
        balance += Int(reward)
        
        reward = 0
        isPlayTapped = false
    }
}

class GameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: GameData? {
        didSet {
            bindToGame()
        }
    }
    
    private func bindToGame() {
        cancellables.removeAll()
        game?.$numberOfBets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.createInitialBalls()
            }
            .store(in: &cancellables)
    }
    
    let ballCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let ticketCategory: UInt32 = 0x1 << 2
    
    var ballsInPlay: Int = 0
    var ballNodes: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        backgroundColor = .clear
        
        createObstacles()
        createTickets()
        createInitialBalls()
        
        game?.createBallPublisher.sink { [weak self] in
            self?.launchBalls()
        }.store(in: &cancellables)
    }
    
    var cancellables = Set<AnyCancellable>()
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for (index, ball) in ballNodes.enumerated().reversed() {
            if ball.position.y < 0 || ball.position.x < 0 || ball.position.x > size.width {
                ball.removeFromParent()
                ballNodes.remove(at: index)
                ballsInPlay -= 1
                createBall(atIndex: index)
            }
        }
    }
    
    func createObstacles() {
        let startRowCount = 2
        let numberOfRows = 9
        let obstacleSize = CGSize(width: size.width > 700 ? 20 : 10, height: size.width > 700 ? 30 : 20)
        let horizontalSpacing: CGFloat = size.width > 700 ? 50 : 25
        
        for row in 0..<numberOfRows {
            let countInRow = startRowCount + row
            let totalWidth = CGFloat(countInRow) * (obstacleSize.width + horizontalSpacing) - horizontalSpacing
            let xOffset = (size.width - totalWidth) / 2 + obstacleSize.width / 2
            let yPosition = size.height / 1.2 - CGFloat(row) * (obstacleSize.height + (UIScreen.main.bounds.size.height > 1000 ? 90 : UIScreen.main.bounds.size.height > 800 ? 30 : UIScreen.main.bounds.size.height > 730 ? 35 : UIScreen.main.bounds.height > 430 ? 16 : 13))
            
            for col in 0..<countInRow {
                let obstacle = SKSpriteNode(imageNamed: "obstacle")
                obstacle.size = obstacleSize
                let xPosition = xOffset + CGFloat(col) * (obstacleSize.width + horizontalSpacing)
                obstacle.position = CGPoint(x: xPosition, y: yPosition)
                
                obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacleSize.width / 2.0)
                obstacle.physicsBody?.isDynamic = false
                obstacle.physicsBody?.categoryBitMask = obstacleCategory
                obstacle.physicsBody?.contactTestBitMask = ballCategory
                
                addChild(obstacle)
            }
        }
    }
    
    func createTickets() {
        guard let game = self.game else { return }
        let labels = game.labels
        let count = labels.count
        let ticketWidth: CGFloat = size.width > 700 ? 70 : 20
        let horizontalSpacing: CGFloat = 15
        let totalWidth = CGFloat(count) * (ticketWidth + horizontalSpacing) - horizontalSpacing
        let xOffset = (size.width - totalWidth) / 2 + ticketWidth / 2
        let yPosition = size.width > 700 ? size.height / 20 : size.height / 3.5
        let colors: [UIColor] = [UIColor(red: 126/255, green: 171/255, blue: 233/255, alpha: 1), .white, UIColor(red: 1/255, green: 120/255, blue: 224/255, alpha: 1), UIColor(red: 222/255, green: 76/255, blue: 144/255, alpha: 1), .yellow, .yellow, UIColor(red: 222/255, green: 76/255, blue: 144/255, alpha: 1), UIColor(red: 1/255, green: 120/255, blue: 224/255, alpha: 1), .white, UIColor(red: 126/255, green: 171/255, blue: 233/255, alpha: 1)]
        for i in 0..<count {
            let label = SKLabelNode(text: labels[i])
            label.fontName = "Helvetica-Bold"
            label.fontSize = size.width > 700 ? 34 : 19
            label.fontColor = colors[i]
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.position = CGPoint(x: xOffset + CGFloat(i) * (ticketWidth + horizontalSpacing), y: yPosition)
            label.xScale = size.width > 700 ? 1 : 0.5
            label.yScale = 1
            
            label.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ticketWidth, height: label.frame.height))
            label.physicsBody?.isDynamic = false
            label.physicsBody?.categoryBitMask = ticketCategory
            label.physicsBody?.contactTestBitMask = ballCategory
            label.name = "ticket_\(i)"
            
            addChild(label)
        }
    }
    
    func createInitialBalls() {
        guard let game = game else { return }
        
        ballNodes.forEach { $0.removeFromParent() }
        ballNodes.removeAll()
        ballsInPlay = 0
        
        for _ in 0..<game.numberOfBets {
            let ball = SKSpriteNode(imageNamed: "ball")
            ball.size = CGSize(width: 15, height: 30)
            ball.position = CGPoint(x: size.width / 2,
                                    y: size.height / 1.07)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 5)
            ball.physicsBody?.categoryBitMask = ballCategory
            ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
            ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
            ball.physicsBody?.restitution = 0.4
            ball.physicsBody?.linearDamping = 0.5
            ball.physicsBody?.friction = 0.1
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.allowsRotation = false
            ball.physicsBody?.affectedByGravity = false
            
            addChild(ball)
            ballNodes.append(ball)
            ballsInPlay += 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let game = game else { return }
        var ticketNode: SKNode?
        var ballNode: SKNode?
        
        if contact.bodyA.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyA.node
        }
        if contact.bodyB.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyB.node
        }
        if contact.bodyA.categoryBitMask == ballCategory {
            ballNode = contact.bodyA.node
        }
        if contact.bodyB.categoryBitMask == ballCategory {
            ballNode = contact.bodyB.node
        }
        
        if let ticket = ticketNode as? SKLabelNode,
           let multiplier = parseMultiplier(from: ticket.text),
           let ball = ballNode as? SKSpriteNode {
           
           let win = Double(game.bet) * multiplier
           game.addWin(win)
           
           ball.removeFromParent()
           if let index = ballNodes.firstIndex(of: ball) {
               ballNodes.remove(at: index)
           }
           ballsInPlay -= 1

           createBall(atIndex: 0)
        }

        
        checkBallsStopped()
    }
    
    func createBall(atIndex index: Int) {
        guard let game = game else { return }
        guard index < game.numberOfBets else { return }
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 15, height: 30)
        ball.position = CGPoint(x: size.width / 2 ,
                                y: size.height / 1.07)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 5)
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.restitution = 0.4
        ball.physicsBody?.linearDamping = 0.5
        ball.physicsBody?.friction = 0.1
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.affectedByGravity = false
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
    }
    
    func launchBalls() {
        for (i, ball) in ballNodes.enumerated() {
            ball.physicsBody?.affectedByGravity = true
            let baseImpulseX: CGFloat = 0.2
            let variation = CGFloat(i) - CGFloat(ballNodes.count - 1)/2
            
            let randomXImpulse = baseImpulseX * variation + CGFloat.random(in: -0.1...0.1)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: randomXImpulse, dy: 0))
        }
    }
    
    private func parseMultiplier(from text: String?) -> Double? {
        guard let text = text?.lowercased().replacingOccurrences(of: "x", with: "") else { return nil }
        return Double(text)
    }
    
    private func checkBallsStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, let game = self.game else { return }
            let movingBalls = self.ballNodes.filter {
                guard let body = $0.physicsBody else { return false }
                return body.velocity.dx > 5 || body.velocity.dy > 5
            }
            if movingBalls.isEmpty && game.isPlayTapped {
                game.finishGame()
            }
        }
    }
}

struct PlinkoView: View {
    @StateObject var viewModel =  PlinkoViewModel()
    @Environment(\.presentationMode) var presentationMode
    @StateObject var gameModel = GameData()
    @State var selectedIndex = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 22/255, green: 25/255, blue: 82/255),
                                    Color(red: 96/255, green: 78/255, blue: 179/255),
                                    Color(red: 70/255, green: 39/255, blue: 132/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Color.black.opacity(0.6).ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 76, height: 72)
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.6))
                                .overlay {
                                    Button(action: {
                                        NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Image(.home)
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                    }
                                }
                        }
                        .cornerRadius(14)
                    
                    Spacer()
                    
                    Image(.plinkoLabel)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 164, height: 77)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(LinearGradient(colors: [Color(red: 222/255, green: 1/255, blue: 1/255).opacity(0.5),
                                                      Color(red: 159/255, green: 25/255, blue: 25/255).opacity(0.5),
                                                      Color(red: 99/255, green: 0/255, blue: 0/255).opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.5),
                                                                Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.5),
                                                                .white.opacity(0.5),
                                                                Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.5),
                                                                Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.5),
                                                                .white.opacity(0.5),
                                                                Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.5),
                                                                Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.5)], startPoint: .top, endPoint: .bottom), lineWidth: 3)
                                .overlay {
                                    HStack(spacing: 5) {
                                        Image("coin")
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                        
                                        Text("\(gameModel.balance)")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                        .frame(width: 91, height: 37)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                
                HStack {
                    ForEach(0..<4, id: \.self) { index in
                        Button(action: {
                            selectedIndex = index
                            gameModel.numberOfBets = index + 1
                        }) {
                            Image(.plinkoSelected)
                                .resizable()
                                .overlay {
                                    Text("\(index + 1)")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                        .outlineText(color: .black, width: 0.6)
                                }
                                .frame(width: 76, height: 41)
                        }
                        .opacity(selectedIndex == index ? 1 : 0.5)
                    }
                }
                ScrollView(showsIndicators: false) {
                    SpriteView(scene: viewModel.createGameScene(gameData: gameModel), options: [.allowsTransparency])
                        .frame(width: 370, height: 370)
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Image(.plinkoBackBtn)
                                .resizable()
                                .frame(width: 148, height: 65)
                                .overlay {
                                    HStack  {
                                        Button(action: {
                                            gameModel.decreaseBet()
                                        }) {
                                            Text("-")
                                                .font(.system(size: 30))
                                                .foregroundStyle(.white)
                                                .outlineText(color: .black, width: 0.6)
                                        }
                                        
                                        HStack {
                                            Text("\(gameModel.bet)")
                                                .font(.system(size: 20))
                                                .foregroundStyle(.white)
                                                .outlineText(color: .black, width: 0.6)
                                            
                                            Image(.coin)
                                                .resizable()
                                                .frame(width: 26, height: 26)
                                        }
                                        
                                        Button(action: {
                                            gameModel.increaseBet()
                                        }) {
                                            Text("+")
                                                .font(.system(size: 20))
                                                .foregroundStyle(.white)
                                                .outlineText(color: .black, width: 0.6)
                                        }
                                    }
                                }
                            
                            Button(action: {
                                gameModel.dropBalls()
                            }) {
                                Image(.plinkoBackBtn)
                                    .resizable()
                                    .frame(width: 148, height: 65)
                                    .overlay {
                                        Text("PLAY")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.white)
                                            .outlineText(color: .black, width: 0.6)
                                    }
                            }
                        }
                        
                        Image(.plinkoBackBtn)
                            .resizable()
                            .frame(width: 148, height: 65)
                            .overlay {
                                Text("\(Int(gameModel.reward))")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                                    .outlineText(color: .black, width: 0.6)
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    PlinkoView()
}

