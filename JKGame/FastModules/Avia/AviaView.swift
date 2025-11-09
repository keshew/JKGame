import SwiftUI

struct AviaView: View {
    @StateObject var viewModel =  AviaViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image(.aviaBG)
                .resizable()
                .ignoresSafeArea()
            
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
                    
                    Image(.aviaLabel)
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
                                        
                                        Text("\(viewModel.coin)")
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                        .frame(width: 91, height: 37)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Image(.plane)
                        .resizable()
                        .frame(width: 117, height: 40)
                        .offset(x: viewModel.planePositionX)
                        .rotationEffect(Angle(degrees: viewModel.planeRotation))
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        Image(.aviaBack)
                            .resizable()
                            .frame(width: 148, height: 65)
                            .overlay {
                                HStack  {
                                    Button(action: {
                                        viewModel.bet = max(50, viewModel.bet - 50)
                                    }) {
                                        Text("-")
                                            .font(.system(size: 30))
                                            .foregroundStyle(.white)
                                            .outlineText(color: .black, width: 0.6)
                                    }
                                    
                                    HStack {
                                        Text("\(viewModel.bet)")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.white)
                                            .outlineText(color: .black, width: 0.6)
                                        
                                        Image(.coin)
                                            .resizable()
                                            .frame(width: 26, height: 26)
                                    }
                                    
                                    Button(action: {
                                        if (viewModel.bet + 50) <= viewModel.coin {
                                            viewModel.bet += 50
                                        }
                                    }) {
                                        Text("+")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.white)
                                            .outlineText(color: .black, width: 0.6)
                                    }
                                }
                            }
                        
                        Button(action: {
                            if !viewModel.isPlaying {
                                viewModel.startGame()
                            } else {
                                viewModel.collectReward()
                            }
                        }) {
                            Image(.aviaBack)
                                .resizable()
                                .frame(width: 148, height: 65)
                                .overlay {
                                    Text(viewModel.isPlaying ? "GIVE" : "PLAY")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                        .outlineText(color: .black, width: 0.6)
                                }
                        }
                    }
                    
                    Image(.aviaBack)
                        .resizable()
                        .frame(width: 148, height: 65)
                        .overlay {
                            Text("\(Int(viewModel.reward))")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                                .outlineText(color: .black, width: 0.6)
                        }
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    AviaView()
}

