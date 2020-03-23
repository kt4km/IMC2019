clear all   % ワークスペースの初期化
close all   % Figureウィンドウを閉じる
clc         % コマンドウィンドウ初期化

% ===================================================== %
%        マス・ばね・ダンパ系のシミュレーションコード       %
% ===================================================== %

%----パラメータ設定----%
m = 1;    % 質量[kg]
k = 1;    % ばね定数[N/m]
c = 0.2;  % 減衰係数[N s/m]



%----シミュレーション----%
x1 = -5;    % 変位[m]
x2 = 0;    % 速度[m/s]
x = [x1 ; x2];    % 状態
t = 0;    % 時間[s]
Ns = 1000;    % 反復回数
dt = 0.1;    % 刻み幅[s]
Kp = 0.5;    % 比例ゲイン
Ki = 0.5;    % 積分ゲイン
Kd = 2;    % 微分ゲイン
r = 2;    % 目標値[m]
A = [0  1 ; -k/m  -c/m];    % 係数
B = [0 ; 1/m];    % 係数
e_sum = 0;


flag = 'control'    % 制御あり
% flag = 'noncontrol'    % 制御なし
for i = 1 : Ns+1
    x_h(:,i) = x;    % ステップ毎の状態を保存する
    t_h(:,i) = t;    % ステップ毎の時間を保存する


    % 偏差
    e = r - x(1,1);


    % 偏差の足し合わせ
    e_sum = e_sum + dt*e;
    

    % 入力(制御あり，なしで場合分けしてます)
    if strcmp(flag, 'noncontrol')
        u = 0;

    elseif strcmp(flag, 'control')
        if i == 1
            u = 0;    % 1step目は微分項が計算できないためu=0を代入する
        else
            u = Kp*e + Ki*e_sum + Kd*(e - e_before)/ dt;    % PID
        end
    end


    % 1つ前の偏差の保存
    e_before = e;


    % 状態方程式
    x_dot = A*x + B*u;


    % オイラー法
    x = x + dt*x_dot;    % 状態の更新


    t = t + dt;    % 時間の更新
end


%----計算結果をグラフで表示する----%

% % 横軸に時間，縦軸に台車の変位でプロットする
subplot(2, 1, 1)
    plot(t_h, x_h(1,:), '-r','LineWidth', 1)

    xlim([0 50])    % 横軸の範囲を指定
    ylabel('台車の変位[m]', 'FontSize', 12)    % 縦軸にラベルを貼る
    grid on     % グリッド線を引く

% 横軸に時間，縦軸に台車の速度でプロットする
subplot(2, 1, 2)
    plot(t_h, x_h(2,:), '-g','LineWidth', 1)

    xlim([0 50])
    xlabel('time[s]', 'FontSize', 12)
    ylabel('台車の速度[m/s]', 'FontSize', 12)
    grid on