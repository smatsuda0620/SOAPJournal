# GitHub Actions を使った TestFlight 自動デプロイのセットアップ (API Keyによる自動化)

このドキュメントでは、GitHub Actions と App Store Connect API を使って SOAPJournal アプリを TestFlight に自動的にデプロイするための設定手順を説明します。このセットアップはできるだけ多くの情報を App Store Connect API から自動取得するように最適化されています。

## 必要なシークレット（最小限）

GitHub リポジトリに以下のシークレットを追加する必要があります。これらのシークレットは GitHub リポジトリの `Settings > Secrets and variables > Actions` から設定できます。

### 必須のシークレット
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API キーID
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: App Store Connect API 発行者ID
- `APP_STORE_CONNECT_API_KEY_CONTENT`: App Store Connect API キーの内容 (P8ファイルの内容)

### オプションのシークレット（自動取得が失敗した場合のみ必要）
- `APPLE_ID`: Apple ID（例: `example@example.com`）- APIキーによる認証時はオプション
- `TEAM_ID`: Apple Developer Team ID - APIから自動取得されますが、失敗した場合に必要
- `APPLE_APP_ID`: App Store Connect のアプリID - バンドルIDから自動検索されますが、失敗した場合に必要
- `ITC_TEAM_ID`: iTunes Connect Team ID - 複数チームがある場合のみ必要
- `BUNDLE_IDENTIFIER`: カスタムバンドルIDを指定する場合のみ必要 - デフォルトではInfo.plistから自動取得

## 自動取得される情報

このセットアップでは、App Store Connect API Keyを使用して以下の情報が**自動的に取得**されます：

1. **チームID** - APIキーに関連付けられたチームが自動検出されます
2. **アプリID** - プロジェクトのバンドルIDから自動検索されます
3. **プロビジョニングプロファイル** - App Store用プロファイルが自動的に選択されます
4. **バージョン番号・ビルド番号** - TestFlightの最新ビルド番号から自動インクリメントされます
5. **バンドルID** - Info.plistから自動取得されます

## App Store Connect API キーの作成手順

1. [App Store Connect](https://appstoreconnect.apple.com/) にログイン
2. `ユーザーとアクセス > キー > App Store Connect API` に移動
3. `+` ボタンをクリックして新しいキーを作成
4. キーの名前を入力し、アクセスレベルを選択（**Admin** または **App Manager** 権限が必要）
5. キーを生成して、P8ファイルをダウンロード
6. 以下の情報をGitHub シークレットとして保存：
   - **キーID** → `APP_STORE_CONNECT_API_KEY_ID`
   - **発行者ID** → `APP_STORE_CONNECT_API_KEY_ISSUER_ID`
   - **P8ファイルの内容** → `APP_STORE_CONNECT_API_KEY_CONTENT`
     - P8ファイルはテキストエディタで開き、すべての内容（BEGIN PIVATEからEND PRIVATEまで含む）をコピー

## 事前準備

1. アプリがApp Store Connectに登録されていることを確認（TestFlightにアップロードする前に必要）
2. App Store Connect APIキーが適切な権限を持っていることを確認
3. XcodeプロジェクトのInfo.plistが正しいバンドルIDを含んでいることを確認

## ワークフローの実行

必要なシークレットを設定した後、以下のいずれかの方法でワークフローを実行できます：

1. `main` ブランチにコードをプッシュ
2. GitHub リポジトリの `Actions` タブから手動で実行（workflow_dispatchトリガー）

ワークフローが完了すると、アプリが TestFlight にアップロードされ、テスターがテストできるようになります。ビルド番号は自動的にインクリメントされます。

## トラブルシューティング

ワークフローが失敗した場合は、次の点を確認してください：

1. App Store Connect APIキーの権限が適切か（Admin または App Manager 権限が必要）
2. アプリがApp Store Connectに登録されているか
3. バンドルIDが正しく、Apple Developer Portalに登録されているか
4. 自動取得に失敗した場合、対応する環境変数（TEAM_ID、APPLE_APP_IDなど）を手動で設定

ビルドログには自動取得のステータスが表示されます。何か問題があれば、必要な環境変数を手動で設定することで解決できます。