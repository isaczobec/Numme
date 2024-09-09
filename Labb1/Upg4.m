%% a)
clearvars;close all;clc;

load 'dollarkurs.mat'
n = length(USDSEK);
% USDSEK = flipud(USDSEK);

plot(1:n,USDSEK')

