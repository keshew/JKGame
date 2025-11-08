import SwiftUI

struct Rewards: Identifiable {
    var id = UUID()
    var number = 1
    var isGot = false
    var isDone = false
}

struct RewardsView: View {
    @StateObject var rewardsModel =  RewardsViewModel()
    @Binding var isReward: Bool
    var array = [Rewards(isGot: true, isDone: true), Rewards(number: 2, isGot: false, isDone: true) , Rewards(number: 3), Rewards(number: 4), Rewards(number: 5), Rewards(number: 6)]
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .top) {
                    Image(.rewardRect)
                        .resizable()
                        .overlay {
                            VStack(spacing: 10) {
                                ForEach(array, id: \.id) { item in
                                    Rectangle()
                                        .fill(LinearGradient(colors: item.isDone ? [Color(red: 222/255, green: 1/255, blue: 1/255).opacity(0.5),
                                                                                    Color(red: 159/255, green: 25/255, blue: 25/255).opacity(0.5),
                                                                                    Color(red: 99/255, green: 0/255, blue: 0/255).opacity(0.5)] : [Color(red: 137/255, green: 137/255, blue: 137/255),
                                                                                                                                                   Color(red: 128/255, green: 128/255, blue: 128/255),
                                                                                                                                                   Color(red: 82/255, green: 82/255, blue: 82/255)], startPoint: .leading, endPoint: .trailing))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 45)
                                                .stroke(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                                Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9),
                                                                                .white.opacity(0.9),
                                                                                Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                                Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9),
                                                                                .white.opacity(0.9),
                                                                                Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                                Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9)], startPoint: .top, endPoint: .bottom), lineWidth: 8)
                                                .overlay {
                                                    HStack(spacing: 10) {
                                                        Image(.reward)
                                                            .resizable()
                                                            .frame(width: 48, height: 52)
                                                        
                                                        Text("DAY \(item.number)")
                                                            .font(.custom("CherryBombOne-Regular", size: 22))
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()
                                                        
                                                        Button(action: {
                                                            
                                                        }) {
                                                            Rectangle()
                                                                .fill(LinearGradient(colors: item.isDone ? [Color(red: 222/255, green: 1/255, blue: 1/255).opacity(0.5),
                                                                                                            Color(red: 159/255, green: 25/255, blue: 25/255).opacity(0.5),
                                                                                                            Color(red: 99/255, green: 0/255, blue: 0/255).opacity(0.5)] : [Color(red: 137/255, green: 137/255, blue: 137/255),
                                                                                                                                                                           Color(red: 128/255, green: 128/255, blue: 128/255),
                                                                                                                                                                           Color(red: 82/255, green: 82/255, blue: 82/255)], startPoint: .leading, endPoint: .trailing))
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 17)
                                                                        .stroke(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                                                        Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9),
                                                                                                        .white.opacity(0.9),
                                                                                                        Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                                                        Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9),
                                                                                                        .white.opacity(0.9),
                                                                                                        Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                                                        Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9)], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                                                                        .overlay {
                                                                            if item.isGot {
                                                                                Image(.got)
                                                                                    .resizable()
                                                                                    .frame(width: 32, height: 32)
                                                                            } else {
                                                                                HStack {
                                                                                    Image(.coin)
                                                                                        .resizable()
                                                                                        .frame(width: 22, height: 23)
                                                                                    
                                                                                    Text("500")
                                                                                        .font(.custom("CherryBombOne-Regular", size: 16))
                                                                                        .foregroundStyle(.white)
                                                                                }
                                                                            }
                                                                        }
                                                                }
                                                                .frame(width: 83, height: 43)
                                                                .cornerRadius(17)
                                                        }
                                                        .disabled(!item.isDone || item.isGot)
                                                    }
                                                    .padding(.horizontal)
                                                }
                                            
                                        }
                                        .frame(height: 82)
                                        .cornerRadius(45)
                                        .padding(.horizontal, 30)
                                }
                            }
                            .padding(.top, 50)
                        }
                        .frame(width: 339, height: 645)
                    
                    Image(.topSettingsRect)
                        .resizable()
                        .overlay {
                            Text("REWARD")
                                .font(.custom("CherryBombOne-Regular", size: 32))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 339, height: 64)
                }
                
                Button(action: {
                    isReward = false
                }) {
                    Image(.cancel)
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}

#Preview {
    RewardsView(isReward: .constant(false))
}

