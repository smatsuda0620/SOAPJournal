import SwiftUI

struct PrayerTimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var prayerCompleted: Bool
    @State private var isTimerRunning = false
    @State private var showCompleteButton = false
    @State private var timerProgress: CGFloat = 0.0
    @State private var timerValue: Int = 3 // 3秒のタイマー
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color("Colors/BackgroundCream")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("祈りの時間")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Colors/PrimaryBrown"))
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15)
                        .opacity(0.3)
                        .foregroundColor(Color("Colors/PrimaryBrown"))
                    
                    Circle()
                        .trim(from: 0.0, to: timerProgress)
                        .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color("Colors/PrimaryBrown"))
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: timerProgress)
                    
                    if showCompleteButton {
                        Button(action: {
                            prayerCompleted = true
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("完了")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 50)
                                .background(Color("Colors/PrimaryBrown"))
                                .cornerRadius(30)
                        }
                    } else {
                        Text("\(timerValue)")
                            .font(.system(size: 80))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Colors/PrimaryBrown"))
                    }
                }
                .frame(width: 250, height: 250)
                
                if !isTimerRunning && !showCompleteButton {
                    Button(action: {
                        isTimerRunning = true
                    }) {
                        Text("祈りを始める")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 50)
                            .background(Color("Colors/PrimaryBrown"))
                            .cornerRadius(30)
                    }
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("キャンセル")
                        .foregroundColor(Color("Colors/PrimaryBrown"))
                        .padding()
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timerValue > 0 {
                    timerValue -= 1
                    timerProgress = CGFloat(3 - timerValue) / 3.0
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