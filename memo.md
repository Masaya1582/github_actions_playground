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