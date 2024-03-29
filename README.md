# sleep_management_app
- 睡眠時間記録アプリ

## 画面仕様
### ログイン画面
- Firebase Authentication で管理
- ログイン状態のユーザーには表示しない
- 未ログイン状態のユーザーに表示する
  - 新規作成とログインを切り替える
  - ユーザー未登録の場合はアカウントを新規作成する

ログイン | 新規作成
--- | ---
![login](readme_files/login.png) | ![create account](readme_files/create_account.png)

---
### 一覧画面
- メニューバータップで一覧画面と追加画面に遷移する
- 右下「+」ボタンタップで追加画面に遷移する
- 右上ログアウトボタンタップでログアウトする
- リストアイテムについて
  - Firestore Database で管理
  - 睡眠時間が目標を達成したかどうかでアイコンが変化する
    - 達成: チェックアイコン
    - 未達成: ベッドアイコン
  - 睡眠時間(合計)、睡眠時間帯、深い睡眠が表示される
  - 削除ボタンタップでデータを削除する
  - リストアイテムタップで編集画面に遷移する

登録データなし | 記録あり(睡眠時間達成) | 記録あり(睡眠時間未達成)
--- | --- | ---
![no data](readme_files/no_data.png) | ![achieved data](readme_files/achieved_data.png) | ![didn't achieve data](readme_files/didnot_achieve_data.png)

---
### 追加画面
- 追加ボタンタップでデータを登録する
- クリアボタンタップで入力値をクリアする

画面表示時 | 
--- |
![add data](readme_files/data_add.png)


- バリデーション
  - 入力値の有無
  - hh:mm形式
  - 00:00から23:59の範囲

入力値がない場合 | hh:mm形式になっていない場合 | 00:00-23:59の範囲外
--- | --- | ---
![no enter](readme_files/data_add_no_enter.png) | ![unmatch style](readme_files/data_add_validate.png) | ![unmatch range](readme_files/data_add_over_range.png)


---
### 編集画面
- デザインは追加画面と同様
- タップしたリストアイテムのデータが入力された状態で表示する

画面表示時 |
--- |
![alt text](readme_files/data_edit.png)
