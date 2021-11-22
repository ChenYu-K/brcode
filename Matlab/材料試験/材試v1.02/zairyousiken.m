
%%
clc                                 %コマンドウインドウをクリアする
clear                               %ワークスペースのクリア
file = dir(fullfile('*.csv'));      %csvファイルの情報を全部読み込む
filenames = {file.name};            %csvファイル名を取得
[~,n] = size(filenames);            %csvファイルの個数を数える
A = readmatrix('template_mt.xlsx','sheet',1,'range','F6:F8');   %断面積を取得する

%変数の定義
stressmax = 0; avx = 0; avy = 0; avx2 = 0;
Sxy = 0; Sx2 = 0; M = 0; Sxy1 = 0; Sxy2 = 0;

%%
%全てのデータを行列変換
%%%%figure
 figure1 =figure;
 axes1 = axes('Parent',figure1);
hold(axes1,'on');
ylabel({'Stress [N/mm^2]'});
xlabel({'Strain'});
%%%%%%%
for i = 1 : n
    stress_y(i) = 0;
    k = strcat(filenames(i));           %文字列に変換する
    data{i,1} = k{1,1};                 %名前を付けて
    data{i,2} = readmatrix(k{1,1});     %データを入れる
    f = data{i,2};                      %data中のi行2列のデータを取り出す
    f = f(:,3:8);                       %計測データの3～8列(荷重，変位，ひずみ*4)を取り出す
    data{i,2} = f;
    [j,~]=size(data{i,2});      %データ数の列数を数える
    
    if data{i,2}(round(j/2),4)>0          %縦ひずみ2を判定する
        next;
    else 
            data{i,2}(:,[4,5]) =data{i,2}(:,[5,4]);         %横ひずみと縦ひずみを並び替える
    end
    
    %応力・平均ひずみの出力
    for m=1:j
        stress(m) = data{i,2}(m,1)/A(i)*1000;           %`応力の出力
        strain(m,1) = 0.5*(data{i,2}(m,3) + data{i,2}(m,4));
        strain(m,2) = -0.5*(data{i,2}(m,5) + data{i,2}(m,6));
        if strain(m,1) < 4000
            stress_y(i)=max(stress(m),stress_y(i));
        end
    end
    stressmax(i) = max(stress);        %応力最大値を取得する

    %平均値を取得する
    for m=1:j
        if (stress(m) > (0.1*stress_y(i))) && (stress(m) < (0.7*stress_y(i)))
             avx = avx + strain(m,1);
             avy = avy + stress(m);
             avx2 = avx2 + strain(m,2);
             M = M+1;
        end
    end 
    avx = avx/M ; avy = avy/M; avx2 = avx2/M;
    
    %最小二乗法
    for m=1:j
        if (stress(m) > (0.1*stress_y(i))) && (stress(m) < (0.7*stress_y(i)))
            Sxy = Sxy+(strain(m,1)-avx)*(stress(m)-avy);
            Sx2 = Sx2+(strain(m,1)-avx)^2;
            Sxy1 = Sxy1+(strain(m,2)-avx2)*(strain(m,1)-avx);
            Sxy2 = Sxy2+(strain(m,2)-avx2)^2;
        end
    end 
    Yongs(i) = Sxy/Sx2*10^6;
    b = avy - Yongs * avx;
    Poissons(i) = Sxy2/Sxy1;
    
    plot(strain(:,1),stress);       %図の追加
end

writematrix(data{1,2},'template_mt.xlsx','sheet',1,'range','A15')
writematrix(data{2,2},'template_mt.xlsx','sheet',1,'range','G15')
writematrix(data{3,2},'template_mt.xlsx','sheet',1,'range','M15')
writematrix(stress_y','template_mt.xlsx','sheet',1,'range','J6')
writematrix(stressmax','template_mt.xlsx','sheet',1,'range','K6')
writematrix(Yongs','template_mt.xlsx','sheet',1,'range','L6')
writematrix(Poissons','template_mt.xlsx','sheet',1,'range','M6')

%%%Figure
set(gca,'FontSize',15);
xlim(axes1,[0 70000]);
ylim(axes1,[0 500]);
box(axes1,'on');
hold(axes1,'off');
legend1 = legend(axes1,'show');
legend('No.1','No.2','No.3','location','southeast');
