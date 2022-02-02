## lisence_check
必要な環境:
- Pandas
- numpy
- matplotlib
- dataframe_image : https://github.com/dexplo/dataframe_image

## 流れ

1. Subprocessを用いてcmdでLicense checkのコマンドを入れて，結果を返す
2. 結果を倒置して，区切する．
3. 下から数える
4. lisenceのところを残す
5. 同じ時間のパソコンのLisenceを足し合わせる．
6. グラフ化
7. Brwikiに随時更新する．（40s間程度）[^1]

## lisence_check link

`%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\Users\brcy\anaconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\Users\brcy\anaconda3' ; python lisence_test.py"`

作業フォルダー:'C:\Users\brcy\Desktop'

[^1]: 本来30s程度データを更新したいが，コードの実行時間が全部合わせて30sぐらいかかりそうなんで，30sだけ最後まで実行できない．optimizationが必要。
