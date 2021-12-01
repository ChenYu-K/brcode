
%%
clc                                 %コマンドウィンドウをクリアする
clear                               %ワークスペースを全部クリアする
file = dir(fullfile('*.csv'));      %csvファイルの情報を全部読み取り
filenames = {file.name};            %csvファイルの名前を取得
[~,n] = size(filenames);            %csvファイルの個数を数える

%%
%すべてのデータを行列変換
for i = 1 : n
    k = strcat(filenames(i));           %文字列に変換する
    data{i,1} = k{1,1};                 %名前を付けて
    data{i,2} = readmatrix(k{1,1});     %データを入れる
    f = data{i,2};                      %data中のi行2列のデータを取出す
    f = f(:,3);                         %計測データの3列を取出す
    f = reshape(f,4,[]);                %行列変換（５行ｎ列）
    data{i,2} = f;
end

%%
%データをテンプレートに書き込む
e = 5;
for i = 1:n
    bolt1 = data{i,2};
    [~,k] = size(bolt1);
    for m=1:k
        if (mod(m,4) == 0)
            wd = bolt1( : , m-3:m);
            local = strcat('E',num2str(e));
            writematrix(wd,'膜厚測定白井2.xlsx','range',local);
            e = e + 10;
        end
    end
end
%%
%clearvars -except data
