import SwiftUI

struct SlotsView: View {
    @StateObject var slotsModel =  SlotsViewModel()
    @State var currentIndex = 1
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    Image(.slotsLabelScreen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 124, height: 47)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 76, height: 72)
                        .cornerRadius(14)
                        .hidden()
                        .disabled(true)
                }
                .padding(.horizontal)
                
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
                                        .frame(width: 33, height: 34)
                                    
                                    Text("2000")
                                        .font(.system(size: 16, weight: .black))
                                        .foregroundStyle(.white)
                                }
                            }
                    }
                    .frame(width: 115, height: 48)
                    .cornerRadius(16)
                
                if currentIndex >= 5 {
                    Button(action: {
                        showAlert = true
                    }) {
                        Image("slot\(currentIndex)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 326, height: 346)
                    }
                    .alert("You don't have enough coins", isPresented: $showAlert) {
                        Button("OK") {
                            showAlert.toggle()
                        }
                    }
                } else {
                    Image("slot\(currentIndex)")
                        .resizable()
                        .frame(width: 366, height: 346)
                }
                
                HStack {
                    ZStack {
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 230, height: 72)
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.6))
                            }
                            .cornerRadius(14)
                        
                        HStack {
                            Button(action: {
                                if currentIndex >= 2 {
                                    currentIndex -= 1
                                }
                            }) {
                                Image(.backBtn)
                                    .resizable()
                                    .frame(width: 55, height: 55)
                            }
                            .opacity(currentIndex >= 2 ? 1 : 0.5)
                            .disabled(currentIndex >= 2 ? false : true)
                            
                            Button(action: {
                                
                            }) {
                                Image(.playBtn)
                                    .resizable()
                                    .frame(width: 62, height: 62)
                            }
                            .offset(y: -10)
                            .opacity(currentIndex >= 5 ? 0.5 : 1)
                            .disabled(currentIndex >= 5 ? true : false)
                            
                            Button(action: {
                                if currentIndex <= 11 {
                                    currentIndex += 1
                                }
                            }) {
                                Image(.nextBtn)
                                    .resizable()
                                    .frame(width: 55, height: 55)
                            }
                            .opacity(currentIndex <= 11 ? 1 : 0.5)
                            .disabled(currentIndex <= 11 ? false : true)
                        }
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .padding(.top)
        }
    }
}

#Preview {
    SlotsView()
}

