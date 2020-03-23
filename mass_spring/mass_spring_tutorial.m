clear all   % ���[�N�X�y�[�X�̏�����
close all   % Figure�E�B���h�E�����
clc         % �R�}���h�E�B���h�E������

% ===================================================== %
%        �}�X�E�΂ˁE�_���p�n�̃V�~�����[�V�����R�[�h       %
% ===================================================== %

%----�p�����[�^�ݒ�----%
m = 1;    % ����[kg]
k = 1;    % �΂˒萔[N/m]
c = 0.2;  % �����W��[N s/m]



%----�V�~�����[�V����----%
x1 = -5;    % �ψ�[m]
x2 = 0;    % ���x[m/s]
x = [x1 ; x2];    % ���
t = 0;    % ����[s]
Ns = 1000;    % ������
dt = 0.1;    % ���ݕ�[s]
Kp = 0.5;    % ���Q�C��
Ki = 0.5;    % �ϕ��Q�C��
Kd = 2;    % �����Q�C��
r = 2;    % �ڕW�l[m]
A = [0  1 ; -k/m  -c/m];    % �W��
B = [0 ; 1/m];    % �W��
e_sum = 0;


flag = 'control'    % ���䂠��
% flag = 'noncontrol'    % ����Ȃ�
for i = 1 : Ns+1
    x_h(:,i) = x;    % �X�e�b�v���̏�Ԃ�ۑ�����
    t_h(:,i) = t;    % �X�e�b�v���̎��Ԃ�ۑ�����


    % �΍�
    e = r - x(1,1);


    % �΍��̑������킹
    e_sum = e_sum + dt*e;
    

    % ����(���䂠��C�Ȃ��ŏꍇ�������Ă܂�)
    if strcmp(flag, 'noncontrol')
        u = 0;

    elseif strcmp(flag, 'control')
        if i == 1
            u = 0;    % 1step�ڂ͔��������v�Z�ł��Ȃ�����u=0��������
        else
            u = Kp*e + Ki*e_sum + Kd*(e - e_before)/ dt;    % PID
        end
    end


    % 1�O�̕΍��̕ۑ�
    e_before = e;


    % ��ԕ�����
    x_dot = A*x + B*u;


    % �I�C���[�@
    x = x + dt*x_dot;    % ��Ԃ̍X�V


    t = t + dt;    % ���Ԃ̍X�V
end


%----�v�Z���ʂ��O���t�ŕ\������----%

% % �����Ɏ��ԁC�c���ɑ�Ԃ̕ψʂŃv���b�g����
subplot(2, 1, 1)
    plot(t_h, x_h(1,:), '-r','LineWidth', 1)

    xlim([0 50])    % �����͈̔͂��w��
    ylabel('��Ԃ̕ψ�[m]', 'FontSize', 12)    % �c���Ƀ��x����\��
    grid on     % �O���b�h��������

% �����Ɏ��ԁC�c���ɑ�Ԃ̑��x�Ńv���b�g����
subplot(2, 1, 2)
    plot(t_h, x_h(2,:), '-g','LineWidth', 1)

    xlim([0 50])
    xlabel('time[s]', 'FontSize', 12)
    ylabel('��Ԃ̑��x[m/s]', 'FontSize', 12)
    grid on