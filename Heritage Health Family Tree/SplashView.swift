import SwiftUI

struct SplashView: View {
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Image("LOGO_HH")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        opacity = 1.0
                    }
                }
        }
    }
}

#Preview {
    SplashView()
} 