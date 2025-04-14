import SwiftUI

struct PrayerTimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var prayerCompleted: Bool
    @State private var isTimerRunning = true // 自動的に開始するように変更
    @State private var showCompleteButton = false
    @State private var timerProgress: CGFloat = 0.0
    @State private var timerValue: Int = 3 // 3秒のタイマー
    @State private var scale: CGFloat = 1.0 // アニメーション用のスケール
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    
                    if showCompleteButton {
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
                    } else {
                        Text("\(timerValue)")
                            .font(.system(size: 80))
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryBrown"))
                            .scaleEffect(scale)
                            .animation(.easeInOut(duration: 1), value: scale)
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
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(NSLocalizedString("cancel", comment: "Cancel button"))
                        .foregroundColor(Color("PrimaryBrown"))
                        .padding()
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timerValue > 0 {
                    // スケールを1に戻して新しい数字でアニメーションを開始
                    scale = 1.0
                    
                    // タイマー更新
                    timerValue -= 1
                    timerProgress = CGFloat(3 - timerValue) / 3.0
                    
                    // 縮小アニメーションを開始
                    withAnimation(.easeInOut(duration: 0.9)) {
                        scale = 0.6
                    }
                } else {
                    isTimerRunning = false
                    showCompleteButton = true
                }
            }
        }
    }
}

struct PrayerTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerTimerView(prayerCompleted: .constant(false))
    }
}