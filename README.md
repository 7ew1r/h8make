h8make
===
秋月電子通商　H8/3048f用ビルドツール

## インストール

h8make.batをパスの通ったディレクトリに配置

## 使い方

`h8make.bat`の2行目、TeraTermのインストールパスを変更

```h8make.bat
set TERATERMFILEPATH="C:\Program Files (x86)\teraterm\ttermpro.exe"
```

コマンドプロンプトでソースファイル（\*.mar,\*.c,\*.sub）の存在するディレクトリで、`h8make`を実行

```
cd /path/to/dir
h8make
```

- （\*.MOT）および（\*.MAP）が作成される

## オプション

+   `h8make help`:
    _ヘルプを表示_
+   `h8make --save-temps`:
    _中間生成物 (\*.obj,\*.abs,\*.lis) を削除せず残す_
+   `h8make -m`:
    _(\*.mar)から直接(\*.MOT)を作成_
+   `h8make clean`:
    _中間生成物および(\*.MOT,\*.MAP)を削除_
+   `h8make run [1-99]`
    _h8makeを実行後、TeraTermを起動しCOM[1-99]として接続_
    - 事前にTeraTermが起動していた場合プロセスをキルしてから起動

注意
-----
- 通常のMakefileのように、タイムスタンプを比較し必要なものだけコンパイルする機能はありません
- 複数オプションの指定はできません
- 基本的に (\*.sub) ファイル基準で作成するので、(\*.sub)ファイルが複数存在するディレクトリで走らせた場合、(\*.sub)の数の実行ファイルを生成します
