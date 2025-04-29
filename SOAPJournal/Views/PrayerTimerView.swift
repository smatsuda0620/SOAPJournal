import SwiftUI

struct PrayerTimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var prayerCompleted: Bool
    @State private var isTimerRunning = true // 自動的に開始するように変更
    @State private var showCompleteButton = false
    @State private var showStartText = false
    @State private var startTextOpacity = 1.0 // 開始テキストの透明度
    @State private var timerProgress: CGFloat = 0.0
    @State private var timerValue: Int = 3 // 3秒のタイマー
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let fadeOutDuration: Double = 5.0 // フェードアウトの時間（秒）
    
    var body: some View {
        ZStack {
            Color("BackgroundCream")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text(NSLocalizedString("prayer_time", comment: "Prayer time title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryBrown"))
                
                ZStack {
                    if showCompleteButton {
                        // 完了ボタンだけを表示（円とタイマーは非表示）
                        Button(action: {
                            prayerCompleted = true
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text(NSLocalizedString("complete", comment: "Complete button"))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 50)
                                .background(Color("PrimaryBrown"))
                                .cornerRadius(30)
                        }
                        .transition(.opacity)
                    } else if showStartText {
                        // カウントダウン終了後、「開始」テキストを表示
                        Text("開始")
                            .font(.system(size: 80))
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryBrown"))
                            .opacity(startTextOpacity)
                            .transition(.opacity)
                    } else {
                        // カウントダウン中は円とタイマーを表示
                        Circle()
                            .stroke(lineWidth: 15)
                            .opacity(0.3)
                            .foregroundColor(Color("PrimaryBrown"))
                        
                        Circle()
                            .trim(from: 0.0, to: timerProgress)
                            .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color("PrimaryBrown"))
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear, value: timerProgress)
                        
                        Text("\(timerValue)")
                            .font(.system(size: 80))
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryBrown"))
                    }
                }
                .frame(width: 250, height: 250)
                
                if !isTimerRunning && !showCompleteButton {
                    Button(action: {
                        isTimerRunning = true
                    }) {
                        Text(NSLocalizedString("start_prayer", comment: "Start prayer button"))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 50)
                            .background(Color("PrimaryBrown"))
                            .cornerRadius(30)
                    }
                }
                
                // カウントダウン中のみキャンセルボタンを表示
                if !showCompleteButton {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(NSLocalizedString("cancel", comment: "Cancel button"))
                            .foregroundColor(Color("PrimaryBrown"))
                            .padding()
                    }
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timerValue > 0 {
                    // タイマー更新
                    timerValue -= 1
                    timerProgress = CGFloat(3 - timerValue) / 3.0
                } else {
                    isTimerRunning = false
                    
                    // カウントダウン終了時に「開始」テキストを表示
                    showStartText = true
                    startTextOpacity = 1.0
                    
                    // 5秒かけてフェードアウト
                    withAnimation(.linear(duration: fadeOutDuration)) {
                        startTextOpacity = 0.0
                    }
                    
                    // フェードアウト後に完了ボタンを表示
                    DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDuration) {
                        showStartText = false
                        showCompleteButton = true
                    }
                }
            }
        }
        .animation(.easeInOut, value: showStartText)
        .animation(.easeInOut, value: showCompleteButton)
    }
}

struct PrayerTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerTimerView(prayerCompleted: .constant(false))
    }
}