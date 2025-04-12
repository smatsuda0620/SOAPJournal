import Foundation

// SOAPジャーナル - シンプルコンソール版
print("🙏 SOAP Journal - デボーション記録アプリケーション 🙏")
print("====================================================")
print("S.O.A.P.メソッドで聖書の学びを記録するためのアプリです。")
print("")
print("S - Scripture (聖句): 今日読んだ聖書の箇所")
print("O - Observation (観察): 聖句から観察したこと、気づき")
print("A - Application (適用): 自分の人生へどう適用するか")
print("P - Prayer (祈り): 聖句に基づいた祈り")
print("")

// デモのシンプルなデボーション入力
func demoSoapInput() {
    print("今日のデボーションを記録しましょう！")
    print("====================================================")
    
    print("S - 聖句を入力してください:")
    let scripture = readLine() ?? ""
    
    print("O - 観察・気づきを入力してください:")
    let observation = readLine() ?? ""
    
    print("A - 適用・行動への反映を入力してください:")
    let application = readLine() ?? ""
    
    print("P - 祈りを入力してください:")
    let prayer = readLine() ?? ""
    
    // 入力内容を表示
    print("\n記録内容:")
    print("----------------------------------------------------")
    print("日付: \(Date())")
    print("S - 聖句: \(scripture)")
    print("O - 観察: \(observation)")
    print("A - 適用: \(application)")
    print("P - 祈り: \(prayer)")
    print("====================================================")
    print("記録ありがとうございます！")
}

// メインメニュー
print("1. 今日のデボーションを記録する")
print("2. TestFlightへアプリをデプロイする")
print("3. 終了")
print("選択してください (1-3):")

if let input = readLine(), let choice = Int(input) {
    if choice == 1 {
        demoSoapInput()
    } else if choice == 2 {
        print("\nTestFlightへのデプロイを開始します...")
        // deploy.shスクリプトを実行するコマンドを実行
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        task.arguments = ["./deploy.sh"]
        try? task.run()
        task.waitUntilExit()
        
        print("\nデプロイリクエストが完了しました。プロセスの詳細はGitHubのActionsタブで確認できます。")
    } else {
        print("アプリケーションを終了します。")
    }
} else {
    print("無効な入力です。アプリケーションを終了します。")
}
