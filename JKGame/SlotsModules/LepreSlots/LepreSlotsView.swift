import SwiftUI

struct LepreSlotsView: View {
    @StateObject var viewModel =  LepreSlotsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var isPaytable = false
    let symbolArray = ["lepre1", "lepre2", "lepre3", "lepre4", "lepre5", "lepre6"]
    let guessX = ["50x", "200x", "100x", "250x", "150x", "300x"]
    var body: some View {
        ZStack {
            Image(.lepreBg)
                .resizable()
                .ignoresSafeArea()
            
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
                    
                    Image(.lepreLabel)
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
                
                Image(.lepreRewar)
                    .resizable()
                    .frame(width: 144, height: 80)
                    .overlay {
                        VStack(spacing: -10) {
                            Text("WIN:")
                                .font(.custom("CherryBombOne-Regular", size: 22))
                                .foregroundStyle(.white)
                                .outlineText(color: .black, width: 0.7)
                            
                            Text("\(viewModel.win)")
                                .font(.custom("CherryBombOne-Regular", size: 22))
                                .foregroundStyle(.white)
                                .outlineText(color: .black, width: 0.7)
                        }
                    }
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Rectangle()
                            .fill(.black.opacity(0.6))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(LinearGradient(colors: [Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                    Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9),
                                                                    .white.opacity(0.9),
                                                                    Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                    Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9),
                                                                    .white.opacity(0.9),
                                                                    Color(red: 255/255, green: 245/255, blue: 2/255).opacity(0.9),
                                                                    Color(red: 255/255, green: 153/255, blue: 1/255).opacity(0.9)], startPoint: .top, endPoint: .bottom), lineWidth: 7)
                                    .overlay {
                                        VStack(spacing: 20) {
                                            ForEach(0..<3, id: \.self) { row in
                                                HStack(spacing: -5) {
                                                    ForEach(0..<3, id: \.self) { col in
                                                        Rectangle()
                                                            .fill(
                                                                LinearGradient(
                                                                    colors: [Color(red: 203/255, green: 200/255, blue: 176/255)],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                )
                                                            )
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 14)
                                                                    .stroke(Color(red: 228/255, green: 202/255, blue: 100/255), lineWidth: 3)
                                                                    .overlay(
                                                                        Image(viewModel.slots[row][col])
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 40, height: 40)
                                                                    )
                                                            }
                                                            .frame(width: 58, height: 58)
                                                            .cornerRadius(14)
                                                            .padding(.horizontal, 5)
                                                            .shadow(
                                                                color: viewModel.winningPositions.contains(where: { $0.row == row && $0.col == col }) ? Color.red : .clear,
                                                                radius: viewModel.isSpinning ? 0 : 25
                                                            )
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                            .frame(width: 334, height: 251)
                            .cornerRadius(16)
                            .padding(.top, 42)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                if viewModel.bet >= 100 {
                                    viewModel.bet -= 50
                                }
                            }) {
                                Image(.lepereChev)
                                    .resizable()
                                    .scaleEffect(x: -1)
                                    .frame(width: 32, height: 43)
                            }
                            .opacity(viewModel.bet <= 100 ? 0.5 : 1)
                            .disabled(viewModel.bet <= 100 ? true : false)
                            
                            Image(.lepreRewar)
                                .resizable()
                                .frame(width: 126, height: 74)
                                .overlay {
                                    VStack(spacing: -10) {
                                        Text("BET:")
                                            .font(.custom("CherryBombOne-Regular", size: 22))
                                            .foregroundStyle(.white)
                                            .outlineText(color: Color(red: 2/255, green: 93/255, blue: 27/255), width: 0.7)
                                        
                                        Text("\(viewModel.bet)")
                                            .font(.custom("CherryBombOne-Regular", size: 22))
                                            .foregroundStyle(.white)
                                            .outlineText(color: Color(red: 2/255, green: 93/255, blue: 27/255), width: 0.7)
                                    }
                                    .offset(y: -3)
                                }
                            
