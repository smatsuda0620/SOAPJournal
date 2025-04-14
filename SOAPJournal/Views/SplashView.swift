import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // 背景画像
                Image("SplashBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // タイトル
                    Text("SOAP Journal")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    // サブタイトル
                    Text(NSLocalizedString("app_subtitle", comment: "App subtitle"))
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .opacity(opacity)
            }
            .onAppear {
                // フェードインアニメーション
                withAnimation(.easeIn(duration: 1.2)) {
                    self.opacity = 1.0
                }
                
                // 2秒後にメイン画面に遷移
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}