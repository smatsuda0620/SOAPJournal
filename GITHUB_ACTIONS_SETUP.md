# GitHub Actions を使った TestFlight 自動デプロイのセットアップ

このドキュメントでは、GitHub Actions を使って SOAPJournal アプリを TestFlight に自動的にデプロイするための設定手順を説明します。

## 必要なシークレット

GitHub リポジトリに以下のシークレットを追加する必要があります。これらのシークレットは GitHub リポジトリの `Settings > Secrets and variables > Actions` から設定できます。

### 基本的なApple開発者アカウント情報
- `APPLE_ID`: Apple ID（例: `example@example.com`）
- `TEAM_ID`: Apple Developer Team ID（例: `ABCDE12345`）
- `ITC_TEAM_ID`: iTunes Connect Team ID（マルチチームの場合のみ必要）

### アプリ情報
- `APPLE_APP_ID`: App Store Connect のアプリID（数字）
- `PROVISIONING_PROFILE_UUID`: プロビジョニングプロファイルのUUID
- `PROVISIONING_PROFILE_NAME`: プロビジョニングプロファイルの名前

### App Store Connect API キー
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API キーID
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: App Store Connect API 発行者ID
- `APP_STORE_CONNECT_API_KEY_CONTENT`: App Store Connect API キーの内容 (P8ファイルの内容)

## App Store Connect API キーの作成手順

1. [App Store Connect](https://appstoreconnect.apple.com/) にログイン
2. `ユーザーとアクセス > キー > App Store Connect API` に移動
3. `+` ボタンをクリックして新しいキーを作成
4. キーの名前を入力し、アクセスレベルを選択（通常は `App Manager` 以上が必要）
5. キーを生成して、P8ファイルをダウンロード
6. キーID、発行者ID、P8ファイルの内容を GitHub シークレットとして保存

## プロビジョニングプロファイルの準備

1. [Apple Developer Portal](https://developer.apple.com/account/) にログイン
2. `Certificates, Identifiers & Profiles > Profiles` に移動
3. App Store 用のプロビジョニングプロファイルを作成または更新
4. プロファイルをダウンロードして開き、UUID と名前を確認（Xcode でも確認可能）

## ワークフローの実行

上記のシークレットをすべて設定した後、以下のいずれかの方法でワークフローを実行できます：

1. `main` ブランチにコードをプッシュ
2. GitHub リポジトリの `Actions` タブから手動で実行

ワークフローが完了すると、アプリが TestFlight にアップロードされ、テスターがテストできるようになります。

## トラブルシューティング

ワークフローが失敗した場合は、次の点を確認してください：

1. すべてのシークレットが正しく設定されているか
2. アプリのバンドルIDが正しいか（現在は `com.yourcompany.SOAPJournal` に設定）
3. プロビジョニングプロファイルが有効で、アプリのバンドルIDと一致しているか
4. App Store Connect API キーが有効で、適切な権限を持っているか

エラーメッセージを確認して、GitHub リポジトリの `Actions` タブでワークフローの実行ログを調査することもできます。