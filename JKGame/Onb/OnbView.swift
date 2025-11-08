import SwiftUI

struct OnbView: View {
    @StateObject var onbModel =  OnbViewModel()

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
                    
                }) {
                    Image(.start)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 152, height: 37)
                }
                .padding(.bottom, 49)
            }
        }
    }
}

#Preview {
    OnbView()
}

