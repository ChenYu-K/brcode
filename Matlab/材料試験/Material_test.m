clc
clear

file = dir(fullfile('*.csv'));      %csvファイルの情報を全部取り
filenames = {file.name};                %csvファイルの名前を取得
[~,n] = size(filenames);            %csvファイルの個数を数える

page1 = readmatrix("材料試験まとめ.xlsx"); 

%変数の定義
stressmax = 0; avx = 0; avy = 0; avx2 = 0;
Sxy = 0; Sx2 = 0; M = 0; Sxy1 = 0; Sxy2 = 0;


for i=2:n
    A0 = 350; %page1(i+1,2)*page1(i+1,3);       %試験体原断面積
    data = readmatrix("材料試験まとめ.xlsx",'Sheet',i+1);
    [k,~] = size(data);
    
    %応力・平均ひずみの出力
    for j=1:k
        stress(j) = data(j,3)/A0*1000;
        strain(j,1) = 0.5*(data(j,5) + data(j,7));
        strain(j,2) = -0.5*(data(j,6) + data(j,8));
    end
    stressmax = max(stress);        %応力最大値を取得する
    name = ["Stress(N/mm^2)";"Strain(縦)";"Strain(横)"];
      
    %平均値を取得する
    for m=1:k
        if (stress(m) > (0.1*stressmax)) && (stress(m) < (0.6*stressmax))
             avx = avx + strain(m,1);
             avy = avy + stress(m);
             avx2 = avx2 + strain(m,2);
             M = M+1;
        end
    end 
    avx = avx/M ; avy = avy/M; avx2 = avx2/M;
    
    %最小二乗法
    for m=1:k
        if (stress(m) > (0.1*stressmax)) && (stress(m) < (0.6*stressmax))
            Sxy = Sxy+(strain(m,1)-avx)*(stress(m)-avy);
            Sx2 = Sx2+(strain(m,1)-avx)^2;
            Sxy1 = Sxy1+(strain(m,2)-avx2)*(strain(m,1)-avx);
            Sxy2 = Sxy2+(strain(m,2)-avx2)^2;
        end
    end 
    Yongs = Sxy/Sx2*10^6;
    b = avy - Yongs * avx;
    Poissons = Sxy2/Sxy1;
   
    writematrix(name','材料試験まとめ.xlsx','Sheet',i+1,'range','K2');
    writematrix(stress','材料試験まとめ.xlsx','Sheet',i+1,'range','K3');
    writematrix(strain,'材料試験まとめ.xlsx','Sheet',i+1,'range','L3');
   makefig(strain(:,1),stress);
end
writematrix(Yongs,'材料試験まとめ.xlsx','Sheet',1,'range','H9');
writematrix(Poissons,'材料試験まとめ.xlsx','Sheet',1,'range','I9');
