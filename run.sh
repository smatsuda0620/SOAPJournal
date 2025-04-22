#!/bin/bash

# エラーが発生したらスクリプトを終了
set -e

echo "🙏 SOAP Journal - デボーション記録アプリケーション 🙏"
echo "===================================================="
echo "S.O.A.P.メソッドで聖書の学びを記録するためのアプリです。"
echo ""
echo "S - Scripture (聖句): 今日読んだ聖書の箇所"
echo "O - Observation (観察): 聖句から観察したこと、気づき"
echo "A - Application (適用): 自分の人生へどう適用するか"
echo "P - Prayer (祈り): 聖句に基づいた祈り"
echo ""

# メニュー表示と選択
select_option() {
  echo "1. 今日のデボーションを記録する"
  echo "2. TestFlightへアプリをデプロイする"
  echo "3. 終了"
  echo -n "選択してください (1-3): "
  read choice
  
  case $choice in
    1)
      run_app
      ;;
    2)
      deploy_app
      ;;
    3)
      echo "アプリケーションを終了します。"
      exit 0
      ;;
    *)
      echo "エラー: 無効な選択です。1、2、または3を入力してください。"
      select_option
      ;;
  esac
}

# アプリを実行
run_app() {
  echo ""
  echo "SOAPジャーナル - コンパイルと実行"
  echo "------------------------------"
  
  # メインのSwiftファイルをコンパイルして実行
  SWIFT_FILE="./soapjournalsimple/main.swift"
  
  # Swiftファイルが存在するか確認
  if [ ! -f "$SWIFT_FILE" ]; then
    echo "エラー: $SWIFT_FILE が見つかりません。"
    exit 1
  fi
  
  echo "Swiftファイルをコンパイルして実行します..."
  swift "$SWIFT_FILE"
  
  echo "------------------------------"
  echo "実行が完了しました。"
  echo ""
  select_option
}

# TestFlightへデプロイ
deploy_app() {
  echo ""
  echo "TestFlightへのデプロイを開始します..."
  echo "------------------------------"
  
  # deploy.shが存在するか確認
  if [ ! -f "./deploy.sh" ]; then
    echo "エラー: deploy.sh が見つかりません。"
    exit 1
  fi
  
  # デプロイスクリプトを実行
  ./deploy.sh
  
  echo "------------------------------"
  echo "デプロイ処理が完了しました。"
  echo ""
  select_option
}

# メインスクリプト実行
select_option