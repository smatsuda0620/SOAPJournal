#!/bin/bash

# SOAPジャーナル - デプロイスクリプト
# GitHub Actionsワークフローを手動でトリガーするスクリプト

echo "🚀 SOAPジャーナル - デプロイプロセス開始 🚀"
echo "-------------------------------------------"
echo "GitHub Actionsワークフローをトリガーして、アプリをビルドしTestFlightに配信します。"
echo ""

# GitHub Token確認
if [ -z "$GITHUB_TOKEN" ]; then
  echo "❌ エラー: GitHub Tokenが設定されていません。"
  echo "GitHubへの認証に必要なトークンを設定してください。"
  exit 1
fi

# リポジトリ情報
REPO_OWNER="smatsuda0620"
REPO_NAME="SOAPJournal"
WORKFLOW_ID="ios-deploy.yml"
BRANCH="main"

# 現在の時刻を取得（デプロイのリファレンス用）
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

echo "📋 デプロイ情報:"
echo "リポジトリ: $REPO_OWNER/$REPO_NAME"
echo "ブランチ: $BRANCH"
echo "ワークフローID: $WORKFLOW_ID"
echo "タイムスタンプ: $TIMESTAMP"
echo ""

echo "🔄 GitHub Actionsワークフローをトリガー中..."

# GitHub API を使用してワークフローディスパッチイベントをトリガー
RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/workflows/$WORKFLOW_ID/dispatches" \
  -d "{\"ref\":\"$BRANCH\", \"inputs\": {\"deploy_reference\":\"replit_deploy_$TIMESTAMP\"}}")

# レスポンスコードを確認
if [ $? -eq 0 ]; then
  echo "✅ デプロイリクエストが送信されました！"
  echo ""
  echo "GitHub Actionsワークフローがトリガーされました。"
  echo "ビルドとデプロイの進行状況は、GitHubリポジトリの'Actions'タブで確認できます:"
  echo "https://github.com/$REPO_OWNER/$REPO_NAME/actions"
  echo ""
  echo "🔔 注意: ビルドとデプロイには約10〜15分かかる場合があります。"
  echo "完了すると、TestFlightでアプリの新しいバージョンが利用可能になります。"
else
  echo "❌ エラー: デプロイリクエストの送信に失敗しました。"
  echo "レスポンス: $RESPONSE"
  echo ""
  echo "以下を確認してください:"
  echo "- GITHUB_TOKENが有効である"
  echo "- リポジトリ名とブランチ名が正しい"
  echo "- ワークフローファイルが存在する"
fi