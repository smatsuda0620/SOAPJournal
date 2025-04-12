# SOAP Journal（SOAPジャーナル）

SOAPジャーナルは、聖書のデボーション習慣を記録するためのiOSアプリケーションです。SOAPメソッド（聖句・観察・適用・祈り）に基づいて、毎日の聖書の学びを構造化して記録できます。

## 機能

- 毎日のデボーションをS.O.A.P.形式で記録
- カレンダービューでデボーション習慣を可視化
- 過去の記録の閲覧と検索
- 完全な日本語サポート（英語にも対応）

## SOAPメソッドとは？

SOAPメソッドは、聖書を読む際の効果的な方法の一つです：

- **S - Scripture（聖句）**: 今日読んだ聖書の箇所を記録します。
- **O - Observation（観察）**: 聖句から気づいたこと、観察したことを書きます。
- **A - Application（適用）**: どのように自分の生活に適用できるかを考えます。
- **P - Prayer（祈り）**: 聖句に基づいた祈りを書きます。

## プロジェクト構造

```
SOAPJournal/
├── Models/                 # データモデル
│   ├── DevotionEntry.swift # デボーション記録のモデル
│   └── SOAPJournal.xcdatamodeld # CoreDataモデル
├── Resources/              # リソースファイル
│   ├── en.lproj/          # 英語のローカライゼーション
│   └── ja.lproj/          # 日本語のローカライゼーション
├── Utilities/              # ユーティリティ
├── ViewModels/             # ビューモデル
│   └── DevotionManager.swift # データ管理
├── Views/                  # ビュー
│   ├── Components/        # 再利用可能なコンポーネント
│   │   ├── CalendarDayView.swift
│   │   └── SOAPInputView.swift
│   ├── CalendarView.swift  # カレンダー表示
│   ├── EntryDetailView.swift # 詳細表示
│   ├── HistoryView.swift   # 履歴表示
│   └── TodayView.swift     # 今日の記録
├── ContentView.swift       # メインコンテンツビュー
└── SOAPJournalApp.swift    # アプリのエントリーポイント
```

## 技術スタック

- SwiftUI: モダンなUIフレームワーク
- Core Data: ローカルデータベース
- Swift 5.x: プログラミング言語

## ビルドと実行

このプロジェクトを実行するには、Xcode 13以降が必要です：

1. プロジェクトをクローンまたはダウンロード
2. Xcodeでプロジェクトを開く
3. iOSシミュレーターまたは実機でビルド・実行

## 開発状況

現在、基本的な機能を実装中です：

- ✅ プロジェクト基本構造の設定
- ✅ ローカライゼーション（日本語・英語）
- ✅ データモデルの定義
- ✅ タブベースのナビゲーション
- ⬜ Core Data統合の完了
- ⬜ UIコンポーネントの完成
- ⬜ 通知機能
- ⬜ データのエクスポート機能

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細はLICENSEファイルを参照してください。