# 環境構築手順

## ファイルのダウンロード

```
git clone https://github.com/masanarih0ri/sinatra-rest-practice.git
```

## アプリケーションの起動

```
cd sinatra-rest-practice
# storage用の一時ファイルの作成
mkdir tmp
touch tmp/storage.json
```

```
bundle install
```
エラーが出なければ、以下のコマンドでサーバーを起動

```
bundle exec app.rb
```

