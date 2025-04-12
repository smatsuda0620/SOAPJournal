#!/bin/bash

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