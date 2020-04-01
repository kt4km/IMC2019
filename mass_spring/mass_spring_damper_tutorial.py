import numpy as np
import matplotlib.pyplot as plt

# ===================================================== # 
#       マス・ばね・ダンパ系のシミュレーションコード
# ===================================================== #

#----パラメータ設定----#
m = 1    # 質量[kg]
k = 1    # ばね定数[N/m]
c = 0.2  # 減衰係数[N s/m]



#----シミュレーション----#
x1 = -5    # 変位[m]
x2 = 0    # 速度[m/s]
x = np.array([[x1], [x2]])    # 状態
t = 0    # 時間[s]
Ns = 1000    # 反復回数
dt = 0.1    # 刻み幅[s]
Kp = 0.5    # 比例ゲイン
Ki = 0.5    # 積分ゲイン
Kd = 2    # 微分ゲイン
r = 2    # 目標値[m]
A = np.array([[0, 1], [-k/m, -c/m]])    # 係数
B = np.array([[0], [1/m]])    # 係数
e_sum = 0
x1_list = []     # 保存用の箱
x2_list = []
t_list = []     # 保存用の箱


# ====================================== #
# 制御ありと制御なしをflagでわけているので
# 各自コメントアウトで使い分けしてください
# ====================================== #
flag = 'control'    # 制御あり
# flag = 'noncontrol'    # 制御なし

for i in range(Ns+1):
    x1_list.append(x[0])    # ステップ毎の状態を保存する
    x2_list.append(x[1])
    t_list.append(t)    # ステップ毎の時間を保存する


    # 偏差
    e = r - x[0]


    # 偏差の足し合わせ
    e_sum = e_sum + dt*e


    # 入力(制御あり，なしで場合分けしてます)
    if flag == 'noncontrol':
        u = 0

    elif flag == 'control':
        if i == 0:
            u = 0    # 1step目は微分項が計算できないためu=0を代入する
        else:
            u = Kp*e + Ki*e_sum + Kd*(e - e_before)/ dt    # PID


    # 1つ前の偏差の保存
    e_before = e


    # 状態方程式
    x_dot = A.dot(x) + B*u


    # オイラー法
    x = x + dt*x_dot    # 状態の更新


    t = t + dt    # 時間の更新





#----計算結果をグラフで表示する----#
fig = plt.figure()

# 横軸に時間，縦軸に台車の変位でプロットする
ax1 = fig.add_subplot(2,1,1)    
ax1.plot(t_list, x1_list, color='red', linewidth=2)   
ax1.set_xlim(0,50)  # 横軸の範囲を指定
ax1.set_xticks(np.arange(0,50,5))   # x軸の目盛り0から50を5で分割する
ax1.set_ylabel('mass displacement[m]', fontsize=12)    # 縦軸にラベルを貼る
ax1.grid()  # グリッド線を引く

# 横軸に時間，縦軸に台車の速度でプロットする
ax2 = fig.add_subplot(2,1,2)
ax2.plot(t_list, x2_list, color='green', linewidth=2)
ax2.set_xlim(0,50)
ax2.set_xticks(np.arange(0,50,5))
ax2.set_xlabel('time[s]', fontsize=12)
ax2.set_ylabel('mass velocity[m/s]', fontsize=12)
ax2.grid ()

plt.show()  # グラフを表示する