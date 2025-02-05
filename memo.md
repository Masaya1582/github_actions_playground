## Globの記述例
- ``` go/*.go (goディレクトリ直下で拡張子がgoのファイル) ```
- ``` go/**/*.go (サブディレクトリを含めた、goディレクトリ配下の全goファイル) ```
- ``` .github/*.ya?ml (.githubディレクトリ直下で、拡張子がymlまたはyamlのファイル) ```
- ```!README.md (README.mdを除外)```

## アクティビティタイプの例
### Issueの場合
``` 
on: 
  issues:
    types: [opened, edited]
```
**タイプを省略するとIssueの全イベントがトリガーになる**

## Pull Requestの場合
``` 
on: 
  pull_request:
    types: [opened, synchronize, reopened]
```

## 主要言語のセットアップ記法
- Node.js
``` 
- uses: actions/setup-node@v4
  with: 
    node-version: '20'
    cache: npm # キャッシュの有効化 (npm使用の場合、yarnやpnpmとかも)
```

- Python
``` 
- uses: actions/setup-python@v5
  with: 
    python-version: '3.12'
    cache: pip # キャッシュの有効化 (他pipenv, poetryなど)
```

- Java
``` 
- uses: actions/setup-java@v5
  with: 
    distribution: temurin
    java-version: '21'
    cache: gradle # キャッシュの有効化 (他maven, sbtなど)
```

- Ruby
``` 
- uses: actions/setup-ruby@v5
  with: 
    ruby-version: '3.3.0'
    bundler-cache: true # Boolでcacheを制御
```

## バージョンファイル
- GOの例
```
- uses: actions/setup_go@v5
  with: 
    go-version-file: ./main.go # バージョンファイルのPATHを入れる
```

## サポートされてるシェル (Ubuntu, macOSは省略時はBashが起動)
- bash (Ubuntu, macOS, Windows)
- python (Ubuntu, macOS, Windows)
- pwsh (Ubuntu, macOS, Windows)
- sh (Ubuntu, macOS)
- cmd (Windows)
- powershell (Windows)

**Bashを明示するとpipefailオプションを有効化できるので明示するのが吉**
### デフォルトシェル
``` 
defaults:
  run:
    shell: bash # ワークフローで使うシェルをまとめて指定する、機械的に追加しておくのが吉
```

## アノテーション
```
::error::<message>
::warning::<message>
::notice::<message>
```

## キャッシュキーの設計
- プラットフォームごとに異なるキャッシュを利用する
``` 
key: example-${{ runner.os }}-${{ runner.arch }}
```

- 依存関係を更新した時だけキャッシュも変更する
```
key: node-${{ runner.os }}-${{ hashFiles('**/package-lock.json') }}
restore-keys: |
  node-${{ runner.os }}-
```

### Actionsのキャッシュの仕様
- 7日以上アクセスされていないキャッシュは自動削除
- キャッシュの合計サイズは各リポジトリで10GBまで

``` 
actions/cache/save # キャッシュの保存だけ行う
actions/cache/restore # キャッシュの復元だけ行う
```

## クレデンシャルの混入防止
- AWSのアクセスキーをパブリックリポジトリに置いて爆死しないようになど
- プライベートリポジトリでも可能な限り平文での保持はしない

### シークレットスキャンによる混入の検出
- クレデンシャルを検出したら速やかにローテション実施
1. 現在のクレデンシャルを削除 or 無効化
2. 新しいクレデンシャルを作成

## README
- 概要: 何ができて、どのような存在意義があるのか
- セットアップ: 必要条件、ソフトウェアのインストール方法
- 使い方: オーソドックスなユースケースでの利用方法
- 参考情報: LICENSE, CONTRIBUTING, リリースノートへのリンクなど

## LICENSE
- パプリックREPOには置くのが吉
- MIT License, Apache License 2.0を選択しておけばOK

## 依存関係
- なにもしてないのに壊れたを防がなければならない
- 変更し続けることが大事

## Dependabot
- package-ecosystem: パッケージマネージャやツールの識別子を指定、swiftも加納
- schedule: daily, weekly, monthlyの3つ、基本はdailyでOK
- @dependabot merge, close, recreateでDependabotを操作できる、PR内で

```
ignore: 
      - dependency-name: actions/upload-artifact # 除外する依存関係の名前
        versions: 
          - 4.3.0
          - 4.3.1
      - dependency-name: 'actions/*' # アスタリスクは任意文字列にマッチ
        update-types:
          - version-update:semver-major # 除外するバージョンアップの種類
```
除外項目は最低限に、コメントも可能な限り残すこと
- Dependabotは通常のSecretsは参照できず、Dependabot専用のSecretsを参照する
- バージョンアップする依存関係のメタデータを取得できる

## 自動マージ
```
name: Auto Merge
on: pull_request
jobs:
  merge:
    if: ${{ github.actor == 'dependabot[bot]' }} # DependabotのPRのみ
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # GITHUB CLIのクレデンシャル
    steps:
      - uses: actions/checkout@v4
      - run: gh pr merge "${GITHUB_HEAD_REF}" --squash --auto # CLIでmergeする (merge, rebase, squashの3タイプから運用に合わせて)
```
- --autoで全ワークフローの実行完了を待つ