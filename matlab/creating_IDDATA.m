% Universidade Federal de Uberlândia
%   Faculdade de Engenharia Mecânica
%    Curso de Engenharia Mecatrônica 
%   
%   Criando IDdata a partir dos resultados experimentais
%   
%   Aluno: Gabriel Costa e Silva
% =================================

close all
clear all
clc
% Constantes
rpm_2_rads=((2*pi)/60);
g_2_N=(10^-3*9.81);
g_2_mN=(9.81);



data_11 = dlmread('EMax_E2216_CW_14%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp14_CW_ExpNumber1')
save('EMax_E2216_CW_14_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp14_CW_ExpNumber1')
save('EMax_E2216_CW_14_1S.mat','data')


data_11 = dlmread('EMax_E2216_CW_20%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp20_CW_ExpNumber1')
save('EMax_E2216_CW_20_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp20_CW_ExpNumber1')
save('EMax_E2216_CW_20_1S.mat','data')


data_11 = dlmread('EMax_E2216_CW_30%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30_CW_ExpNumber1')
save('EMax_E2216_CW_30_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30_CW_ExpNumber1')
save('EMax_E2216_CW_30_1S.mat','data')

% data_11 = dlmread('EMax_E2216_CW_40%_1-c.txt');
% 
% data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp40_CW_ExpNumber1')
% save('EMax_E2216_CW_40_1F.mat','data')
% data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp40_CW_ExpNumber1')
% save('EMax_E2216_CW_40_1S.mat','data')

data_11 = dlmread('EMax_E2216_CW_30-50%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30-50_CW_ExpNumber1')
save('EMax_E2216_CW_30-50_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30-50_CW_ExpNumber1')
save('EMax_E2216_CW_30-50_1S.mat','data')

data_11 = dlmread('EMax_E2216_CW_30-50%_2-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30-50_CW_ExpNumber2')
save('EMax_E2216_CW_30-50_2F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30-50_CW_ExpNumber2')
save('EMax_E2216_CW_30-50_2S.mat','data')

data_11 = dlmread('EMax_E2216_CW_30-50%_3-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30-50_CW_ExpNumber3')
save('EMax_E2216_CW_30-50_3F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30-50_CW_ExpNumber3')
save('EMax_E2216_CW_30-50_3S.mat','data')

data_11 = dlmread('EMax_E2216_CW_37-43%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp37-43_CW_ExpNumber1')
save('EMax_E2216_CW_37-43_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp37-43_CW_ExpNumber1')
save('EMax_E2216_CW_37-43_1S.mat','data')

data_11 = dlmread('EMax_E2216_CW_37-43%_2-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp37-43_CW_ExpNumber2')
save('EMax_E2216_CW_37-43_2F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp37-43_CW_ExpNumber2')
save('EMax_E2216_CW_37-43_2S.mat','data')

data_11 = dlmread('EMax_E2216_CW_37-43%_3-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp37-43_CW_ExpNumber3')
save('EMax_E2216_CW_37-43_3F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp37-43_CW_ExpNumber3')
save('EMax_E2216_CW_37-43_3S.mat','data')



data_11 = dlmread('EMax_E2216_CCW_14%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp14_CCW_ExpNumber1')
save('EMax_E2216_CCW_14_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp14_CCW_ExpNumber1')
save('EMax_E2216_CCW_14_1S.mat','data')


data_11 = dlmread('EMax_E2216_CCW_20%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp20_CCW_ExpNumber1')
save('EMax_E2216_CCW_20_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp20_CCW_ExpNumber1')
save('EMax_E2216_CCW_20_1S.mat','data')


data_11 = dlmread('EMax_E2216_CCW_30%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30_CCW_ExpNumber1')
save('EMax_E2216_CCW_30_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30_CCW_ExpNumber1')
save('EMax_E2216_CCW_30_1S.mat','data')

data_11 = dlmread('EMax_E2216_CCW_40%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp40_CCW_ExpNumber1')
save('EMax_E2216_CCW_40_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp40_CCW_ExpNumber1')
save('EMax_E2216_CCW_40_1S.mat','data')

data_11 = dlmread('EMax_E2216_CCW_50%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp50_CCW_ExpNumber1')
save('EMax_E2216_CCW_50_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp50_CCW_ExpNumber1')
save('EMax_E2216_CCW_50_1S.mat','data')

data_11 = dlmread('EMax_E2216_CCW_30-50%_1-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30-50_CCW_ExpNumber1')
save('EMax_E2216_CCW_30-50_1F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30-50_CCW_ExpNumber1')
save('EMax_E2216_CCW_30-50_1S.mat','data')

data_11 = dlmread('EMax_E2216_CCW_30-50%_2-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30-50_CCW_ExpNumber2')
save('EMax_E2216_CCW_30-50_2F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30-50_CCW_ExpNumber2')
save('EMax_E2216_CCW_30-50_2S.mat','data')

data_11 = dlmread('EMax_E2216_CCW_30-50%_3-c.txt');

data = iddata((data_11(:,4)*g_2_mN),data_11(:,3),0.09,'ExperimentName','ForceExp_StepAmp30-50_CCW_ExpNumber3')
save('EMax_E2216_CCW_30-50_3F.mat','data')
data = iddata((data_11(:,5)*rpm_2_rads),data_11(:,3),0.09,'ExperimentName','SpeedExp_StepAmp30-50_CCW_ExpNumber3')
save('EMax_E2216_CCW_30-50_3S.mat','data')



