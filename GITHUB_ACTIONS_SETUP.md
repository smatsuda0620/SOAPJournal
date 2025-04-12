# GitHub Actions による自動ビルド・配信セットアップ手順

このドキュメントでは、SOAPジャーナルアプリをGitHub ActionsでビルドしてTestFlightに自動配信するためのセットアップ手順を説明します。

## 前提条件

1. Apple Developer Programメンバーシップ（年間$99）
2. App Store Connectにアプリが登録済みであること
3. 署名証明書とプロビジョニングプロファイルの準備
4. App Store ConnectのAPIキー

## GitHub Secretsの設定

以下のシークレットをリポジトリ設定の「Settings > Secrets and variables > Actions」に追加する必要があります：

| シークレット名 | 説明 |
|--------------|------|
| `BUILD_CERTIFICATE_BASE64` | 配布証明書をBase64エンコードしたもの |
| `P12_PASSWORD` | 証明書のパスワード |
| `KEYCHAIN_PASSWORD` | キーチェーン用の一時パスワード（任意の値） |
| `PROVISIONING_PROFILE_BASE64` | プロビジョニングプロファイルをBase64エンコードしたもの |
| `DEVELOPER_APP_ID` | App Store ConnectのアプリID |
| `DEVELOPER_APP_IDENTIFIER` | アプリのバンドルID（例：com.yourname.soapjournal） |
| `PROVISIONING_PROFILE_SPECIFIER` | プロビジョニングプロファイルの名前 |
| `APPLE_TEAM_ID` | Apple Developer TeamのID |
| `APPLE_API_KEY_ID` | App Store Connect APIキーのID |
| `APPLE_API_ISSUER_ID` | App Store Connect APIキーの発行者ID |
| `APPLE_API_KEY_CONTENT` | APIキー(.p8ファイル)の内容をBase64エンコードしたもの |

## 証明書とプロファイルのエンコード方法

ターミナルで以下のコマンドを実行して、証明書とプロビジョニングプロファイルをBase64エンコードします：

```bash
# 配布証明書のエンコード
base64 -i Distribution.p12 | pbcopy

# プロビジョニングプロファイルのエンコード
base64 -i profile.mobileprovision | pbcopy
```

## App Store Connect APIキーの取得

1. App Store Connectにログイン
2. 「ユーザーとアクセス」>「キー」タブを選択
3. 「+」ボタンをクリックして新しいキーを生成
4. キー名を入力し、アクセス権を「App Manager」に設定
5. 「生成」をクリック
6. ダウンロードしたAPIキー(.p8ファイル)を保存
7. キーIDと発行者IDをメモ

APIキーの内容をBase64エンコード：
```bash
base64 -i AuthKey_XXXXXXXX.p8 | pbcopy
```

## プロジェクト構造の調整

GitHub Actionsでビルドする前に、リポジトリのファイル構造がXcodeプロジェクト形式に合わせて正しく設定されていることを確認してください。必要に応じて、ワークフローファイル内の以下の部分を調整します：

```yaml
- name: Prepare Xcode Project
  run: |
    # ここでプロジェクト構造を調整
    # ...
```

## ワークフローの実行

全てのシークレットとファイルを設定した後：

1. コードをpushすると自動的にワークフローが実行されます
2. または「Actions」タブから手動でワークフローを実行できます（workflow_dispatch）

## トラブルシューティング

ビルドやデプロイに問題がある場合は、以下を確認してください：

1. 全てのシークレットが正しく設定されているか
2. 証明書とプロビジョニングプロファイルが有効か
3. Xcodeのバージョン互換性（必要に応じてワークフローファイルの `xcode-version` を変更）
4. プロジェクト構造が正しく、ビルド設定が適切か

## 注意事項

- APIキーなどの機密情報はGitHub Secretsに安全に保存し、リポジトリに直接コミットしないでください
- 証明書やプロビジョニングプロファイルの有効期限が近づいたら更新が必要です
- ワークフローファイルに記述されているxcodebuildコマンドのオプションは、プロジェクト構造に合わせて調整が必要な場合があります