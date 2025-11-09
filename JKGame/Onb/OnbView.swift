import SwiftUI

struct OnbView: View {
    @StateObject var onbModel =  OnbViewModel()
    @State var isMenu = false
    var body: some View {
        ZStack {
            Image(.bgOnb)
                .resizable().ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Welcome to\nName App")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Button(action:{
                    isMenu = true
                }) {
                    Image(.start)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 152, height: 37)
                }
                .padding(.bottom, 49)
            }
        }
        .fullScreenCover(isPresented: $isMenu) {
            MainView()
        }
    }
}

#Preview {
    OnbView()
}

