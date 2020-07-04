% Universidade Federal de Uberl�ndia
%   Faculdade de Engenharia Mec�nica
%    Curso de Engenharia Mecatr�nica 
%   
%   Calibrando a balan�a
%   
%   Aluno: Gabriel Costa e Silva
% =================================
clear all
close all
clc

format bank
data_01 = dlmread('calibracaomaster.txt');

media=mean(data_01(200:end,2))

calibracao=(media/511)
y=media*ones((1975-199),1)

plot(data_01(200:end,1),data_01(200:end,2))

hold on

plot(data_01(200:end,1),y,'r')
