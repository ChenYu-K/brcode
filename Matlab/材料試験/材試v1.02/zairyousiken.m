
%%
clc                                 %�R�}���h�E�C���h�E���N���A����
clear                               %���[�N�X�y�[�X�̃N���A
file = dir(fullfile('*.csv'));      %csv�t�@�C���̏���S���ǂݍ���
filenames = {file.name};            %csv�t�@�C�������擾
[~,n] = size(filenames);            %csv�t�@�C���̌��𐔂���
A = readmatrix('template_mt.xlsx','sheet',1,'range','F6:F8');   %�f�ʐς��擾����

%�ϐ��̒�`
stressmax = 0; avx = 0; avy = 0; avx2 = 0;
Sxy = 0; Sx2 = 0; M = 0; Sxy1 = 0; Sxy2 = 0;

%%
%�S�Ẵf�[�^���s��ϊ�
%%%%figure
 figure1 =figure;
 axes1 = axes('Parent',figure1);
hold(axes1,'on');
ylabel({'Stress [N/mm^2]'});
xlabel({'Strain'});
%%%%%%%
for i = 1 : n
    stress_y(i) = 0;
    k = strcat(filenames(i));           %������ɕϊ�����
    data{i,1} = k{1,1};                 %���O��t����
    data{i,2} = readmatrix(k{1,1});     %�f�[�^������
    f = data{i,2};                      %data����i�s2��̃f�[�^�����o��
    f = f(:,3:8);                       %�v���f�[�^��3�`8��(�׏d�C�ψʁC�Ђ���*4)�����o��
    data{i,2} = f;
    [j,~]=size(data{i,2});      %�f�[�^���̗񐔂𐔂���
    
    if data{i,2}(round(j/2),4)>0          %�c�Ђ���2�𔻒肷��
        next;
    else 
            data{i,2}(:,[4,5]) =data{i,2}(:,[5,4]);         %���Ђ��݂Əc�Ђ��݂���ёւ���
    end
    
    %���́E���ςЂ��݂̏o��
    for m=1:j
        stress(m) = data{i,2}(m,1)/A(i)*1000;           %`���͂̏o��
        strain(m,1) = 0.5*(data{i,2}(m,3) + data{i,2}(m,4));
        strain(m,2) = -0.5*(data{i,2}(m,5) + data{i,2}(m,6));
        if strain(m,1) < 4000
            stress_y(i)=max(stress(m),stress_y(i));
        end
    end
    stressmax(i) = max(stress);        %���͍ő�l���擾����

    %���ϒl���擾����
    for m=1:j
        if (stress(m) > (0.1*stress_y(i))) && (stress(m) < (0.7*stress_y(i)))
             avx = avx + strain(m,1);
             avy = avy + stress(m);
             avx2 = avx2 + strain(m,2);
             M = M+1;
        end
    end 
    avx = avx/M ; avy = avy/M; avx2 = avx2/M;
    
    %�ŏ����@
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
    
    plot(strain(:,1),stress);       %�}�̒ǉ�
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
