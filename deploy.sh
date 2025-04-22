#!/bin/bash

# エラーが発生したら即座に終了
set -e

echo "🚀 SOAPJournal TestFlightデプロイスクリプト 🚀"
echo "==============================================="

# 必要なツールの確認
check_dependencies() {
  echo "📋 依存関係を確認中..."
  
  if ! command -v ruby &> /dev/null; then
    echo "❌ Rubyがインストールされていません。"
    exit 1
  fi
  
  if ! command -v bundle &> /dev/null; then
    echo "📦 Bundlerをインストールしています..."
    gem install bundler -N
  fi
  
  if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcodeがインストールされていないか、パスが通っていません。"
    exit 1
  fi
  
  echo "✅ 依存関係の確認完了"
}

# 環境変数の確認
check_environment() {
  echo "🔑 API環境変数を確認中..."
  
  local missing_keys=()
  
  if [ -z "$APP_STORE_CONNECT_API_KEY_ID" ]; then
    missing_keys+=("APP_STORE_CONNECT_API_KEY_ID")
  fi
  
  if [ -z "$APP_STORE_CONNECT_API_KEY_ISSUER_ID" ]; then
    missing_keys+=("APP_STORE_CONNECT_API_KEY_ISSUER_ID")
  fi
  
  if [ -z "$APP_STORE_CONNECT_API_KEY_CONTENT" ]; then
    missing_keys+=("APP_STORE_CONNECT_API_KEY_CONTENT")
  fi
  
  if [ ${#missing_keys[@]} -gt 0 ]; then
    echo "❌ 以下の環境変数が設定されていません:"
    for key in "${missing_keys[@]}"; do
      echo "  - $key"
    done
    echo ""
    echo "⚠️ GITHUB_ACTIONS_SETUP.mdを参照して、必要なAPIキーを設定してください。"
    echo "⚠️ または、GitHub Actionsでデプロイすることをお勧めします。"
    exit 1
  fi
  
  echo "✅ 環境変数の確認完了"
}

# Gemfileの依存関係インストール
install_dependencies() {
  echo "📦 依存関係をインストール中..."
  bundle check || bundle install
  echo "✅ 依存関係のインストール完了"
}

# Fastlaneを使ったデプロイ
deploy_with_fastlane() {
  echo "🚀 TestFlightへデプロイを開始します..."
  
  # 実行前デバッグ情報を表示
  bundle exec fastlane debug_info || true
  
  # TestFlightにデプロイ
  bundle exec fastlane beta
  
  echo "✅ TestFlightへのデプロイが完了しました！"
}

# メイン実行
main() {
  check_dependencies
  check_environment
  install_dependencies
  deploy_with_fastlane
  
  echo ""
  echo "🎉 SOAPJournalアプリのデプロイプロセスが完了しました！"
  echo "TestFlight経由でアプリを確認できます。"
}

# スクリプト実行
main