                            Button(action: {
                                if viewModel.bet <= (viewModel.coin - 50) {
                                    viewModel.bet += 50
                                }
                            }) {
                                Image(.lepereChev)
                                    .resizable()
                                    .frame(width: 32, height: 43)
                            }
                            .opacity(viewModel.bet <= (viewModel.coin - 50) ? 1 : 0.5)
                            .disabled(viewModel.bet <= (viewModel.coin - 50) ? false : true)
                        }
                        .padding(.top, 30)
                        
                        HStack(spacing: 30) {
                            Image(.zeusQuest)
                                .resizable()
                                .frame(width: 55, height: 55).hidden()
                            
                            Button(action: {
                                if viewModel.coin >= viewModel.bet {
                                    viewModel.spin()
                                }
                            }) {
                                Image(.lepreSpin)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 163, height: 76)
                            }
                            .disabled(viewModel.isSpinning)
                            
                            Button(action: {
                                isPaytable = true
                            }) {
                                Image(.lepreQuest)
                                    .resizable()
                                    .frame(width: 55, height: 55)
                            }
                        }
                        .padding(.top, 32)
                    }
                }
            }
            .padding(.top)
            .blur(radius: isPaytable ? 3 : 0)
            
            if isPaytable {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color(red: 12/255, green: 115/255, blue: 18/255).opacity(0.4))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 3/255, green: 255/255, blue: 18/255).opacity(0.5), lineWidth: 8)
                                .overlay {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 22) {
                                        ForEach(0..<6, id: \.self) { index in
                                            ZStack(alignment: .trailing) {
                                                Rectangle()
                                                    .fill(Color(red: 12/255, green: 115/255, blue: 18/255).opacity(0.4))
                                                    .frame(width: 105, height: 42)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color(red: 3/255, green: 255/255, blue: 18/255).opacity(0.3), lineWidth: 2)
                                                            .overlay {
                                                                HStack(spacing: 3) {
                                                                    ForEach(0..<4) { index2 in
                                                                        Image(symbolArray[index])
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 19, height: 19)
                                                                    }
                                                                }
                                                            }
                                                    }
                                                    .cornerRadius(10)
                                                
                                                Rectangle()
                                                    .fill(LinearGradient(colors: [Color(red: 23/255, green: 77/255, blue: 0/255),
                                                                                 Color(red: 99/255, green: 160/255, blue: 26/255),
                                                                                  Color(red: 46/255, green: 98/255, blue: 1/255)], startPoint: .leading, endPoint: .trailing))
                                                    .frame(width: 47, height: 20)
                                                    .overlay {
                                                        Text(guessX[index])
                                                            .font(.system(size: 12, weight: .bold))
                                                            .foregroundStyle(.white)
                                                    }
                                                    .cornerRadius(8)
                                                    .offset(x: 40)
                                            }
                                        }
                                    }
                                    .offset(x: -15)
                                }
                        }
                        .frame(width: 357, height: 269)
                        .cornerRadius(16)
                    
                    Button(action: {
                        isPaytable.toggle()
                    }) {
                        Image(.lepreCancel)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }.offset(x: 10, y: -10)
                }
            }
            
            if viewModel.win >= 2000 {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                VStack(spacing: 100) {
                    Image(.leprebigwin)
                        .resizable()
                        .frame(width: 354, height: 133)
                    
                    HStack {
                        Text("+\(viewModel.win)")
                            .font(.custom("CherryBombOne-Regular", size: 56))
                            .foregroundStyle(.white)
                            .outlineText(color: .green, width: 0.7)
                        
                        Image(.coin)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    
                    Button(action: {
                        viewModel.win = 0
                    }) {
                        Image(.claimLepre)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 181, height: 81)
                    }
                }
            }
        }
    }
}

#Preview {
    LepreSlotsView()
}

