import SwiftUI

struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    @State var isSettings = false
    @State var isSlots = false
    @State var isFast = false
    @State var isRewards = false
    
    var body: some View {
        ZStack {
            ZStack {
                Image(.bgOnb)
                    .resizable()
                    .ignoresSafeArea()
                
                Image(.bgOnb)
                    .resizable()
                    .blur(radius: 7)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.5),
                                                            Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.5),
                                                            .white.opacity(0.5),
                                                            Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.5),
                                                            Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.5),
                                                            .white.opacity(0.5),
                                                            Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.5),
                                                            Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.5)], startPoint: .top, endPoint: .bottom), lineWidth: 3)
                            .overlay {
                                VStack(spacing: 20) {
                                    HStack(spacing: 50) {
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
                                                        HStack(spacing: 10) {
                                                            Image(.person)
                                                                .resizable()
                                                                .frame(width: 23, height: 27)
                                                            
                                                            Text("YOU")
                                                                .font(.system(size: 16, weight: .black))
                                                                .foregroundStyle(.white)
                                                        }
                                                    }
                                            }
                                            .frame(height: 48)
                                            .cornerRadius(16)
                                        
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
                                                        HStack(spacing: 10) {
                                                            Image("coin")
                                                                .resizable()
                                                                .frame(width: 23, height: 27)
                                                            
                                                            Text("2000")
                                                                .font(.system(size: 16, weight: .black))
                                                                .foregroundStyle(.white)
                                                        }
                                                    }
                                            }
                                            .frame(height: 48)
                                            .cornerRadius(16)
                                    }
                                    .padding(.horizontal)
                                    
                                    HStack(spacing: 20) {
                                        Button(action: {
                                            isRewards = true
                                        }) {
                                            Image(.bonuses)
                                                .resizable()
                                                .frame(width: 64, height: 64)
                                        }
                                        
                                        Button(action: {
                                            isSettings = true
                                        }) {
                                            Image(.settings)
                                                .resizable()
                                                .frame(width: 64, height: 64)
                                        }
                                    }
                                }
                            }
                    }
                    .frame(height: 163)
                    .cornerRadius(14)
                    .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 50) {
                        Button(action: {
                            isSlots = true
                        }) {
                            ZStack(alignment: .bottom) {
                                Image(.slotsIcn)
                                    .resizable()
                                    .frame(width: 329, height: 220)
                                
                                Image(.slotsLabel)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 194, height: 65)
                                    .offset(y: 20)
                            }
                        }
                        
                        Button(action: {
                            isFast = true
                        }) {
                            ZStack(alignment: .bottom) {
                                Image(.fastIcn)
                                    .resizable()
                                    .frame(width: 329, height: 220)
                                
                                Image(.fastLabel)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 194, height: 105)
                                    .offset(y: 40)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .padding(.top)
            
            if isSettings {
                SettingsView(isSettings: $isSettings)
                    .ignoresSafeArea()
            }
            
            if isRewards {
                RewardsView(isReward: $isRewards)
                    .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $isSlots) {
            SlotsView()
        }
        .fullScreenCover(isPresented: $isFast) {
            FastGamesView()
        }
    }
}

#Preview {
    MainView()
}

