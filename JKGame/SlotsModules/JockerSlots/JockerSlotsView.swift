import SwiftUI

struct JockerSlotsView: View {
    @StateObject var viewModel =  JockerSlotsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var isPaytable = false
    let symbolArray = ["jocker1", "jocker2", "jocker3", "jocker4", "jocker5", "jocker6"]
    let guessX = ["50x", "200x", "100x", "250x", "150x", "300x"]
    var body: some View {
        ZStack {
            Image(.jockerslotbg)
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
                    
                    Image(.jockerLabel)
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
                
                Rectangle()
                    .fill(LinearGradient(colors: [Color(red: 222/255, green: 1/255, blue: 1/255).opacity(0.5),
                                                  Color(red: 159/255, green: 25/255, blue: 25/255).opacity(0.5),
                                                  Color(red: 99/255, green: 0/255, blue: 0/255).opacity(0.5)], startPoint: .leading, endPoint: .trailing))
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
                    }
                    .frame(width: 167, height: 66)
                    .cornerRadius(16)
                
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
                                                HStack(spacing: 0) {
                                                    ForEach(0..<4, id: \.self) { col in
                                                        Rectangle()
                                                            .fill(
                                                                LinearGradient(
                                                                    colors: [Color.black.opacity(0.2)],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                )
                                                            )
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 14)
                                                                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                                                    .overlay(
                                                                        Image(viewModel.slots[row][col])
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 40, height: 40)
                                                                    )
                                                            }
                                                            .frame(width: 65, height: 58)
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
                                Image(.chevronJoker)
                                    .resizable()
                                    .scaleEffect(x: -1)
                                    .frame(width: 32, height: 43)
                            }
                            .opacity(viewModel.bet <= 100 ? 0.5 : 1)
                            .disabled(viewModel.bet <= 100 ? true : false)
                            
                            Rectangle()
                                .fill(LinearGradient(colors: [Color(red: 222/255, green: 1/255, blue: 1/255).opacity(0.5),
                                                              Color(red: 159/255, green: 25/255, blue: 25/255).opacity(0.5),
                                                              Color(red: 99/255, green: 0/255, blue: 0/255).opacity(0.5)], startPoint: .leading, endPoint: .trailing))
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
                                            VStack(spacing: -10) {
                                                Text("BET:")
                                                    .font(.custom("CherryBombOne-Regular", size: 22))
                                                    .foregroundStyle(.white)
                                                
                                                Text("\(viewModel.bet)")
                                                    .font(.custom("CherryBombOne-Regular", size: 22))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                }
                                .frame(width: 116, height: 56)
                                .cornerRadius(16)
                            
                            Button(action: {
                                if viewModel.bet <= (viewModel.coin - 50) {
                                    viewModel.bet += 50
                                }
                            }) {
                                Image(.chevronJoker)
                                    .resizable()
                                    .frame(width: 32, height: 43)
                            }
                            .opacity(viewModel.bet <= (viewModel.coin - 50) ? 1 : 0.5)
                            .disabled(viewModel.bet <= (viewModel.coin - 50) ? false : true)
                        }
                        .padding(.top, 30)
                        
                        HStack(spacing: 30) {
                            Image(.jockerQuest)
                                .resizable()
                                .frame(width: 55, height: 55).hidden()
                            
                            Button(action: {
                                if viewModel.coin >= viewModel.bet {
                                    viewModel.spin()
                                }
                            }) {
                                Image(.jockerSpin)
                                    .resizable()
                                    .frame(width: 107, height: 107)
                            }
                            .disabled(viewModel.isSpinning)
                            
                            Button(action: {
                                isPaytable = true
                            }) {
                                Image(.jockerQuest)
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
                        .fill(Color(red: 115/255, green: 23/255, blue: 9/255).opacity(0.4))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 255/255, green: 136/255, blue: 0/255).opacity(0.5), lineWidth: 8)
                                .overlay {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 22) {
                                        ForEach(0..<6, id: \.self) { index in
                                            ZStack(alignment: .trailing) {
                                                Rectangle()
                                                    .fill(Color(red: 115/255, green: 23/255, blue: 9/255).opacity(0.4))
                                                    .frame(width: 105, height: 42)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color(red: 255/255, green: 136/255, blue: 0/255).opacity(0.3), lineWidth: 2)
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
                                                    .fill(LinearGradient(colors: [Color(red: 240/255, green: 112/255, blue: 0/255),
                                                                                 Color(red: 255/255, green: 174/255, blue: 0/255)], startPoint: .leading, endPoint: .trailing))
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
                        Image(.cancel)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }.offset(x: 10, y: -10)
                }
            }
            
            if viewModel.win >= 2000 {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                VStack(spacing: 100) {
                    Image(.bigwinjocker)
                        .resizable()
                        .frame(width: 354, height: 123)
                    
                    HStack {
                        Text("+\(viewModel.win)")
                            .font(.custom("CherryBombOne-Regular", size: 56))
                            .foregroundStyle(.white)
                            .outlineText(color: .red, width: 0.7)
                        
                        Image(.coin)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    
                    Button(action: {
                        viewModel.win = 0
                    }) {
                        Image(.claomjocker)
                            .resizable()
                            .frame(width: 133, height: 61)
                    }
                }
            }
        }
    }
}

#Preview {
    JockerSlotsView()
}

extension View {
    func outlineText(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background (Rectangle()
                .foregroundStyle(strokeColor)
                .mask({
                    outline(context: content)
                })
            )}
    
    func outline(context:Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/2, y: size.height/1.9))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}
