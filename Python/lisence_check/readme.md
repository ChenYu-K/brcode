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
7. Brwikiに随時更新する．（1分間程度）

## lisence_check link

`%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\Users\brcy\anaconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\Users\brcy\anaconda3' ; python lisence_test.py"`

作業フォルダー:'C:\Users\brcy\Desktop'
