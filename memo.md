> Globの記述例
- ``` go/*.go (goディレクトリ直下で拡張子がgoのファイル) ```
- ``` go/**/*.go (サブディレクトリを含めた、goディレクトリ配下の全goファイル) ```
- ``` .github/*.ya?ml (.githubディレクトリ直下で、拡張子がymlまたはyamlのファイル) ```
- ```!README.md (README.mdを除外)```

> アクティビティタイプの例
- Issueの場合
``` 
on: 
  issues:
    types: [opened, edited]
```
**タイプを省略するとIssueの全イベントがトリガーになる**

- Pull Requestの場合
``` 
on: 
  pull_request:
    types: [opened, synchronize, reopened]
```
