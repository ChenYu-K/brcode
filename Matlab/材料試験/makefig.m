function createfigure(X1, Y1)
%CREATEFIGURE(X1, Y1)
%  X1:  x データのベクトル
%  Y1:  y データのベクトル

%  MATLAB からの自動生成日: 10-Jun-2021 19:17:36

% figure を作成
figure1 = figure;

% axes を作成
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% plot を作成
plot(X1,Y1,'MarkerSize',2,'LineWidth',0.75);

% ylabel を作成
ylabel('Stress (N/mm^2)','FontName','Times New Roman');

% xlabel を作成
xlabel('Strain','FontName','Times New Roman');

% Axes の X 軸の範囲を保持するために以下のラインのコメントを解除
 xlim(axes1,[0 90000]);
% Axes の Y 軸の範囲を保持するために以下のラインのコメントを解除
 ylim(axes1,[0 600]);
box(axes1,'on');
hold(axes1,'off');
% 残りの座標軸プロパティの設定
set(axes1,'YTick',[0 100 200 300 400 500 600]);
