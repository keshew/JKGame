import SwiftUI

struct SettingsView: View {
    @StateObject var settingsModel =  SettingsViewModel()
    @Binding var isSettings: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .top) {
                    Image(.settingsRect)
                        .resizable()
                        .overlay {
                            VStack {
                                HStack {
                                    Text("SOUNDS")
                                        .font(.custom("CherryBombOne-Regular", size: 28))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        settingsModel.isOn.toggle()
                                    }) {
                                        Image(settingsModel.isOn ? .soundOn : .sounOff)
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                    }
                                }
                                
                                HStack {
                                    Text("MUSIC")
                                        .font(.custom("CherryBombOne-Regular", size: 28))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        settingsModel.isNotifOn.toggle()
                                    }) {
                                        Image(settingsModel.isNotifOn ? .soundOn : .sounOff)
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                    }
                                }
                                
                                HStack {
                                    Text("VIBRATION")
                                        .font(.custom("CherryBombOne-Regular", size: 28))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        settingsModel.isVib.toggle()
                                    }) {
                                        Image(settingsModel.isVib ? .soundOn : .sounOff)
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                    }
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.top, 50)
                        }
                        .frame(width: 339, height: 335)
                    
                    Image(.topSettingsRect)
                        .resizable()
                        .overlay {
                            Text("SETTINGS")
                                .font(.custom("CherryBombOne-Regular", size: 32))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 339, height: 64)
                }
                
                Button(action: {
                    isSettings.toggle()
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
    SettingsView(isSettings: .constant(false))
}
