% Universidade Federal de Uberlândia
%   Faculdade de Engenharia Mecânica
%    Curso de Engenharia Mecatrônica 
%   
%   Load IDdata a partir dos resultados experimentais
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

S_M2_14_01=importdata('EMax_E2216_CW_14_1S.mat');
F_M2_14_01=importdata('EMax_E2216_CW_14_1F.mat');

S_M2_20_01=importdata('EMax_E2216_CW_20_1S.mat');
F_M2_20_01=importdata('EMax_E2216_CW_20_1F.mat');

S_M2_30_01=importdata('EMax_E2216_CW_30_1S.mat');
F_M2_30_01=importdata('EMax_E2216_CW_30_1F.mat');

S_M2_40_01=importdata('EMax_E2216_CW_40_1S.mat');
F_M2_40_01=importdata('EMax_E2216_CW_40_1F.mat');

S_M2_30_50_01=importdata('EMax_E2216_CW_30-50_1S.mat');
F_M2_30_50_01=importdata('EMax_E2216_CW_30-50_1F.mat');

S_M2_30_50_02=importdata('EMax_E2216_CW_30-50_2S.mat');
F_M2_30_50_02=importdata('EMax_E2216_CW_30-50_2F.mat');

S_M2_30_50_03=importdata('EMax_E2216_CW_30-50_3S.mat');
F_M2_30_50_03=importdata('EMax_E2216_CW_30-50_3F.mat');

S_M2_37_43_01=importdata('EMax_E2216_CW_37-43_1S.mat');
F_M2_37_43_01=importdata('EMax_E2216_CW_37-43_1F.mat');

S_M2_37_43_02=importdata('EMax_E2216_CW_37-43_2S.mat');
F_M2_37_43_02=importdata('EMax_E2216_CW_37-43_2F.mat');

S_M2_37_43_03=importdata('EMax_E2216_CW_37-43_3S.mat');
F_M2_37_43_03=importdata('EMax_E2216_CW_37-43_3F.mat');



S_M1_14_01=importdata('EMax_E2216_CCW_14_1S.mat');
F_M1_14_01=importdata('EMax_E2216_CCW_14_1F.mat');

S_M1_20_01=importdata('EMax_E2216_CCW_20_1S.mat');
F_M1_20_01=importdata('EMax_E2216_CCW_20_1F.mat');

S_M1_30_01=importdata('EMax_E2216_CCW_30_1S.mat');
F_M1_30_01=importdata('EMax_E2216_CCW_30_1F.mat');

S_M1_40_01=importdata('EMax_E2216_CCW_40_1S.mat');
F_M1_40_01=importdata('EMax_E2216_CCW_40_1F.mat');

S_M1_50_01=importdata('EMax_E2216_CCW_50_1S.mat');
F_M1_50_01=importdata('EMax_E2216_CCW_50_1F.mat');

S_M1_30_50_01=importdata('EMax_E2216_CCW_30-50_1S.mat');
F_M1_30_50_01=importdata('EMax_E2216_CCW_30-50_1F.mat');

S_M1_30_50_02=importdata('EMax_E2216_CCW_30-50_2S.mat');
F_M1_30_50_02=importdata('EMax_E2216_CCW_30-50_2F.mat');

S_M1_30_50_03=importdata('EMax_E2216_CCW_30-50_3S.mat');
F_M1_30_50_03=importdata('EMax_E2216_CCW_30-50_3F.mat');


systemIdentification



